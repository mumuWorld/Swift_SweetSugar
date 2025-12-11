# KSCrash 实现机制深度分析

> 基于项目集成的 KSCrash 框架源码分析，重点深入底层实现机制

## 目录

- [1. 概述与基本原理](#1-概述与基本原理)
- [2. 整体架构设计](#2-整体架构设计)
- [3. 核心监控器源码分析](#3-核心监控器源码分析)
- [4. 崩溃信息收集机制](#4-崩溃信息收集机制)
- [5. 崩溃报告生成流程](#5-崩溃报告生成流程)
- [6. 配置与使用](#6-配置与使用)
- [7. 线程安全与异步安全](#7-线程安全与异步安全)
- [8. 最佳实践](#8-最佳实践)

---

## 1. 概述与基本原理

### 1.1 KSCrash 是什么

KSCrash 是一个强大的 iOS/macOS 崩溃报告框架，能够捕获多种类型的崩溃并生成详细的诊断报告。其核心优势在于：

- **完整性**：捕获几乎所有类型的崩溃（Mach 异常、Unix Signal、NSException、C++ 异常等）
- **安全性**：在崩溃处理中只使用异步安全的函数，避免二次崩溃
- **详细性**：收集丰富的上下文信息（线程堆栈、寄存器、内存、系统状态等）
- **灵活性**：支持多种报告格式和自定义扩展

### 1.2 崩溃捕获的基本原理

iOS/macOS 系统中的崩溃按照处理层级从底到高分为：

```
┌──────────────────────────────────────┐
│  应用层 (Application Layer)           │
│  - NSException                       │  ← 最高层，Objective-C 异常
└──────────────────────────────────────┘
           ↓ (未捕获则继续向下)
┌──────────────────────────────────────┐
│  C++ 异常层                           │
│  - C++ Exception (std::exception)   │
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│  信号层 (Signal Layer)               │
│  - SIGSEGV, SIGBUS, SIGABRT...      │  ← POSIX 信号
└──────────────────────────────────────┘
           ↓
┌──────────────────────────────────────┐
│  Mach 异常层 (Mach Exception)        │
│  - EXC_BAD_ACCESS, EXC_CRASH...     │  ← 最底层，内核级异常
└──────────────────────────────────────┘
```

**关键点**：

- Mach 异常是最底层的异常机制，内核会先产生 Mach 异常
- 如果 Mach 异常未被处理，内核会将其转换为对应的 Unix Signal
- Signal 如果未被处理，对于某些信号（如 SIGABRT），可能来自于未捕获的 NSException

### 1.3 与系统崩溃报告的区别

| 特性    | KSCrash     | 系统崩溃报告        |
| ----- | ----------- | ------------- |
| 实时性   | 立即可用        | 需要用户同意上传，有延迟  |
| 自定义信息 | 支持添加上下文信息   | 不支持           |
| 控制权   | 完全控制报告格式和上传 | 由系统控制         |
| 隐私    | 数据留在应用内     | 上传到 Apple 服务器 |
| 符号化   | 可离线符号化      | Apple 自动符号化   |

---

## 2. 整体架构设计

### 2.1 模块层次结构

KSCrash 采用分层设计，各模块职责清晰：

```
┌─────────────────────────────────────────────────────────────┐
│                   KSCrashInstallations                      │
│  安装配置层：提供开箱即用的安装方式                           │
│  - KSCrashInstallationConsole (控制台输出)                   │
│  - KSCrashInstallationEmail (邮件发送)                       │
│  - KSCrashInstallationStandard (HTTP 上传)                  │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                      KSCrash Core                           │
│  核心协调层：KSCrash.h/m, KSCrashC.h/c                      │
│  - 配置管理 (KSCrashConfiguration)                          │
│  - 生命周期控制                                              │
│  - 监控器协调                                                │
│  - 报告存储 (KSCrashReportStore)                            │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                  KSCrashRecordingCore                       │
│  监控核心层：实现各种崩溃监控器                               │
│  - KSCrashMonitor (监控器抽象接口)                          │
│  - KSCrashMonitorContext (崩溃上下文)                       │
│  - KSCrashMonitorHelper (辅助工具)                          │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                     Monitors (监控器)                        │
│  具体监控器实现：                                            │
│  ├─ KSCrashMonitor_MachException (Mach 异常)               │
│  ├─ KSCrashMonitor_Signal (Unix 信号)                      │
│  ├─ KSCrashMonitor_NSException (ObjC 异常)                 │
│  ├─ KSCrashMonitor_CPPException (C++ 异常)                 │
│  ├─ KSCrashMonitor_Deadlock (死锁检测)                      │
│  ├─ KSCrashMonitor_Zombie (僵尸对象)                        │
│  ├─ KSCrashMonitor_Memory (内存监控)                        │
│  └─ KSCrashMonitor_AppState (应用状态)                      │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              KSCrashReportC (报告生成)                       │
│  崩溃报告生成：                                              │
│  - KSCrashReportWriter (JSON 写入器)                        │
│  - 系统信息收集                                              │
│  - 线程堆栈遍历                                              │
│  - Binary Images 提取                                        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│              Filters & Sinks (过滤与输出)                    │
│  报告后处理：                                                │
│  - KSCrashReportFilter (报告过滤器链)                        │
│  - KSCrashReportSink (报告输出目标)                          │
│  - 格式转换 (JSON, AppleFmt, GZip...)                       │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 核心数据结构

#### 2.2.1 KSCrashMonitorAPI - 监控器接口

位置：`KSCrashRecordingCore/include/KSCrashMonitor.h:44-51`

```c
typedef struct {
    const char *(*monitorId)(void);                                    // 监控器唯一标识
    KSCrashMonitorFlag (*monitorFlags)(void);                         // 监控器标志位
    void (*setEnabled)(bool isEnabled);                               // 启用/禁用
    bool (*isEnabled)(void);                                          // 状态查询
    void (*addContextualInfoToEvent)(struct KSCrash_MonitorContext *); // 添加上下文
    void (*notifyPostSystemEnable)(void);                             // 系统启用后通知
} KSCrashMonitorAPI;
```

**设计亮点**：

- 采用函数指针表（类似 C++ 虚函数表），实现多态
- 所有监控器实现统一接口，便于统一管理
- 轻量级设计，符合 C 语言异步安全要求

#### 2.2.2 KSCrash_MonitorContext - 崩溃上下文

位置：`KSCrashRecordingCore/include/KSCrashMonitorContext.h:40-200+`

```c
typedef struct KSCrash_MonitorContext {
    // === 基础信息 ===
    const char *eventID;                    // 唯一事件 ID (UUID)
    bool currentSnapshotUserReported;       // 是否用户主动上报
    bool requiresAsyncSafety;               // 是否要求异步安全
    bool handlingCrash;                     // 是否正在处理崩溃
    bool crashedDuringCrashHandling;        // 崩溃处理中是否再次崩溃
    bool registersAreValid;                 // 寄存器信息是否有效
    bool isStackOverflow;                   // 是否栈溢出

    // === 崩溃现场 ===
    struct KSMachineContext *offendingMachineContext;  // 机器上下文（寄存器等）
    uintptr_t faultAddress;                            // 故障地址
    const char *monitorId;                             // 触发的监控器 ID
    KSCrashMonitorFlag monitorFlags;                   // 监控器标志
    const char *exceptionName;                         // 异常名称
    const char *crashReason;                           // 崩溃原因
    void *stackCursor;                                 // 堆栈游标 (KSStackCursor*)

    // === 异常类型特定信息 ===
    struct {
        int type;                          // Mach 异常类型
        int64_t code;                      // 异常代码
        int64_t subcode;                   // 子代码
    } mach;

    struct {
        const char *name;                  // NSException 名称
        const char *userInfo;              // userInfo 字符串
    } NSException;

    struct {
        const void *userContext;           // 用户上下文
        int signum;                        // 信号编号
        int sigcode;                       // 信号代码
    } signal;

    // === 应用状态 ===
    struct {
        double activeDurationSinceLastCrash;       // 距上次崩溃的活跃时长
        double backgroundDurationSinceLastCrash;   // 距上次崩溃的后台时长
        int launchesSinceLastCrash;                // 距上次崩溃的启动次数
        int sessionsSinceLastCrash;                // 距上次崩溃的会话次数
        // ... 更多状态字段
        bool applicationIsActive;                  // 应用是否活跃
        bool applicationIsInForeground;            // 应用是否在前台
    } AppState;

    // === 系统信息 ===
    struct {
        const char *systemName;
        const char *systemVersion;
        const char *machine;
        const char *model;
        // ... 更多系统字段
    } System;
} KSCrash_MonitorContext;
```

**设计亮点**：

- 使用 struct 嵌套组织不同类型的信息
- 所有字段都是异步安全的（指针指向预分配或栈上内存）
- 支持多种异常类型，每种类型有专属字段

---

## 3. 核心监控器源码分析

### 3.1 Mach Exception 监控器

> 源码位置：`KSCrashRecording/Monitors/KSCrashMonitor_MachException.c`

Mach 异常是 iOS/macOS 最底层的异常机制，能捕获几乎所有类型的崩溃。

#### 3.1.1 核心原理

**Mach 异常端口机制**：

- 每个 task（进程）和 thread（线程）都有一个异常端口（exception port）
- 当发生异常时，内核会向这个端口发送 Mach 消息
- 通过自定义异常端口，可以接管异常处理

#### 3.1.2 关键数据结构

```c
// Mach 异常消息结构（源码：86-103 行）
#pragma pack(4)
typedef struct {
    mach_msg_header_t header;              // Mach 消息头
    mach_msg_body_t body;                  // 消息体
    mach_msg_port_descriptor_t thread;     // 触发异常的线程
    mach_msg_port_descriptor_t task;       // 触发异常的任务
    NDR_record_t NDR;                      // 网络数据表示
    exception_type_t exception;            // 异常类型
    mach_msg_type_number_t codeCount;      // 代码数量
    mach_exception_data_type_t code[0];    // 异常代码和子代码
    char padding[512];                     // 填充避免 RCV_TOO_LARGE
} MachExceptionMessage;
#pragma pack()
```

**关键字段解释**：

- `exception`：异常类型，如 `EXC_BAD_ACCESS`（野指针）、`EXC_BAD_INSTRUCTION`（非法指令）
- `code[0]`：异常代码，如对于 `EXC_BAD_ACCESS`，表示是 `KERN_INVALID_ADDRESS`（无效地址）还是 `KERN_PROTECTION_FAILURE`（权限错误）
- `code[1]`：子代码，通常是触发异常的内存地址

#### 3.1.3 安装流程

**全局变量**（源码：125-155 行）：

```c
static volatile bool g_isEnabled = false;                // 是否启用
static mach_port_t g_exceptionPort = MACH_PORT_NULL;     // 我们的异常端口
static pthread_t g_primaryPThread;                       // 主异常处理线程
static thread_t g_primaryMachThread;
static pthread_t g_secondaryPThread;                     // 备用处理线程（防止主线程崩溃）
static thread_t g_secondaryMachThread;

// 保存之前的异常端口信息，用于恢复
static struct {
    exception_mask_t masks[EXC_TYPES_COUNT];
    exception_handler_t ports[EXC_TYPES_COUNT];
    exception_behavior_t behaviors[EXC_TYPES_COUNT];
    thread_state_flavor_t flavors[EXC_TYPES_COUNT];
    mach_msg_type_number_t count;
} g_previousExceptionPorts;
```

**安装步骤**（推断自源码逻辑）：

1. **创建异常端口**：
   
   ```c
   kern_return_t kr;
   kr = mach_port_allocate(mach_task_self(), MACH_PORT_RIGHT_RECEIVE, &g_exceptionPort);
   ```

2. **设置端口发送权限**：
   
   ```c
   kr = mach_port_insert_right(mach_task_self(), g_exceptionPort,
                             g_exceptionPort, MACH_MSG_TYPE_MAKE_SEND);
   ```

3. **保存原有异常端口**：
   
   ```c
   kr = task_get_exception_ports(mach_task_self(),
                               EXC_MASK_ALL,
                               g_previousExceptionPorts.masks,
                               &g_previousExceptionPorts.count,
                               g_previousExceptionPorts.ports,
                               g_previousExceptionPorts.behaviors,
                               g_previousExceptionPorts.flavors);
   ```

4. **设置我们的异常端口**：
   
   ```c
   kr = task_set_exception_ports(mach_task_self(),
                               EXC_MASK_BAD_ACCESS |
                               EXC_MASK_BAD_INSTRUCTION |
                               EXC_MASK_ARITHMETIC |
                               EXC_MASK_SOFTWARE |
                               EXC_MASK_BREAKPOINT,
                               g_exceptionPort,
                               EXCEPTION_DEFAULT | MACH_EXCEPTION_CODES,
                               THREAD_STATE_NONE);
   ```

5. **创建异常处理线程**：
   
   ```c
   pthread_create(&g_primaryPThread, NULL, &handleExceptions, (void*)kThreadPrimary);
   pthread_create(&g_secondaryPThread, NULL, &handleExceptions, (void*)kThreadSecondary);
   thread_suspend(g_secondaryMachThread);  // 备用线程先挂起
   ```

#### 3.1.4 异常处理流程

**handleExceptions 函数分析**（源码：257-300+ 行）：

```c
static void *handleExceptions(void *const userData)
{
    MachExceptionMessage exceptionMessage = { { 0 } };
    MachReplyMessage replyMessage = { { 0 } };
    char *eventID = g_primaryEventID;

    const char *threadName = (const char *)userData;
    pthread_setname_np(threadName);

    // 如果是备用线程，先挂起自己
    if (threadName == kThreadSecondary) {
        KSLOG_DEBUG("This is the secondary thread. Suspending.");
        thread_suspend((thread_t)ksthread_self());
        eventID = g_secondaryEventID;
    }

    // 无限循环等待异常
    for (;;) {
        KSLOG_DEBUG("Waiting for mach exception");

        // 1. 等待 Mach 消息（阻塞）
        kern_return_t kr = mach_msg(&exceptionMessage.header,
                                    MACH_RCV_MSG,           // 接收消息
                                    0,                      // 发送大小（不发送）
                                    sizeof(exceptionMessage), // 接收缓冲区大小
                                    g_exceptionPort,        // 接收端口
                                    MACH_MSG_TIMEOUT_NONE,  // 无超时（永久等待）
                                    MACH_PORT_NULL);
        if (kr == KERN_SUCCESS) {
            break;  // 收到异常消息，跳出循环
        }

        // 失败则继续尝试
        KSLOG_ERROR("mach_msg: %s", mach_error_string(kr));
    }

    // 2. 异常已捕获，记录信息
    KSLOG_DEBUG("Trapped mach exception code 0x%llx, subcode 0x%llx",
                exceptionMessage.code[0], exceptionMessage.code[1]);

    if (g_isEnabled) {
        // 3. 挂起所有其他线程（为了获取完整堆栈）
        thread_act_array_t threads = NULL;
        mach_msg_type_number_t numThreads = 0;
        ksmc_suspendEnvironment(&threads, &numThreads);
        g_isHandlingCrash = true;

        // 4. 通知其他监控器：致命异常已被捕获
        kscm_notifyFatalExceptionCaptured(true);  // true = 要求异步安全

        // 5. 如果当前是主处理线程崩溃，激活备用线程
        if (ksthread_self() == g_primaryMachThread) {
            KSLOG_DEBUG("Primary exception thread. Activating secondary thread.");
            // 激活备用线程继续处理
            if (thread_resume(g_secondaryMachThread) != KERN_SUCCESS) {
                // 激活失败，卸载异常处理器避免死循环
                KSLOG_DEBUG("Restoring original exception ports.");
                restoreExceptionPorts();
            }
        }

        // 6. 填充崩溃上下文
        KSMC_NEW_CONTEXT(machineContext);
        ksmc_getContextForThread(exceptionMessage.thread.name, machineContext, true);

        KSCrash_MonitorContext *crashContext = &g_monitorContext;
        memset(crashContext, 0, sizeof(*crashContext));
        crashContext->eventID = eventID;
        crashContext->offendingMachineContext = machineContext;
        crashContext->registersAreValid = true;
        crashContext->mach.type = exceptionMessage.exception;
        crashContext->mach.code = exceptionMessage.code[0];
        crashContext->mach.subcode = exceptionMessage.code[1];

        // 7. 将 Mach 异常转换为对应的 Signal（用于兼容性）
        crashContext->signal.signum = signalForMachException(
            exceptionMessage.exception,
            exceptionMessage.code[0]
        );

        // 8. 初始化堆栈游标
        kssc_initWithMachineContext(&g_stackCursor, KSSC_MAX_STACK_DEPTH, machineContext);
        crashContext->stackCursor = &g_stackCursor;

        // 9. 调用核心异常处理函数（生成崩溃报告）
        kscm_handleException(crashContext);

        // 10. 恢复线程环境
        ksmc_resumeEnvironment(threads, numThreads);
    }

    // 11. 恢复原有异常端口
    KSLOG_DEBUG("Restoring original exception ports.");
    restoreExceptionPorts();

    // 12. 回复 Mach 消息（告诉内核我们处理完了）
    replyMessage.header = exceptionMessage.header;
    replyMessage.NDR = exceptionMessage.NDR;
    replyMessage.returnCode = KERN_FAILURE;  // 让系统继续默认处理（终止进程）

    mach_msg(&replyMessage.header, MACH_SEND_MSG,
             sizeof(replyMessage), 0,
             MACH_PORT_NULL, MACH_MSG_TIMEOUT_NONE,
             MACH_PORT_NULL);

    return NULL;
}
```

#### 3.1.5 Mach 异常类型

**异常类型到信号的映射**（源码：191-247 行）：

```c
static int signalForMachException(exception_type_t exception, mach_exception_code_t code)
{
    switch (exception) {
        case EXC_ARITHMETIC:
            return SIGFPE;              // 浮点数异常
        case EXC_BAD_ACCESS:
            // 根据代码区分是段错误还是总线错误
            return code == KERN_INVALID_ADDRESS ? SIGSEGV : SIGBUS;
        case EXC_BAD_INSTRUCTION:
            return SIGILL;              // 非法指令
        case EXC_BREAKPOINT:
            return SIGTRAP;             // 断点/trace
        case EXC_SOFTWARE: {
            switch (code) {
                case EXC_UNIX_BAD_SYSCALL:
                    return SIGSYS;      // 非法系统调用
                case EXC_UNIX_BAD_PIPE:
                    return SIGPIPE;     // 管道破裂
                case EXC_UNIX_ABORT:
                    return SIGABRT;     // abort() 调用
            }
        }
    }
    return 0;
}
```

**常见崩溃类型**：

| Mach 异常                                  | Signal  | 典型原因                  |
| ---------------------------------------- | ------- | --------------------- |
| EXC_BAD_ACCESS + KERN_INVALID_ADDRESS    | SIGSEGV | 访问未分配内存（野指针、空指针）      |
| EXC_BAD_ACCESS + KERN_PROTECTION_FAILURE | SIGBUS  | 访问受保护内存（权限问题）         |
| EXC_BAD_INSTRUCTION                      | SIGILL  | 执行非法指令（代码损坏、错误的函数指针）  |
| EXC_ARITHMETIC                           | SIGFPE  | 除零、浮点溢出               |
| EXC_CRASH                                | SIGABRT | abort() 或 assert() 失败 |

---

### 3.2 Signal 监控器

> 源码位置：`KSCrashRecording/Monitors/KSCrashMonitor_Signal.c`

Signal 监控器捕获 POSIX 信号，是 Mach 异常的上层封装。

#### 3.2.1 为什么需要 Signal 监控器？

虽然 Mach 异常是最底层的，但有些情况下只有 Signal 能捕获：

1. **Mach 异常被其他库劫持**：某些第三方库也可能设置异常端口
2. **直接发送的信号**：如 `kill(pid, SIGABRT)` 不会产生 Mach 异常
3. **兼容性**：某些系统级信号不产生 Mach 异常

#### 3.2.2 关键数据结构

```c
// 全局变量（源码：55-69 行）
static volatile bool g_isEnabled = false;
static bool g_sigterm_monitoringEnabled = false;  // SIGTERM 是否监控

static KSCrash_MonitorContext g_monitorContext;
static KSStackCursor g_stackCursor;

#if KSCRASH_HAS_SIGNAL_STACK
static stack_t g_signalStack = { 0 };             // 独立信号栈
#endif

static struct sigaction *g_previousSignalHandlers = NULL;  // 原有信号处理器
static char g_eventID[37];
```

**信号栈（Signal Stack）**：

- 当发生栈溢出时，普通栈已不可用
- 通过 `sigaltstack()` 设置独立的信号处理栈
- 保证即使栈溢出也能执行信号处理函数

#### 3.2.3 安装流程

**installSignalHandler 函数**（源码：135-193 行）：

```c
static bool installSignalHandler(void)
{
    KSLOG_DEBUG("Installing signal handler.");

#if KSCRASH_HAS_SIGNAL_STACK
    // 1. 分配独立的信号栈（用于栈溢出时的处理）
    if (g_signalStack.ss_size == 0) {
        g_signalStack.ss_size = SIGSTKSZ;      // 通常 32KB
        g_signalStack.ss_sp = malloc(g_signalStack.ss_size);
    }

    // 2. 设置信号栈
    if (sigaltstack(&g_signalStack, NULL) != 0) {
        KSLOG_ERROR("signalstack: %s", strerror(errno));
        goto failed;
    }
#endif

    // 3. 获取需要监控的致命信号列表
    const int *fatalSignals = kssignal_fatalSignals();
    int fatalSignalsCount = kssignal_numFatalSignals();

    // 4. 分配内存存储原有的信号处理器
    if (g_previousSignalHandlers == NULL) {
        g_previousSignalHandlers = malloc(sizeof(*g_previousSignalHandlers) *
                                          (unsigned)fatalSignalsCount);
    }

    // 5. 配置 sigaction 结构
    struct sigaction action = { { 0 } };
    action.sa_flags = SA_SIGINFO | SA_ONSTACK;  // 使用 siginfo_t，使用独立栈
#if KSCRASH_HOST_APPLE && defined(__LP64__)
    action.sa_flags |= SA_64REGSET;             // 64 位寄存器集
#endif
    sigemptyset(&action.sa_mask);               // 不屏蔽其他信号
    action.sa_sigaction = &handleSignal;        // 设置处理函数

    // 6. 为每个致命信号安装处理器
    for (int i = 0; i < fatalSignalsCount; i++) {
        KSLOG_DEBUG("Assigning handler for signal %d", fatalSignals[i]);
        if (sigaction(fatalSignals[i], &action, &g_previousSignalHandlers[i]) != 0) {
            // 安装失败，回滚已安装的
            for (i--; i >= 0; i--) {
                sigaction(fatalSignals[i], &g_previousSignalHandlers[i], NULL);
            }
            goto failed;
        }
    }

    return true;

failed:
    return false;
}
```

**监控的致命信号**（通常包括）：

- `SIGABRT`：abort() 调用
- `SIGBUS`：总线错误（对齐问题、访问不存在的物理地址）
- `SIGFPE`：浮点异常
- `SIGILL`：非法指令
- `SIGPIPE`：管道破裂
- `SIGSEGV`：段错误（最常见的崩溃）
- `SIGSYS`：非法系统调用
- `SIGTRAP`：trace/breakpoint trap
- `SIGTERM`：终止信号（可选监控）

#### 3.2.4 信号处理流程

**handleSignal 函数**（源码：94-129 行）：

```c
static void handleSignal(int sigNum, siginfo_t *signalInfo, void *userContext)
{
    KSLOG_DEBUG("Trapped signal %d", sigNum);

    if (g_isEnabled && shouldHandleSignal(sigNum)) {
        // 1. 挂起所有线程
        thread_act_array_t threads = NULL;
        mach_msg_type_number_t numThreads = 0;
        ksmc_suspendEnvironment(&threads, &numThreads);

        // 2. 通知：致命异常已捕获（false = 非完全异步安全环境）
        kscm_notifyFatalExceptionCaptured(false);

        // 3. 获取机器上下文（寄存器状态）
        KSMC_NEW_CONTEXT(machineContext);
        ksmc_getContextForSignal(userContext, machineContext);

        // 4. 初始化堆栈游标
        kssc_initWithMachineContext(&g_stackCursor, KSSC_MAX_STACK_DEPTH, machineContext);

        // 5. 填充崩溃上下文
        KSCrash_MonitorContext *crashContext = &g_monitorContext;
        memset(crashContext, 0, sizeof(*crashContext));
        ksmc_fillMonitorContext(crashContext, kscm_signal_getAPI());
        crashContext->eventID = g_eventID;
        crashContext->offendingMachineContext = machineContext;
        crashContext->registersAreValid = true;
        crashContext->faultAddress = (uintptr_t)signalInfo->si_addr;  // 故障地址
        crashContext->signal.userContext = userContext;
        crashContext->signal.signum = signalInfo->si_signo;            // 信号编号
        crashContext->signal.sigcode = signalInfo->si_code;            // 信号代码
        crashContext->stackCursor = &g_stackCursor;

        // 6. 处理异常（生成报告）
        kscm_handleException(crashContext);

        // 7. 恢复线程
        ksmc_resumeEnvironment(threads, numThreads);
    } else {
        // 如果不处理，卸载处理器并通知内存监控器
        uninstallSignalHandler();
        ksmemory_notifyUnhandledFatalSignal();
    }

    // 8. 重新触发信号，让系统默认处理（终止进程）
    KSLOG_DEBUG("Re-raising signal for regular handlers to catch.");
    raise(sigNum);
}
```

**关键点**：

- `siginfo_t` 包含详细的信号信息，如 `si_addr`（触发信号的地址）
- `userContext` 包含信号发生时的 CPU 寄存器状态
- 最后 `raise(sigNum)` 重新触发信号，确保进程会终止

---

### 3.3 NSException 监控器

> 源码位置：`KSCrashRecording/Monitors/KSCrashMonitor_NSException.m`

NSException 监控器捕获 Objective-C 层面的异常。

#### 3.3.1 核心原理

通过 `NSSetUncaughtExceptionHandler()` 注册全局异常处理器：

```objective-c
// 源码：165-181 行
static void setEnabled(bool isEnabled)
{
    if (isEnabled != g_isEnabled) {
        g_isEnabled = isEnabled;
        if (isEnabled) {
            // 1. 备份原有处理器
            KSLOG_DEBUG(@"Backing up original handler.");
            g_previousUncaughtExceptionHandler = NSGetUncaughtExceptionHandler();

            // 2. 设置我们的处理器
            KSLOG_DEBUG(@"Setting new handler.");
            NSSetUncaughtExceptionHandler(&handleUncaughtException);
            KSCrash.sharedInstance.uncaughtExceptionHandler = &handleUncaughtException;
            KSCrash.sharedInstance.customNSExceptionReporter = &customNSExceptionReporter;
        } else {
            // 恢复原有处理器
            KSLOG_DEBUG(@"Restoring original handler.");
            NSSetUncaughtExceptionHandler(g_previousUncaughtExceptionHandler);
        }
    }
}
```

**与你的 AppDelegate 代码对比**（`AppDelegate.swift:20-31`）：

```swift
func setupUncaughtExceptionHandler() {
    previousExceptionHandler = NSGetUncaughtExceptionHandler()
    NSSetUncaughtExceptionHandler { exception in
        handleUncaughtException(exception)
        previousExceptionHandler?(exception)  // 链式调用
    }
}
```

你的代码与 KSCrash 会形成处理器链：

1. 你的 handler 先执行
2. 调用 previousExceptionHandler（实际是 KSCrash 的 handler）
3. KSCrash 处理并生成报告
4. KSCrash 调用它保存的 previousExceptionHandler

#### 3.3.2 异常处理流程

**handleException 函数**（源码：94-147 行）：

```objective-c
static void handleException(NSException *exception, BOOL isUserReported, BOOL logAllThreads)
{
    KSLOG_DEBUG(@"Trapped exception %@", exception);

    if (g_isEnabled) {
        thread_act_array_t threads = NULL;
        mach_msg_type_number_t numThreads = 0;

        // 1. 如果需要记录所有线程，挂起环境
        if (logAllThreads) {
            ksmc_suspendEnvironment(&threads, &numThreads);
        }

        // 2. 用户主动上报的异常不被视为致命异常
        if (isUserReported == NO) {
            kscm_notifyFatalExceptionCaptured(false);
        }

        // 3. 生成事件 ID
        char eventID[37];
        ksid_generate(eventID);

        // 4. 获取当前线程的机器上下文
        KSMC_NEW_CONTEXT(machineContext);
        ksmc_getContextForThread(ksthread_self(), machineContext, true);

        // 5. 初始化堆栈游标
        KSStackCursor cursor;
        uintptr_t *callstack = NULL;
        initStackCursor(&cursor, exception, callstack, isUserReported);

        // 6. 转换 userInfo 为字符串
        NSString *userInfoString = exception.userInfo != nil ?
            [NSString stringWithFormat:@"%@", exception.userInfo] : nil;

        // 7. 填充崩溃上下文
        KSCrash_MonitorContext *crashContext = &g_monitorContext;
        memset(crashContext, 0, sizeof(*crashContext));
        crashContext->eventID = eventID;
        crashContext->offendingMachineContext = machineContext;
        crashContext->registersAreValid = false;  // NSException 没有准确寄存器
        crashContext->NSException.name = [[exception name] UTF8String];
        crashContext->NSException.userInfo = [userInfoString UTF8String];
        crashContext->exceptionName = crashContext->NSException.name;
        crashContext->crashReason = [[exception reason] UTF8String];
        crashContext->stackCursor = &cursor;
        crashContext->currentSnapshotUserReported = isUserReported;

        // 8. 处理异常
        kscm_handleException(crashContext);

        // 9. 清理和恢复
        free(callstack);
        if (logAllThreads && isUserReported) {
            ksmc_resumeEnvironment(threads, numThreads);
        }

        // 10. 调用原有异常处理器（如果有）
        if (isUserReported == NO && g_previousUncaughtExceptionHandler != NULL) {
            KSLOG_DEBUG(@"Calling original exception handler.");
            g_previousUncaughtExceptionHandler(exception);
        }
    }
}
```

#### 3.3.3 堆栈提取

**initStackCursor 函数**（源码：58-87 行）：

```objective-c
static void initStackCursor(KSStackCursor *cursor, NSException *exception,
                            uintptr_t *callstack, BOOL isUserReported)
{
    // 1. 优先使用 NSException 自带的堆栈
    NSArray *addresses = [exception callStackReturnAddresses];
    NSUInteger numFrames = addresses.count;

    if (numFrames != 0) {
        // 从 NSArray 提取地址到 C 数组
        callstack = malloc(numFrames * sizeof(*callstack));
        for (NSUInteger i = 0; i < numFrames; i++) {
            callstack[i] = (uintptr_t)[addresses[i] unsignedLongLongValue];
        }
        kssc_initWithBacktrace(cursor, callstack, (int)numFrames, 0);
    } else {
        // 2. 如果没有堆栈信息（用户主动上报的情况），获取当前线程堆栈
        // 跳过的帧数：
        // - 用户上报：跳过 4 帧（initStackCursor, handleException,
        //   customNSExceptionReporter, +[KSCrash reportNSException:logAllThreads:]）
        // - 捕获的异常：跳过 3 帧（initStackCursor, handleException,
        //   handleUncaughtException）
        int const skipFrames = isUserReported ? 4 : 3;
        kssc_initSelfThread(cursor, skipFrames);
    }
}
```

**关键点**：

- `[NSException callStackReturnAddresses]` 返回异常抛出时的堆栈地址数组
- 如果没有堆栈信息，使用 `backtrace()` 获取当前线程堆栈
- 需要跳过 KSCrash 自身的处理函数帧

---

### 3.4 监控器协调机制

#### 3.4.1 监控器注册

**kscm_addMonitor 函数**（`KSCrashMonitor.c`）：

```c
bool kscm_addMonitor(KSCrashMonitorAPI *api)
{
    // 1. 检查 API 有效性
    if (api == NULL || api->monitorId == NULL) {
        return false;
    }

    // 2. 检查是否已存在（避免重复注册）
    for (int i = 0; i < g_monitorsCount; i++) {
        if (g_monitors[i] == api) {
            return false;  // 已存在
        }
        if (strcmp(g_monitors[i]->monitorId(), api->monitorId()) == 0) {
            return false;  // ID 冲突
        }
    }

    // 3. 添加到监控器列表
    if (g_monitorsCount < MAX_MONITORS) {
        g_monitors[g_monitorsCount++] = api;
        return true;
    }

    return false;
}
```

#### 3.4.2 监控器激活

**kscm_activateMonitors 函数**：

```c
bool kscm_activateMonitors(void)
{
    bool isDebuggerAttached = kscdebug_isBeingTraced();
    int activatedCount = 0;

    for (int i = 0; i < g_monitorsCount; i++) {
        KSCrashMonitorAPI *api = g_monitors[i];
        KSCrashMonitorFlag flags = api->monitorFlags();

        // 1. 如果调试器附加，跳过非调试器安全的监控器
        if (isDebuggerAttached && !(flags & KSCrashMonitorFlagDebuggerSafe)) {
            continue;
        }

        // 2. 启用监控器
        api->setEnabled(true);

        // 3. 检查是否成功启用
        if (api->isEnabled()) {
            activatedCount++;

            // 4. 调用系统启用后的通知（如果有）
            if (api->notifyPostSystemEnable) {
                api->notifyPostSystemEnable();
            }
        }
    }

    return activatedCount > 0;
}
```

**MonitorFlag 说明**：

```c
typedef enum {
    KSCrashMonitorFlagNone = 0,
    KSCrashMonitorFlagFatal = 1 << 0,          // 致命崩溃（会终止进程）
    KSCrashMonitorFlagAsyncSafe = 1 << 1,      // 异步安全（可在信号处理中使用）
    KSCrashMonitorFlagDebuggerSafe = 1 << 2,   // 调试器安全（调试时可用）
    KSCrashMonitorFlagManual = 1 << 3,         // 手动触发
} KSCrashMonitorFlag;
```

**各监控器的 Flag**：

| 监控器           | Flag               | 说明                |
| ------------- | ------------------ | ----------------- |
| MachException | Fatal \| AsyncSafe | 致命且异步安全           |
| Signal        | Fatal \| AsyncSafe | 致命且异步安全           |
| NSException   | Fatal              | 致命但非异步安全（使用 ObjC） |
| CPPException  | Fatal              | 致命但非异步安全（使用 C++）  |
| User          | Manual             | 手动触发              |
| AppState      | None               | 仅收集信息             |
| Memory        | None               | 仅监控               |

---

## 4. 崩溃信息收集机制

### 4.1 KSCrash_MonitorContext 深度解析

位置：`KSCrashRecordingCore/include/KSCrashMonitorContext.h`

这个结构体是崩溃信息收集的核心，包含了生成完整崩溃报告所需的所有信息。

#### 4.1.1 信息分类

**1. 基础元信息**：

```c
const char *eventID;                    // UUID，唯一标识这次崩溃
const char *monitorId;                  // 捕获崩溃的监控器名称
KSCrashMonitorFlag monitorFlags;        // 监控器标志
bool currentSnapshotUserReported;       // 是否用户主动上报
bool requiresAsyncSafety;               // 是否要求异步安全
bool handlingCrash;                     // 是否正在处理崩溃
bool crashedDuringCrashHandling;        // 处理崩溃时是否再次崩溃
```

**2. 崩溃现场信息**：

```c
struct KSMachineContext *offendingMachineContext;  // CPU 寄存器状态
bool registersAreValid;                            // 寄存器是否有效
uintptr_t faultAddress;                            // 触发崩溃的内存地址
bool isStackOverflow;                              // 是否栈溢出
void *stackCursor;                                 // 堆栈游标（用于遍历堆栈）
const char *exceptionName;                         // 异常名称
const char *crashReason;                           // 崩溃原因描述
bool omitBinaryImages;                             // 是否省略二进制镜像列表
```

**3. 异常类型特定信息**：

```c
// Mach 异常
struct {
    int type;              // EXC_BAD_ACCESS, EXC_CRASH 等
    int64_t code;          // KERN_INVALID_ADDRESS 等
    int64_t subcode;       // 通常是故障地址
} mach;

// Unix 信号
struct {
    const void *userContext;  // ucontext_t 指针
    int signum;               // SIGSEGV, SIGABRT 等
    int sigcode;              // SI_USER, SEGV_MAPERR 等
} signal;

// Objective-C 异常
struct {
    const char *name;         // NSRangeException, NSInvalidArgumentException 等
    const char *userInfo;     // userInfo 字典的字符串表示
} NSException;

// C++ 异常
struct {
    const char *name;         // std::exception 类型名
} CPPException;

// 用户自定义异常
struct {
    const char *name;
    const char *language;         // "javascript", "lua" 等
    const char *lineOfCode;       // 出错的代码行
    const char *customStackTrace; // JSON 格式的堆栈
} userException;
```

**4. 应用状态信息**：

```c
struct {
    // 距上次崩溃
    double activeDurationSinceLastCrash;
    double backgroundDurationSinceLastCrash;
    int launchesSinceLastCrash;
    int sessionsSinceLastCrash;

    // 本次启动
    double activeDurationSinceLaunch;
    double backgroundDurationSinceLaunch;
    int sessionsSinceLaunch;

    // 崩溃历史
    bool crashedLastLaunch;
    bool crashedThisLaunch;

    // 当前状态
    double appStateTransitionTime;
    bool applicationIsActive;
    bool applicationIsInForeground;
} AppState;
```

**5. 系统信息**：

```c
struct {
    const char *systemName;          // "iOS", "macOS"
    const char *systemVersion;       // "15.0"
    const char *machine;             // "iPhone14,2"
    const char *model;               // "iPhone 13 Pro"
    const char *kernelVersion;       // Darwin 内核版本
    const char *osVersion;           // OS 构建版本
    bool isJailbroken;               // 是否越狱
    const char *bootTime;            // 系统启动时间
    const char *appStartTime;        // 应用启动时间
    const char *executablePath;      // 可执行文件路径
    const char *executableName;      // 可执行文件名
    const char *bundleID;            // Bundle Identifier
    const char *bundleName;          // Bundle 名称
    const char *bundleVersion;       // 版本号
    const char *bundleShortVersion;  // 短版本号
    const char *appID;               // 应用 ID
    const char *cpuArchitecture;     // "arm64", "x86_64"
    int cpuType;                     // CPU 类型
    int cpuSubType;                  // CPU 子类型
    int binaryCPUType;               // 二进制 CPU 类型
    int binaryCPUSubType;            // 二进制 CPU 子类型
    const char *timeZone;            // 时区
    const char *processName;         // 进程名
    int processID;                   // 进程 ID
    int parentProcessID;             // 父进程 ID
    const char *deviceAppHash;       // 设备+应用哈希
    const char *buildType;           // "Debug", "Release"
    uint64_t storageSize;            // 存储空间
    uint64_t memorySize;             // 内存大小
    uint64_t freeMemory;             // 可用内存
    uint64_t usableMemory;           // 可用内存（应用可用）
} System;
```

### 4.2 机器上下文（KSMachineContext）

#### 4.2.1 寄存器状态

寄存器保存了崩溃瞬间 CPU 的状态，对于分析崩溃至关重要。

**ARM64 架构**（`KSMachineContext.h`）：

```c
typedef struct KSMachineContext {
    thread_t thread;                    // Mach 线程

    // 通用寄存器
    _STRUCT_MCONTEXT64 *machineContext; // ucontext

    bool isCurrentThread;               // 是否当前线程
    bool isStackOverflow;               // 是否栈溢出
    bool isCrashedContext;              // 是否崩溃上下文

    const char *threadName;             // 线程名称
} KSMachineContext;
```

**ARM64 寄存器布局**：

```c
// _STRUCT_ARM_THREAD_STATE64
struct {
    uint64_t x[29];      // x0-x28 通用寄存器
    uint64_t fp;         // x29 帧指针（Frame Pointer）
    uint64_t lr;         // x30 链接寄存器（Link Register，返回地址）
    uint64_t sp;         // x31 栈指针（Stack Pointer）
    uint64_t pc;         // 程序计数器（Program Counter，指令地址）
    uint32_t cpsr;       // 当前程序状态寄存器
    uint32_t __reserved;
};
```

**关键寄存器**：

- **PC (Program Counter)**：崩溃时正在执行的指令地址
- **LR (Link Register)**：函数返回地址（用于回溯调用栈）
- **SP (Stack Pointer)**：当前栈顶地址
- **FP (Frame Pointer)**：当前栈帧基址
- **x0-x7**：函数参数和返回值
- **x8-x15**：临时寄存器

#### 4.2.2 获取机器上下文

**从信号处理器中获取**（`KSMachineContext.c`）：

```c
void ksmc_getContextForSignal(void *userContext, KSMachineContext *context)
{
    // userContext 是 ucontext_t 指针
    _STRUCT_UCONTEXT *ucontext = (_STRUCT_UCONTEXT *)userContext;
    context->machineContext = ucontext->uc_mcontext;
    context->isCurrentThread = true;
    context->isCrashedContext = true;
}
```

**从 Mach 异常中获取**：

```c
bool ksmc_getContextForThread(thread_t thread, KSMachineContext *context, bool isCrashedContext)
{
    // 1. 分配机器上下文结构
    context->machineContext = malloc(sizeof(*context->machineContext));

    // 2. 获取线程状态
    mach_msg_type_number_t stateCount = MACHINE_THREAD_STATE_COUNT;
    kern_return_t kr = thread_get_state(thread,
                                        MACHINE_THREAD_STATE,
                                        (thread_state_t)&context->machineContext->__ss,
                                        &stateCount);

    // 3. 获取异常状态（如果是崩溃上下文）
    if (isCrashedContext) {
        stateCount = MACHINE_EXCEPTION_STATE_COUNT;
        kr = thread_get_state(thread,
                              MACHINE_EXCEPTION_STATE,
                              (thread_state_t)&context->machineContext->__es,
                              &stateCount);
    }

    context->thread = thread;
    context->isCurrentThread = (thread == ksthread_self());
    context->isCrashedContext = isCrashedContext;

    return kr == KERN_SUCCESS;
}
```

### 4.3 堆栈回溯（Stack Unwinding）

堆栈回溯是崩溃分析的核心，用于确定崩溃时的函数调用链。

#### 4.3.1 堆栈帧（Stack Frame）

每次函数调用都会在栈上创建一个帧：

```
栈增长方向 ↓

高地址
┌─────────────────────┐
│  调用者的栈帧       │
├─────────────────────┤ ← 调用者的 SP
│  返回地址 (LR)      │  函数返回后继续执行的地址
├─────────────────────┤
│  前一个帧的 FP      │  指向调用者栈帧
├─────────────────────┤ ← 当前 FP
│  局部变量           │
│  ...                │
├─────────────────────┤ ← 当前 SP
│  （未使用空间）     │
└─────────────────────┘
低地址
```

#### 4.3.2 堆栈游标（KSStackCursor）

位置：`KSCrashRecordingCore/include/KSStackCursor.h`

```c
typedef struct KSStackCursor {
    // 状态
    uintptr_t address;              // 当前帧的返回地址
    uintptr_t stackDepth;           // 栈深度（帧数）

    // 符号化信息
    const char *symbolName;         // 符号名称
    uintptr_t symbolAddress;        // 符号地址
    const char *imageName;          // 所属镜像名称
    uintptr_t imageAddress;         // 镜像加载地址

    // 控制
    bool (*advanceCursor)(struct KSStackCursor *cursor);  // 前进到下一帧
    bool (*resetCursor)(struct KSStackCursor *cursor);    // 重置游标

    // 内部状态
    void *context;                  // 实现相关的上下文
} KSStackCursor;
```

#### 4.3.3 基于 FP 的回溯

**kssc_initWithMachineContext 实现思路**：

```c
bool advanceCursor_FP(KSStackCursor *cursor)
{
    KSMachineContext *context = (KSMachineContext *)cursor->context;

    // 1. 获取当前 FP 和 LR
    uintptr_t currentFP = ksmc_framePointer(context);
    uintptr_t returnAddress = ksmc_linkRegister(context);

    // 2. 检查 FP 有效性（防止栈损坏导致的无限循环）
    if (currentFP == 0 || !ksmem_isMemoryReadable((void *)currentFP, sizeof(uintptr_t) * 2)) {
        return false;  // 到达栈底或栈已损坏
    }

    // 3. 读取下一帧的 FP 和返回地址
    uintptr_t *framePtr = (uintptr_t *)currentFP;
    uintptr_t nextFP = framePtr[0];      // 前一个 FP
    uintptr_t nextLR = framePtr[1];      // 返回地址

    // 4. 更新游标
    cursor->address = returnAddress;
    cursor->stackDepth++;

    // 5. 更新上下文的 FP 和 LR
    ksmc_setFramePointer(context, nextFP);
    ksmc_setLinkRegister(context, nextLR);

    return true;
}
```

**堆栈深度限制**：

```c
#define KSSC_MAX_STACK_DEPTH 200  // 防止栈损坏导致无限回溯
```

#### 4.3.4 符号化（Symbolication）

**查找符号信息**（`KSSymbolicator.c`）：

```c
bool ksbt_symbolicate(const uintptr_t address, KSSymbolicationInfo *info)
{
    // 1. 查找包含该地址的镜像（dylib/framework）
    Dl_info dlinfo;
    if (dladdr((void *)address, &dlinfo) == 0) {
        return false;
    }

    // 2. 填充符号信息
    info->imageAddress = (uintptr_t)dlinfo.dli_fbase;    // 镜像基址
    info->imageName = dlinfo.dli_fname;                  // 镜像路径
    info->symbolAddress = (uintptr_t)dlinfo.dli_saddr;   // 符号地址
    info->symbolName = dlinfo.dli_sname;                 // 符号名称

    // 3. 计算偏移量
    info->offset = address - info->symbolAddress;

    return true;
}
```

**符号化结果示例**：

```
地址: 0x0000000102a3c4f8
镜像: /path/to/MyApp.app/MyApp (0x0000000102a00000)
符号: -[ViewController buttonTapped:] (0x0000000102a3c4e0)
偏移: +24
```

完整表示：`-[ViewController buttonTapped:] + 24`

### 4.4 Binary Images 收集

Binary Images 是符号化的关键信息，包含所有已加载的动态库和可执行文件。

#### 4.4.1 镜像信息结构

```c
typedef struct {
    const char *name;           // 镜像路径
    uintptr_t address;          // 加载地址（ASLR 后的地址）
    uintptr_t size;             // 镜像大小
    uuid_t uuid;                // UUID（用于匹配 dSYM）
    int cpuType;                // CPU 类型
    int cpuSubType;             // CPU 子类型
} KSBinaryImage;
```

#### 4.4.2 遍历已加载镜像

**使用 dyld API**（`KSBinaryImage.c`）：

```c
void ksbinaryimage_get_images(void (*callback)(KSBinaryImage *image, void *context), void *context)
{
    // 1. 获取镜像数量
    uint32_t imageCount = _dyld_image_count();

    // 2. 遍历每个镜像
    for (uint32_t i = 0; i < imageCount; i++) {
        // 获取镜像头部
        const struct mach_header *header = _dyld_get_image_header(i);
        if (header == NULL) continue;

        // 获取镜像名称
        const char *name = _dyld_get_image_name(i);

        // 获取镜像滑动偏移（ASLR）
        intptr_t vmaddr_slide = _dyld_get_image_vmaddr_slide(i);

        KSBinaryImage image;
        image.name = name;
        image.address = (uintptr_t)header + vmaddr_slide;

        // 3. 提取 UUID
        extractUUID(header, image.uuid);

        // 4. 提取 CPU 类型
        image.cpuType = header->cputype;
        image.cpuSubType = header->cpusubtype;

        // 5. 计算镜像大小
        image.size = calculateImageSize(header);

        // 6. 回调
        callback(&image, context);
    }
}
```

#### 4.4.3 UUID 提取

UUID 用于匹配崩溃报告和 dSYM 文件：

```c
bool extractUUID(const struct mach_header *header, uuid_t uuid)
{
    // 1. 遍历 Load Commands
    const uint8_t *ptr = (const uint8_t *)(header + 1);
    for (uint32_t i = 0; i < header->ncmds; i++) {
        const struct load_command *cmd = (const struct load_command *)ptr;

        // 2. 查找 LC_UUID 命令
        if (cmd->cmd == LC_UUID) {
            const struct uuid_command *uuidCmd = (const struct uuid_command *)cmd;
            memcpy(uuid, uuidCmd->uuid, sizeof(uuid_t));
            return true;
        }

        ptr += cmd->cmdsize;
    }

    return false;
}
```

---

## 5. 崩溃报告生成流程

### 5.1 整体流程

```
崩溃发生
    ↓
监控器捕获（Mach/Signal/NSException）
    ↓
填充 KSCrash_MonitorContext
    ↓
kscm_handleException(context)
    ↓
kscrashreport_writeStandardReport(context, path)
    ↓
    ├─ 打开文件
    ├─ 写入 JSON 报告头
    ├─ 写入 Report 部分
    │   ├─ ID 和时间戳
    │   ├─ 类型（crash/user_reported）
    │   └─ 版本
    ├─ 写入 Crash 部分
    │   ├─ 错误信息（error）
    │   ├─ 线程列表（threads）
    │   └─ 诊断信息（diagnosis）
    ├─ 写入 Binary Images
    ├─ 写入 System 信息
    ├─ 写入 Process 信息
    ├─ 写入 User 信息
    └─ 写入 Debug 信息（如果需要）
    ↓
关闭文件
    ↓
恢复环境/终止进程
```

### 5.2 JSON Writer 接口

位置：`KSCrashRecording/include/KSCrashReportWriter.h`

```c
typedef struct {
    // 基础写入
    void (*addBooleanElement)(const KSCrashReportWriter *writer, const char *name, bool value);
    void (*addIntegerElement)(const KSCrashReportWriter *writer, const char *name, int64_t value);
    void (*addFloatingPointElement)(const KSCrashReportWriter *writer, const char *name, double value);
    void (*addStringElement)(const KSCrashReportWriter *writer, const char *name, const char *value);
    void (*addDataElement)(const KSCrashReportWriter *writer, const char *name, const char *value, size_t length);
    void (*addUUIDElement)(const KSCrashReportWriter *writer, const char *name, const unsigned char *value);
    void (*addJSONElement)(const KSCrashReportWriter *writer, const char *name, const char *jsonElement);
    void (*addNullElement)(const KSCrashReportWriter *writer, const char *name);

    // 容器
    void (*beginObject)(const KSCrashReportWriter *writer, const char *name);
    void (*endObject)(const KSCrashReportWriter *writer);
    void (*beginArray)(const KSCrashReportWriter *writer, const char *name);
    void (*endArray)(const KSCrashReportWriter *writer);

    // 内部状态
    void *context;
} KSCrashReportWriter;
```

**设计亮点**：

- 所有函数都是异步安全的
- 直接写入文件，不经过缓冲区（避免内存分配）
- 流式写入，边生成边写入磁盘

### 5.3 报告结构

#### 5.3.1 完整报告结构

```json
{
  "report": {
    "id": "UUID",
    "timestamp": 1234567890,
    "type": "crash",
    "version": "2.0"
  },
  "crash": {
    "error": {
      "type": "mach",
      "mach": {
        "exception": "EXC_BAD_ACCESS",
        "code": "KERN_INVALID_ADDRESS",
        "subcode": "0x0000000000000010"
      },
      "signal": {
        "signal": "SIGSEGV",
        "code": "SEGV_MAPERR",
        "name": "SIGSEGV"
      },
      "address": "0x0000000000000010",
      "reason": "Attempted to dereference null pointer."
    },
    "threads": [
      {
        "index": 0,
        "crashed": true,
        "current_thread": true,
        "backtrace": {
          "contents": [
            {
              "instruction_addr": "0x102a3c4f8",
              "object_addr": "0x102a00000",
              "object_name": "MyApp",
              "symbol_addr": "0x102a3c4e0",
              "symbol_name": "-[ViewController buttonTapped:]"
            }
          ]
        },
        "registers": {
          "basic": {
            "pc": "0x102a3c4f8",
            "sp": "0x16b2a3e40",
            "fp": "0x16b2a3e50",
            "lr": "0x102a3c500"
          }
        }
      }
    ],
    "diagnosis": "Attempted to access memory at 0x10"
  },
  "binary_images": [
    {
      "name": "/path/to/MyApp",
      "uuid": "A1B2C3D4-...",
      "cpu_type": 16777228,
      "cpu_subtype": 0,
      "image_addr": "0x102a00000",
      "image_size": 1048576
    }
  ],
  "system": {
    "system_name": "iOS",
    "system_version": "15.0",
    "machine": "iPhone14,2",
    "model": "iPhone 13 Pro",
    "memory": {
      "size": 6442450944,
      "free": 1073741824,
      "usable": 3221225472
    }
  },
  "process": {
    "name": "MyApp",
    "pid": 12345,
    "start_time": 1234567800
  },
  "user": {
    "custom_key": "custom_value"
  }
}
```

#### 5.3.2 核心部分源码分析

**写入错误信息**（`KSCrashReportC.c`）：

```c
void writeError(const KSCrashReportWriter *writer, const KSCrash_MonitorContext *context)
{
    writer->beginObject(writer, "error");
    {
        // 1. 写入异常类型
        const char *crashType = "unknown";
        if (strcmp(context->monitorId, "MachException") == 0) {
            crashType = "mach";
        } else if (strcmp(context->monitorId, "Signal") == 0) {
            crashType = "signal";
        } else if (strcmp(context->monitorId, "NSException") == 0) {
            crashType = "nsexception";
        }
        writer->addStringElement(writer, "type", crashType);

        // 2. 写入 Mach 异常信息（如果有）
        if (context->mach.type != 0) {
            writer->beginObject(writer, "mach");
            {
                writer->addStringElement(writer, "exception", ksmach_exceptionName(context->mach.type));
                writer->addStringElement(writer, "code", ksmach_kernelReturnCodeName(context->mach.code));
                writer->addIntegerElement(writer, "subcode", context->mach.subcode);
            }
            writer->endObject(writer);
        }

        // 3. 写入信号信息（如果有）
        if (context->signal.signum != 0) {
            writer->beginObject(writer, "signal");
            {
                writer->addIntegerElement(writer, "signal", context->signal.signum);
                writer->addStringElement(writer, "name", kssignal_signalName(context->signal.signum));
                writer->addStringElement(writer, "code", kssignal_signalCodeName(context->signal.signum,
                                                                                  context->signal.sigcode));
            }
            writer->endObject(writer);
        }

        // 4. 写入故障地址
        if (context->faultAddress != 0) {
            writer->addIntegerElement(writer, "address", context->faultAddress);
        }

        // 5. 写入崩溃原因
        if (context->crashReason != NULL) {
            writer->addStringElement(writer, "reason", context->crashReason);
        }
    }
    writer->endObject(writer);
}
```

**写入线程信息**：

```c
void writeThreads(const KSCrashReportWriter *writer, const KSCrash_MonitorContext *context)
{
    writer->beginArray(writer, "threads");
    {
        thread_act_array_t threads;
        mach_msg_type_number_t numThreads;
        task_threads(mach_task_self(), &threads, &numThreads);

        for (mach_msg_type_number_t i = 0; i < numThreads; i++) {
            thread_t thread = threads[i];

            writer->beginObject(writer, NULL);
            {
                // 1. 线程索引
                writer->addIntegerElement(writer, "index", i);

                // 2. 是否崩溃线程
                bool isCrashedThread = (thread == context->offendingMachineContext->thread);
                writer->addBooleanElement(writer, "crashed", isCrashedThread);

                // 3. 是否当前线程
                bool isCurrentThread = (thread == ksthread_self());
                writer->addBooleanElement(writer, "current_thread", isCurrentThread);

                // 4. 线程名称
                char threadName[64];
                if (ksthread_getThreadName(thread, threadName, sizeof(threadName))) {
                    writer->addStringElement(writer, "name", threadName);
                }

                // 5. 线程优先级
                writer->addIntegerElement(writer, "priority", ksthread_getThreadPriority(thread));

                // 6. 堆栈回溯
                if (isCrashedThread && context->stackCursor != NULL) {
                    // 使用保存的崩溃线程堆栈
                    writeBacktrace(writer, context->stackCursor);
                } else {
                    // 获取其他线程的堆栈
                    KSMachineContext threadContext;
                    if (ksmc_getContextForThread(thread, &threadContext, false)) {
                        KSStackCursor cursor;
                        kssc_initWithMachineContext(&cursor, KSSC_MAX_STACK_DEPTH, &threadContext);
                        writeBacktrace(writer, &cursor);
                    }
                }

                // 7. 寄存器（仅崩溃线程）
                if (isCrashedThread && context->registersAreValid) {
                    writeRegisters(writer, context->offendingMachineContext);
                }
            }
            writer->endObject(writer);
        }

        // 清理
        for (mach_msg_type_number_t i = 0; i < numThreads; i++) {
            mach_port_deallocate(mach_task_self(), threads[i]);
        }
        vm_deallocate(mach_task_self(), (vm_address_t)threads, numThreads * sizeof(thread_t));
    }
    writer->endArray(writer);
}
```

EXC_BREAKPOINT**写入堆栈回溯**：

```c
void writeBacktrace(const KSCrashReportWriter *writer, KSStackCursor *cursor)
{
    writer->beginObject(writer, "backtrace");
    {
        writer->beginArray(writer, "contents");
        {
            int frameIndex = 0;
            while (cursor->advanceCursor(cursor) && frameIndex < KSSC_MAX_STACK_DEPTH) {
                writer->beginObject(writer, NULL);
                {
                    // 1. 指令地址
                    writer->addIntegerElement(writer, "instruction_addr", cursor->address);

                    // 2. 符号化信息
                    if (cursor->symbolName != NULL) {
                        writer->addStringElement(writer, "symbol_name", cursor->symbolName);
                        writer->addIntegerElement(writer, "symbol_addr", cursor->symbolAddress);
                    }

                    // 3. 镜像信息
                    if (cursor->imageName != NULL) {
                        writer->addStringElement(writer, "object_name", cursor->imageName);
                        writer->addIntegerElement(writer, "object_addr", cursor->imageAddress);
                    }
                }
                writer->endObject(writer);

                frameIndex++;
            }
        }
        writer->endArray(writer);
    }
    writer->endObject(writer);
}
```

### 5.4 报告存储

**存储路径**（`KSCrash.m:73-87`）：

```objective-c
NSString *kscrash_getDefaultInstallPath(void)
{
    // 1. 获取 Caches 目录
    NSArray *directories = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                               NSUserDomainMask,
                                                               YES);
    NSString *cachePath = [directories objectAtIndex:0];

    // 2. 构造路径：Caches/KSCrash/{BundleName}
    NSString *bundleName = kscrash_getBundleName();
    NSString *pathEnd = [@"KSCrash" stringByAppendingPathComponent:bundleName];
    return [cachePath stringByAppendingPathComponent:pathEnd];
}
```

**完整路径示例**：

```
/var/mobile/Containers/Data/Application/{UUID}/Library/Caches/KSCrash/MyApp/
    ├── CrashReport-2024-01-01-120000.json
    ├── CrashReport-2024-01-02-143000.json
    └── state.json
```

**文件命名**：

```c
// 格式：CrashReport-{timestamp}-{eventID}.json
sprintf(filename, "CrashReport-%lld-%s.json", timestamp, eventID);
```

---

## 6. 配置与使用

### 6.1 基础配置

基于你的项目代码（`AppDelegate.swift:76-131`）：

```swift
func setupKSCrash() {
    // 1. 创建配置对象
    let config = KSCrashConfiguration()

    // 2. 配置监控器（选择要启用的监控器）
    config.monitors = [.all]  // 启用所有监控器
    // 或者选择性启用
    // config.monitors = [.machException, .signal, .nsException]

    // 3. 选择安装方式
    let console = CrashInstallationConsole.shared
    console.printAppleFormat = true  // 使用 Apple 格式输出

    // 4. 安装
    do {
        try console.install(with: config)
    } catch {
        mm_printLog("KSCrash 安装失败: \(error)")
    }

    // 5. 处理已有的崩溃报告
    console.sendAllReports { reports, error in
        if let error = error {
            mm_printLog("发送报告失败: \(error)")
        }

        reports?.forEach { report in
            if let dictReport = report as? CrashReportDictionary {
                // 处理字典格式报告
                let reportDict = dictReport.value
                self.processCrashReport(reportDict)
            } else if let strReport = report as? CrashReportString {
                // 处理字符串格式报告
                let reportString = strReport.value
                self.processCrashReportString(reportString)
            }
        }
    }
}
```

### 6.2 高级配置

#### 6.2.1 自定义用户信息

```swift
// 设置全局用户信息（会包含在所有崩溃报告中）
KSCrash.shared.userInfo = [
    "userId": "12345",
    "userName": "张三",
    "userLevel": 5,
    "appBuild": Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
]
```

#### 6.2.2 配置详细选项

```swift
let config = KSCrashConfiguration()

// 监控器配置
config.monitors = [.all]  // 所有监控器

// 内存内省（查找字符串、ObjC 对象等）
config.introspectionRules = KSCrashIntrospectionRules.all()

// 或者自定义规则
let rules = KSCrashIntrospectionRules()
rules.shouldIntrospectMemory = true
rules.minimumIntrospectionDistance = 128  // 最小检查距离
rules.maximumIntrospectionDistance = 4096 // 最大检查距离
config.introspectionRules = rules

// 不要内省的类（避免敏感信息泄露）
config.doNotIntrospectClasses = ["SecureToken", "Password"]

// 崩溃报告附加信息
config.addConsoleLogToReport = true  // 包含控制台日志
config.printPreviousLog = true       // 打印之前的日志

// 僵尸对象检测
config.enableZombie = true
config.zombieCacheSize = 16384  // 僵尸对象缓存大小（字节）

// 死锁检测
config.deadlockWatchdogInterval = 5.0  // 主线程无响应超时（秒）
```

#### 6.2.3 自定义报告字段

```swift
// 设置报告写入回调
config.onCrash = {
    // 注意：这里只能使用异步安全的函数！
    // 不能调用 malloc、Objective-C 方法等

    // 可以写入自定义字段
    // 需要使用 C API
}
```

### 6.3 安装方式对比

#### 6.3.1 Console 安装（控制台输出）

```swift
let console = CrashInstallationConsole.shared
console.printAppleFormat = true  // Apple 格式（类似 CrashReporter）
try console.install(with: config)
```

**优点**：

- 开发调试方便
- 直接在控制台查看

**缺点**：

- 生产环境不适用

#### 6.3.2 Email 安装（邮件发送）

```swift
let email = CrashInstallationEmail.shared
email.recipients = ["crash@example.com"]
email.subject = "[MyApp] 崩溃报告"
email.message = "应用发生崩溃，请查看附件"
email.filenameFmt = "crash-%d.txt"

email.addConditionalAlert(
    withTitle: "崩溃检测",
    message: "应用上次崩溃了，是否发送报告？",
    yesAnswer: "发送",
    noAnswer: "取消"
)

try email.install(with: config)
```

**优点**：

- 用户主动参与
- 可包含用户描述

**缺点**：

- 需要用户手动操作
- 收集率低

#### 6.3.3 Standard 安装（HTTP 上传）

```swift
let standard = CrashInstallationStandard.shared
standard.url = URL(string: "https://api.example.com/crash")!

standard.addConditionalAlert(
    withTitle: "崩溃检测",
    message: "应用上次崩溃了，是否上传报告帮助改进？",
    yesAnswer: "上传",
    noAnswer: "取消"
)

try standard.install(with: config)
```

**优点**：

- 适合生产环境
- 自动化收集

**配置服务器端点**：

```swift
// 自定义请求
standard.makeRequest = { report in
    var request = URLRequest(url: standard.url!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = report.data(using: .utf8)
    return request
}
```

### 6.4 手动上报异常

#### 6.4.1 上报 NSException

```swift
// 捕获并上报（不终止应用）
do {
    try riskyOperation()
} catch let error as NSError {
    let exception = NSException(
        name: NSExceptionName("CustomException"),
        reason: error.localizedDescription,
        userInfo: error.userInfo
    )
    KSCrash.shared.reportNSException(exception, logAllThreads: false)
}
```

#### 6.4.2 上报自定义异常

```swift
// 上报自定义异常（如 JavaScript 异常）
KSCrash.shared.reportUserException(
    "JavaScriptError",
    reason: "Uncaught TypeError: Cannot read property 'foo' of undefined",
    language: "javascript",
    lineOfCode: "var x = obj.foo;",
    stackTrace: [
        "at functionA (script.js:10:5)",
        "at functionB (script.js:20:10)"
    ],
    logAllThreads: false,
    terminateProgram: false  // 不终止应用
)
```

### 6.5 查询崩溃历史

```swift
// 检查上次是否崩溃
if KSCrash.shared.crashedLastLaunch {
    print("应用上次启动时崩溃了")

    // 获取统计信息
    let launches = KSCrash.shared.launchesSinceLastCrash
    let sessions = KSCrash.shared.sessionsSinceLastCrash
    let activeTime = KSCrash.shared.activeDurationSinceLastCrash

    print("距上次崩溃：\(launches) 次启动，\(sessions) 个会话，\(activeTime) 秒活跃时间")
}

// 获取系统信息
let systemInfo = KSCrash.shared.systemInfo
print("系统: \(systemInfo["systemName"] ?? "unknown") \(systemInfo["systemVersion"] ?? "unknown")")
print("设备: \(systemInfo["model"] ?? "unknown")")
```

---

## 7. 线程安全与异步安全

### 7.1 为什么需要异步安全？

**问题场景**：

```c
// 危险的崩溃处理代码
void unsafeCrashHandler(int signum) {
    NSLog(@"Crash detected!");  // ❌ 使用了 Objective-C

    NSString *log = [NSString stringWithFormat:@"Signal: %d", signum];  // ❌ 内存分配

    @synchronized(self) {  // ❌ 使用了锁
        [self saveLog:log];
    }
}
```

**为什么危险**：

1. **Objective-C 方法不是异步安全的**：可能调用 `objc_msgSend`，它内部使用了锁
2. **内存分配（malloc）不是异步安全的**：可能在等待全局堆锁
3. **使用锁不是异步安全的**：如果崩溃发生在持有锁的代码中，再次获取锁会死锁

**死锁示例**：

```
线程 A：
1. pthread_mutex_lock(&heapLock)    // 获取堆锁
2. [修改堆数据]
3. 💥 崩溃（如访问野指针）
4. 进入信号处理器
5. malloc(...)                      // 尝试分配内存
6. pthread_mutex_lock(&heapLock)    // ❌ 死锁！锁已被自己持有
```

### 7.2 异步安全函数

**POSIX 标准定义的异步安全函数**（部分）：

```c
// 允许的函数
_exit()         // 退出进程
open()          // 打开文件
write()         // 写入文件
close()         // 关闭文件
read()          // 读取文件
sigaction()     // 设置信号处理
mach_msg()      // Mach 消息
thread_suspend()// 挂起线程
vm_read()       // 读取内存

// 禁止的函数
malloc()        // ❌ 内存分配
free()          // ❌ 内存释放
printf()        // ❌ 格式化输出（内部用 malloc）
sprintf()       // ❌ 格式化字符串（某些实现用 malloc）
pthread_mutex_lock()  // ❌ 互斥锁（可能死锁）
objc_msgSend()  // ❌ Objective-C 消息发送
NSLog()         // ❌ 日志输出
```

### 7.3 KSCrash 的异步安全策略

#### 7.3.1 预分配内存

```c
// 全局预分配的缓冲区（在初始化时分配，崩溃时直接使用）
static char g_crashReportPath[PATH_MAX];
static char g_eventID[37];
static KSCrash_MonitorContext g_monitorContext;
static KSStackCursor g_stackCursor;

// 栈上分配（不涉及堆）
#define KSMC_NEW_CONTEXT(CONTEXT_NAME) \
    char CONTEXT_NAME##_storage[sizeof(KSMachineContext)]; \
    KSMachineContext *CONTEXT_NAME = (KSMachineContext *)CONTEXT_NAME##_storage
```

#### 7.3.2 安全的文件写入

```c
// KSCrash 的 JSON Writer 实现（简化版）
typedef struct {
    int fd;                 // 文件描述符
    char buffer[4096];      // 栈上缓冲区
    size_t bufferPos;
} JSONWriter;

void writer_write(JSONWriter *writer, const char *str)
{
    size_t len = strlen(str);
    size_t offset = 0;

    while (offset < len) {
        size_t remaining = 4096 - writer->bufferPos;
        size_t toWrite = (len - offset) < remaining ? (len - offset) : remaining;

        // 1. 拷贝到缓冲区（栈操作，安全）
        memcpy(writer->buffer + writer->bufferPos, str + offset, toWrite);
        writer->bufferPos += toWrite;
        offset += toWrite;

        // 2. 缓冲区满了，写入磁盘
        if (writer->bufferPos >= 4096) {
            write(writer->fd, writer->buffer, writer->bufferPos);  // 异步安全
            writer->bufferPos = 0;
        }
    }
}

void writer_addString(JSONWriter *writer, const char *key, const char *value)
{
    writer_write(writer, "\"");
    writer_write(writer, key);
    writer_write(writer, "\":\"");
    writer_write(writer, value);
    writer_write(writer, "\",");
}
```

**关键点**：

- 使用栈上缓冲区，不调用 `malloc`
- 使用 `write()` 系统调用直接写入，不使用 `fprintf` 等缓冲 IO
- `memcpy` 和 `strlen` 是异步安全的

#### 7.3.3 安全的字符串处理

```c
// KSCrash 的安全字符串工具（不使用 malloc）
int ksstring_safeStrcpy(char *dst, const char *src, int maxLength)
{
    int i;
    for (i = 0; i < maxLength - 1 && src[i] != '\0'; i++) {
        dst[i] = src[i];
    }
    dst[i] = '\0';
    return i;
}

int ksstring_safeStrcat(char *dst, const char *src, int maxLength)
{
    int dstLen = strlen(dst);
    return ksstring_safeStrcpy(dst + dstLen, src, maxLength - dstLen);
}

// 安全的整数转字符串（不使用 sprintf）
int ksstring_i64toa(int64_t value, char *buffer, int bufferLength)
{
    if (bufferLength < 2) return 0;

    bool isNegative = value < 0;
    if (isNegative) {
        value = -value;
        buffer[0] = '-';
        buffer++;
        bufferLength--;
    }

    // 从后往前填充
    int pos = 0;
    do {
        if (pos >= bufferLength - 1) break;
        buffer[pos++] = '0' + (value % 10);
        value /= 10;
    } while (value > 0);

    buffer[pos] = '\0';

    // 反转
    for (int i = 0; i < pos / 2; i++) {
        char tmp = buffer[i];
        buffer[i] = buffer[pos - 1 - i];
        buffer[pos - 1 - i] = tmp;
    }

    return pos;
}
```

#### 7.3.4 内存读取保护

```c
bool ksmem_isMemoryReadable(const void *memory, const size_t length)
{
    // 使用 vm_read_overwrite 测试内存是否可读（不会崩溃）
    vm_address_t address = (vm_address_t)memory;
    vm_size_t size = (vm_size_t)length;

    // 准备一个临时缓冲区
    uint8_t buffer[8];
    vm_size_t bufferSize = sizeof(buffer);

    // 尝试读取
    kern_return_t kr = vm_read_overwrite(mach_task_self(),
                                         address,
                                         size < bufferSize ? size : bufferSize,
                                         (vm_address_t)buffer,
                                         &bufferSize);

    return kr == KERN_SUCCESS;
}

// 在遍历堆栈时使用
bool advanceCursor_Safe(KSStackCursor *cursor)
{
    uintptr_t *framePtr = (uintptr_t *)cursor->fp;

    // 1. 先检查内存是否可读，避免崩溃
    if (!ksmem_isMemoryReadable(framePtr, sizeof(uintptr_t) * 2)) {
        return false;  // 内存不可读，停止回溯
    }

    // 2. 安全读取
    cursor->fp = framePtr[0];
    cursor->address = framePtr[1];

    return true;
}
```

### 7.4 监控器的异步安全级别

| 监控器           | 异步安全 | 原因                     |
| ------------- | ---- | ---------------------- |
| MachException | ✅ 是  | 完全使用 C API 和 Mach API  |
| Signal        | ✅ 是  | 仅使用异步安全函数              |
| NSException   | ❌ 否  | 使用 Objective-C API     |
| CPPException  | ❌ 否  | 使用 C++ 异常机制            |
| Deadlock      | ❌ 否  | 使用 dispatch 队列         |
| Zombie        | ❌ 否  | 使用 Objective-C runtime |

**kscm_notifyFatalExceptionCaptured 的作用**：

```c
bool kscm_notifyFatalExceptionCaptured(bool isAsyncSafeEnvironment)
{
    // 1. 标记进入异步安全模式
    g_requiresAsyncSafety = isAsyncSafeEnvironment;

    // 2. 通知所有监控器
    for (int i = 0; i < g_monitorsCount; i++) {
        KSCrashMonitorAPI *api = g_monitors[i];

        // 3. 如果要求异步安全，禁用非异步安全的监控器
        if (isAsyncSafeEnvironment) {
            if (!(api->monitorFlags() & KSCrashMonitorFlagAsyncSafe)) {
                api->setEnabled(false);
            }
        }
    }

    return true;
}
```

---

## 8. 最佳实践

### 8.1 初始化时机

**✅ 推荐**：

```swift
func application(_ application: UIApplication,
                 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // 1. 最早初始化 KSCrash（在其他 SDK 之前）
    setupKSCrash()

    // 2. 然后初始化其他 SDK
    setupOtherSDKs()

    return true
}
```

**原因**：

- 越早安装，越能捕获早期崩溃
- 避免其他 SDK 的崩溃处理器覆盖 KSCrash

### 8.2 生产环境配置

```swift
func setupKSCrash() {
    let config = KSCrashConfiguration()

    // 1. 启用必要的监控器
    #if DEBUG
    config.monitors = [.all]  // 开发环境全开
    #else
    config.monitors = [.machException, .signal, .nsException]  // 生产环境只开核心监控
    #endif

    // 2. 关闭僵尸对象检测（性能影响）
    #if DEBUG
    config.enableZombie = true
    #else
    config.enableZombie = false
    #endif

    // 3. 内存内省（谨慎使用，可能暴露敏感信息）
    #if DEBUG
    config.introspectionRules = KSCrashIntrospectionRules.all()
    #else
    let rules = KSCrashIntrospectionRules()
    rules.shouldIntrospectMemory = false  // 生产环境关闭
    config.introspectionRules = rules
    #endif

    // 4. 敏感类不内省
    config.doNotIntrospectClasses = [
        "SecureString",
        "PrivateKey",
        "AuthToken"
    ]

    // 5. 使用 Standard 安装
    let standard = CrashInstallationStandard.shared
    standard.url = URL(string: "https://api.example.com/crash")!

    // 6. 不显示弹窗（后台静默上传）
    #if !DEBUG
    // 生产环境不弹窗
    #else
    standard.addConditionalAlert(
        withTitle: "崩溃检测",
        message: "发现崩溃报告，是否上传？",
        yesAnswer: "上传",
        noAnswer: "取消"
    )
    #endif

    do {
        try standard.install(with: config)
    } catch {
        // 不要崩溃，静默失败
        print("KSCrash install failed: \(error)")
    }
}
```

### 8.3 报告上传策略

```swift
func uploadCrashReports() {
    let standard = CrashInstallationStandard.shared

    // 1. 仅在 WiFi 环境下上传
    guard isWiFiConnected() else {
        return
    }

    // 2. 限制频率（避免过度上传）
    let lastUploadTime = UserDefaults.standard.double(forKey: "lastCrashUploadTime")
    let now = Date().timeIntervalSince1970
    if now - lastUploadTime < 3600 {  // 1 小时内最多上传一次
        return
    }

    // 3. 上传
    standard.sendAllReports { reports, error in
        if error == nil {
            UserDefaults.standard.set(now, forKey: "lastCrashUploadTime")

            // 4. 删除已上传的报告（可选）
            standard.deleteAllReports()
        }
    }
}

private func isWiFiConnected() -> Bool {
    // 实现网络检测
    return true
}
```

### 8.4 调试技巧

#### 8.4.1 测试崩溃捕获

```swift
// 在你的测试界面添加崩溃按钮
func testCrashes() {
    // 1. 测试 NSException
    func testNSException() {
        NSException(name: NSExceptionName("TestException"),
                    reason: "This is a test",
                    userInfo: nil).raise()
    }

    // 2. 测试野指针（EXC_BAD_ACCESS）
    func testBadAccess() {
        let ptr = UnsafeMutablePointer<Int>(bitPattern: 0x1)
        ptr?.pointee = 42  // 💥
    }

    // 3. 测试除零（EXC_ARITHMETIC）
    func testDivideByZero() {
        let x = 1
        let y = 0
        let _ = x / y  // Swift 会检查，用 C 函数测试
    }

    // 4. 测试 abort
    func testAbort() {
        abort()
    }

    // 5. 测试栈溢出
    func testStackOverflow() {
        testStackOverflow()  // 无限递归
    }

    // 6. 测试数组越界
    func testArrayOutOfBounds() {
        let array = NSArray()
        let _ = array[100]  // 💥
    }
}
```

#### 8.4.2 查看崩溃报告

```swift
func printCrashReports() {
    guard let reportStore = KSCrash.shared.reportStore else {
        print("Report store not initialized")
        return
    }

    let reportIDs = reportStore.reportIDs()
    print("Found \(reportIDs?.count ?? 0) crash reports")

    reportIDs?.forEach { reportID in
        if let report = reportStore.report(for: reportID as! Int64) {
            print("=== Report \(reportID) ===")
            if let dict = report as? [String: Any] {
                printReport(dict)
            }
        }
    }
}

func printReport(_ report: [String: Any], indent: Int = 0) {
    let prefix = String(repeating: "  ", count: indent)
    for (key, value) in report {
        if let dict = value as? [String: Any] {
            print("\(prefix)\(key):")
            printReport(dict, indent: indent + 1)
        } else if let array = value as? [[String: Any]] {
            print("\(prefix)\(key): [")
            array.forEach { printReport($0, indent: indent + 1) }
            print("\(prefix)]")
        } else {
            print("\(prefix)\(key): \(value)")
        }
    }
}
```

### 8.5 隐私保护

#### 8.5.1 过滤敏感信息

```swift
// 自定义 Filter
class SensitiveDataFilter: NSObject, CrashReportFilter {
    func filterReports(_ reports: [Any], onCompletion: CrashReportFilterCompletion?) {
        let filtered = reports.compactMap { report -> [String: Any]? in
            guard var dict = report as? [String: Any] else {
                return nil
            }

            // 1. 移除用户敏感信息
            if var user = dict["user"] as? [String: Any] {
                user.removeValue(forKey: "password")
                user.removeValue(forKey: "token")
                dict["user"] = user
            }

            // 2. 脱敏用户 ID
            if let userId = dict["userId"] as? String {
                dict["userId"] = hashString(userId)
            }

            // 3. 移除环境变量（可能包含敏感配置）
            if var system = dict["system"] as? [String: Any] {
                system.removeValue(forKey: "environment")
                dict["system"] = system
            }

            return dict
        }

        onCompletion?(filtered, true, nil)
    }

    private func hashString(_ str: String) -> String {
        // 使用 SHA256 哈希
        return str.sha256()  // 需要实现
    }
}

// 使用
let installation = CrashInstallationStandard.shared
installation.addPreFilter(SensitiveDataFilter())
```

#### 8.5.2 符号化脱敏

生产环境的崩溃报告应该上传未符号化的版本，在服务器端符号化：

```swift
let config = KSCrashConfiguration()

// 关闭实时符号化
config.symbolicateOnTheFly = false

// 报告中只包含地址，不包含符号
```

**服务器端符号化流程**：

1. 客户端上传未符号化的崩溃报告
2. 服务器根据 `binary_images` 中的 UUID 查找对应的 dSYM
3. 使用 `atos` 或 `symbolicatecrash` 工具符号化
4. 存储符号化后的报告

### 8.6 性能优化

#### 8.6.1 减少监控器开销

```swift
let config = KSCrashConfiguration()

// 生产环境只开启必要的监控器
config.monitors = [.machException, .signal, .nsException]

// 关闭性能影响大的监控器
// - Zombie：每个对象释放时都会 hook
// - Deadlock：定时检查主线程
```

#### 8.6.2 控制堆栈深度

```swift
// 修改最大堆栈深度（默认 200）
// 在 C 代码中修改宏定义
#define KSSC_MAX_STACK_DEPTH 50  // 减少到 50 帧
```

#### 8.6.3 限制报告数量

```swift
func cleanupOldReports() {
    guard let reportStore = KSCrash.shared.reportStore else { return }

    let reportIDs = reportStore.reportIDs() as? [Int64] ?? []

    // 只保留最新的 10 个报告
    if reportIDs.count > 10 {
        let toDelete = reportIDs.dropLast(10)
        toDelete.forEach { reportStore.deleteReport(withID: $0) }
    }
}
```

---

## 总结

KSCrash 通过以下技术实现了完整、安全、详细的崩溃捕获：

1. **多层监控**：Mach 异常、Unix Signal、NSException 等多层拦截
2. **异步安全**：崩溃处理过程完全异步安全，避免二次崩溃
3. **完整上下文**：收集寄存器、堆栈、系统信息、应用状态等全方位信息
4. **流式写入**：边收集边写入磁盘，最大限度保证数据完整性
5. **灵活配置**：支持多种安装方式、自定义字段、过滤器链等

理解 KSCrash 的实现机制，不仅能帮助我们更好地使用它，也能让我们深入理解操作系统的异常处理机制、堆栈回溯原理等底层知识。

---

**参考资料**：

- [KSCrash GitHub](https://github.com/kstenerud/KSCrash)
- [Mach Exception Handlers](https://www.mikeash.com/pyblog/friday-qa-2013-01-11-mach-exception-handlers.html)
- [POSIX Signal](https://man7.org/linux/man-pages/man7/signal-safety.7.html)
- [iOS Crash Reporting](https://developer.apple.com/documentation/xcode/diagnosing-issues-using-crash-reports-and-device-logs)
