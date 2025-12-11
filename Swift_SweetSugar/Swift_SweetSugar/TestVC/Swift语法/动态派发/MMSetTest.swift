//
//  MMSetTest.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/12/10.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation

// MARK: - Swift 属性观察器（Property Observers）完整指南

/*
 ============================================
 📖 目录导航
 ============================================

 一、Struct vs Class 的属性观察器特性
    - 1.1 Struct 中的属性观察器
    - 1.2 Class 中的属性观察器

 二、计算属性 vs 存储属性的 Override
    - 2.1 父类属性定义
    - 2.2 子类 Override 存储属性
    - 2.3 多层继承链

 三、属性观察器的调用顺序
    - 3.1 三层继承调用顺序验证

 四、willSet/didSet 的所有使用场景
    - 4.1 基本存储属性
    - 4.2 延迟存储属性
    - 4.3 可选类型属性
    - 4.4 计算属性（不支持）
    - 4.5 didSet 中修改自身
    - 4.6 静态属性
    - 4.7 类属性

 五、特殊场景和注意事项
    - 5.1 初始化时不触发
    - 5.2 inout 参数修改
    - 5.3 结构体 mutating
    - 5.4 协议属性实现
    - 5.5 闭包捕获

 六、实际应用场景
    - 6.1 UI 自动更新
    - 6.2 数据验证
    - 6.3 状态同步
    - 6.4 观察者模式

 七、测试函数
    - 7.1 运行所有测试
    - 7.2-7.6 各种测试用例

 八、总结要点

 九、计算属性 get/set vs 存储属性 willSet/didSet 深度对比
    - 9.1 Struct 的计算属性 vs 存储属性
    - 9.2 Class 的计算属性 vs 存储属性
    - 9.3 详细对比：存储属性 vs 计算属性
    - 9.4 Struct 和 Class 在计算属性上的关键差异（mutating）
    - 9.5 性能和内存对比
    - 9.6 实际使用场景对比
    - 9.7 willSet/didSet 和 get/set 不能混用
    - 9.8 继承中的区别
    - 9.9 测试函数

 快速参考卡片

 十、值类型 vs 引用类型的内存模型深度解析
    - 10.1 值类型的复制行为
    - 10.2 引用类型的共享行为
    - 10.3 Copy-on-Write 机制
    - 10.4 mutating 关键字的本质
    - 10.5 内存和性能分析
 ============================================
 */

// MARK: - 一、Struct vs Class 的属性观察器特性

/*
 核心区别：
 1. struct（值类型）：修改属性会触发整个实例的 copy-on-write
 2. class（引用类型）：只修改属性本身，不影响引用
 3. 两者都支持 willSet/didSet，但行为略有不同

 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 为什么 Struct 修改属性会触发整个实例的复制？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. 值类型的本质：
    - Struct 是值类型，赋值时会复制整个值
    - 每个变量拥有自己独立的数据副本
    - 修改一个副本不会影响其他副本

 2. Copy-on-Write (COW) 优化：
    - Swift 标准库的集合类型（Array、Dictionary、Set）使用 COW
    - 只在真正需要修改时才复制，而不是每次赋值都复制
    - 多个变量可以共享同一份数据，直到其中一个需要修改

 3. 修改 Struct 属性的行为：
    - 从语义上讲，修改属性 = 创建一个新的实例
    - 需要 mutating 关键字标记会修改实例的方法
    - let 声明的 struct 实例，无法修改任何属性（整个实例不可变）

 4. 与 Class 的对比：
    - Class 是引用类型，变量存储的是引用（指针）
    - 修改 class 的属性，只是修改引用指向的内存中的值
    - 不需要 mutating 关键字
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 */

// MARK: 1.1 Struct 中的属性观察器

struct StructExample {
    // 存储属性可以添加 willSet/didSet
    var name: String = "默认名称" {
        willSet {
            print("Struct willSet: 即将从 '\(name)' 改为 '\(newValue)'")
        }
        didSet {
            print("Struct didSet: 已从 '\(oldValue)' 改为 '\(name)'")
        }
    }

    var age: Int = 0 {
        didSet {
            // 可以在 didSet 中修改其他属性
            if age < 0 {
                age = 0  // 这不会再次触发 didSet
            }
        }
    }

    // 注意：struct 的 let 常量属性不能有观察器
    // let id: String { willSet { } }  // 编译错误
}

// MARK: 1.2 Class 中的属性观察器

class ClassExample {
    var name: String = "默认名称" {
        willSet {
            print("Class willSet: 即将从 '\(name)' 改为 '\(newValue)'")
        }
        didSet {
            print("Class didSet: 已从 '\(oldValue)' 改为 '\(name)'")
        }
    }

    var age: Int = 0 {
        didSet {
            if age < 0 {
                age = 0
            }
        }
    }
}

// MARK: - 二、计算属性 vs 存储属性的 Override

/*
 核心规则：
 1. 存储属性不能被 override（子类不能重新声明同名存储属性）
 2. 存储属性可以在子类中添加属性观察器（通过 override 关键字）
 3. 计算属性可以被 override
 4. 可以将父类的存储属性 override 为计算属性（罕见）
 5. 不能将父类的计算属性 override 为存储属性
 */

// MARK: 2.1 父类属性定义

class Animal {
    // 存储属性
    var name: String = "动物" {
        willSet {
            print("Animal.name willSet: \(name) -> \(newValue)")
        }
        didSet {
            print("Animal.name didSet: \(oldValue) -> \(name)")
        }
    }

    // 存储属性（没有观察器）
    var age: Int = 0

    // 计算属性
    var description: String {
        get {
            print("Animal.description getter")
            return "这是一只\(name)，年龄\(age)"
        }
        set {
            print("Animal.description setter: \(newValue)")
            // 解析新值并设置 name 和 age
        }
    }

    // 只读计算属性
    var info: String {
        return "动物信息"
    }
}

// MARK: 2.2 子类 Override 存储属性

class Dog: Animal {
    // ✅ 可以为父类的存储属性添加观察器
    override var name: String {
        willSet {
            print("Dog.name willSet: \(name) -> \(newValue)")
        }
        didSet {
            print("Dog.name didSet: \(oldValue) -> \(name)")
        }
    }

    // ✅ 可以为父类没有观察器的存储属性添加观察器
    override var age: Int {
        didSet {
            print("Dog.age didSet: \(oldValue) -> \(age)")
        }
    }

    // ✅ 可以 override 计算属性
    override var description: String {
        get {
            print("Dog.description getter")
            return "这是一只狗狗，名字叫\(name)"
        }
        set {
            print("Dog.description setter: \(newValue)")
            name = newValue
        }
    }

    // ✅ 可以将只读计算属性 override 为读写计算属性
    override var info: String {
        get {
            return "狗狗信息"
        }
        set {
            print("Dog.info setter: \(newValue)")
        }
    }
}

// MARK: 2.3 多层继承链

class GoldenRetriever: Dog {
    // 可以继续在子类中添加观察器
    override var name: String {
        willSet {
            print("GoldenRetriever.name willSet: \(name) -> \(newValue)")
        }
        didSet {
            print("GoldenRetriever.name didSet: \(oldValue) -> \(name)")
        }
    }

    // 也可以 override 父类的计算属性: 会直接覆盖父类中的实现。
    override var description: String {
        get {
            print("GoldenRetriever.description getter")
            return "这是一只金毛，名字叫\(name)"
        }
        set {
            print("GoldenRetriever.setter: \(newValue)")
            name = newValue
        }
    }
}

// MARK: - 三、属性观察器的调用顺序和传递机制

/*
 重要规则：
 1. 当子类 override 属性并添加观察器时，父类的观察器仍会被调用
 2. 调用顺序：子类 willSet -> 父类 willSet -> 赋值 -> 父类 didSet -> 子类 didSet
 3. 不需要像 OC 中手动调用 super.setter
 4. Swift 会自动调用继承链上所有的属性观察器
 */

// MARK: 3.1 三层继承调用顺序验证

class BaseClass {
    var value: Int = 0 {
        willSet {
            print("1. BaseClass willSet: \(value) -> \(newValue)")
        }
        didSet {
            print("4. BaseClass didSet: \(oldValue) -> \(value)")
        }
    }
}

class MiddleClass: BaseClass {
    override var value: Int {
        willSet {
            print("2. MiddleClass willSet: \(value) -> \(newValue)")
        }
        didSet {
            print("5. MiddleClass didSet: \(oldValue) -> \(value)")
        }
    }
}

class FinalClass: MiddleClass {
    override var value: Int {
        willSet {
            print("3. FinalClass willSet: \(value) -> \(newValue)")
        }
        didSet {
            print("6. FinalClass didSet: \(oldValue) -> \(value)")
        }
    }
}

// MARK: - 四、willSet/didSet 的所有使用场景

class PropertyObserverDemo {

    // MARK: 4.1 基本存储属性

    var basicProperty: String = "初始值" {
        willSet(newVal) {  // 可以自定义参数名，默认是 newValue
            print("即将设置为: \(newVal)")
        }
        didSet(oldVal) {   // 可以自定义参数名，默认是 oldValue
            print("之前的值: \(oldVal)")
        }
    }

    // MARK: 4.2 延迟存储属性

    lazy var lazyProperty: String = "懒加载" {
        willSet {
            print("Lazy willSet: \(newValue)")
        }
        didSet {
            print("Lazy didSet: \(oldValue)")
        }
    }

    // MARK: 4.3 可选类型属性

    var optionalProperty: String? = nil {
        willSet {
            print("Optional willSet: \(String(describing: newValue))")
        }
        didSet {
            print("Optional didSet: \(String(describing: oldValue))")
        }
    }

    // MARK: 4.4 计算属性（不支持 willSet/didSet）

    var computedProperty: String {
        get {
            return "计算属性"
        }
        set {
            // 计算属性使用 get/set，不是 willSet/didSet
            print("计算属性的 setter: \(newValue)")
        }
    }

    // MARK: 4.5 didSet 中修改自身

    var validatedAge: Int = 0 {
        didSet {
            if validatedAge < 0 {
                validatedAge = 0  // 不会再次触发 didSet
                print("年龄已修正为 0")
            }
        }
    }

    // MARK: 4.6 静态属性

    static var staticProperty: String = "静态" {
        willSet {
            print("Static willSet: \(newValue)")
        }
        didSet {
            print("Static didSet: \(oldValue)")
        }
    }

    // MARK: 4.7 类属性

    class var classProperty: String {
        get {
            return "类属性"
        }
        set {
            print("类属性 setter: \(newValue)")
        }
    }
}

// MARK: - 五、特殊场景和注意事项

// MARK: 5.1 初始化时不触发观察器

class InitializationTest {
    var name: String = "默认" {  // 这里赋值不会触发观察器
        willSet {
            print("willSet: \(newValue)")
        }
        didSet {
            print("didSet: \(oldValue)")
        }
    }

    init(name: String) {
        self.name = name  // init 中的赋值也不会触发观察器
    }
}

// MARK: 5.2 inout 参数修改

class InoutTest {
    var count: Int = 0 {
        willSet {
            print("Count willSet: \(newValue)")
        }
        didSet {
            print("Count didSet: \(oldValue)")
        }
    }

    func incrementCount(_ value: inout Int) {
        value += 1  // 这会触发观察器
    }
}

// MARK: 5.3 结构体 mutating 方法

struct MutatingTest {
    var value: Int = 0 {
        didSet {
            print("Struct value changed: \(value)")
        }
    }

    mutating func updateValue(_ newValue: Int) {
        self.value = newValue  // 触发观察器
    }
}

// MARK: 5.4 协议属性实现

protocol PropertyProtocol {
    var observableProperty: String { get set }  // 协议只要求 get/set
}

class ProtocolImplementation: PropertyProtocol {
    // 实现协议时可以添加观察器
    var observableProperty: String = "" {
        willSet {
            print("Protocol property willSet: \(newValue)")
        }
        didSet {
            print("Protocol property didSet: \(oldValue)")
        }
    }
}

// MARK: 5.5 闭包捕获

class ClosureCaptureTest {
    var name: String = "测试" {
        didSet {
            print("Name changed to: \(name)")
        }
    }

    lazy var updateName: (String) -> Void = { [weak self] newName in
        self?.name = newName  // 会触发观察器
    }
}

// MARK: - 六、实际应用场景示例

// MARK: 6.1 UI 自动更新

class UserViewModel {
    var userName: String = "" {
        didSet {
            updateUI()
        }
    }

    var userAge: Int = 0 {
        didSet {
            updateUI()
        }
    }

    private func updateUI() {
        print("UI 已更新: \(userName), \(userAge)岁")
    }
}

// MARK: 6.2 数据验证

class User {
    var email: String = "" {
        didSet {
            if !email.contains("@") {
                print("⚠️ 邮箱格式无效")
                email = oldValue  // 恢复旧值
            }
        }
    }

    var password: String = "" {
        didSet {
            if password.count < 6 {
                print("⚠️ 密码长度不足")
                password = oldValue
            }
        }
    }
}

// MARK: 6.3 状态同步

class GameCharacter {
    var health: Int = 100 {
        didSet {
            if health <= 0 {
                health = 0
                onDeath()
            } else if health > maxHealth {
                health = maxHealth
            }
            updateHealthBar()
        }
    }

    let maxHealth: Int = 100

    private func onDeath() {
        print("角色死亡")
    }

    private func updateHealthBar() {
        print("血条更新: \(health)/\(maxHealth)")
    }
}

// MARK: 6.4 观察者模式（KVO 风格）

class Observable<T> {
    var value: T {
        didSet {
            observers.forEach { $0(value) }
        }
    }

    private var observers: [(T) -> Void] = []

    init(_ value: T) {
        self.value = value
    }

    func observe(_ observer: @escaping (T) -> Void) {
        observers.append(observer)
    }
}

// MARK: - 七、测试函数

class MMSetTest {

    // MARK: 7.1 运行所有测试

    static func runAllTests() {
        print("\n=== 测试 1: Struct vs Class ===")
        testStructVsClass()

        print("\n=== 测试 2: 属性 Override ===")
        testPropertyOverride()

        print("\n=== 测试 3: 调用顺序 ===")
        testCallOrder()

        print("\n=== 测试 4: 特殊场景 ===")
        testSpecialCases()

        print("\n=== 测试 5: 实际应用 ===")
        testPracticalUsage()
    }

    // MARK: 7.2 测试 Struct vs Class

    static func testStructVsClass() {
        print("--- Struct 测试 ---")
        var structObj = StructExample()
        structObj.name = "新名称"

        print("\n--- Class 测试 ---")
        let classObj = ClassExample()
        classObj.name = "新名称"
    }

    // MARK: 7.3 测试属性 Override

    static func testPropertyOverride() {
        print("--- Dog 继承 Animal ---")
        let dog = Dog()
        dog.name = "旺财"

        print("\n--- GoldenRetriever 三层继承 ---")
        let golden = GoldenRetriever()
        golden.name = "大黄"
        
        print("\n--- GoldenRetriever 继承计算属性 get ---")
        let desc = golden.description
        print("\n--- GoldenRetriever 继承计算属性 set ---")
        golden.description =  "test Desc"

    }

    // MARK: 7.4 测试调用顺序

    static func testCallOrder() {
        print("--- 三层继承的调用顺序 ---")
        let obj = FinalClass()
        print("开始赋值...")
        obj.value = 100
        print("赋值完成\n")
    }

    // MARK: 7.5 测试特殊场景

    static func testSpecialCases() {
        print("--- 初始化测试 ---")
        let initTest = InitializationTest(name: "测试")
        print("初始化完成，现在修改属性...")
        initTest.name = "新值"

        print("\n--- Inout 测试 ---")
        let inoutTest = InoutTest()
        inoutTest.incrementCount(&inoutTest.count)

        print("\n--- 结构体 Mutating 测试 ---")
        var mutatingTest = MutatingTest()
        mutatingTest.updateValue(42)
    }

    // MARK: 7.6 测试实际应用

    static func testPracticalUsage() {
        print("--- 用户验证测试 ---")
        let user = User()
        user.email = "invalid"
        user.email = "valid@example.com"

        print("\n--- 游戏角色测试 ---")
        let character = GameCharacter()
        character.health = 150  // 超过最大值
        character.health = -10  // 低于0

        print("\n--- Observable 模式测试 ---")
        let observable = Observable(0)
        observable.observe { value in
            print("观察者收到新值: \(value)")
        }
        observable.value = 10
        observable.value = 20
    }
}

// MARK: - 八、总结要点

/*
 ============================================
 📝 Swift 属性观察器核心知识总结
 ============================================

 1. Struct 和 Class 对存储属性使用 willSet/didSet：
    ✅ 两者都支持，语法完全相同
    ✅ Struct 是值类型，修改属性会触发整个实例的复制
    ✅ Class 是引用类型，只修改属性本身

 2. 计算属性和存储属性的 Override：
    ✅ 计算属性可以被 override
    ✅ 存储属性不能被重新声明，但可以添加观察器
    ✅ 子类添加观察器时，父类观察器自动调用，无需手动调用 super

 3. 调用顺序（多层继承）：
    子类 willSet -> 父类 willSet -> 祖先类 willSet
    -> 赋值
    -> 祖先类 didSet -> 父类 didSet -> 子类 didSet

 4. 不能使用 willSet/didSet 的场景：
    ❌ 计算属性（使用 get/set）
    ❌ let 常量属性
    ❌ 协议中的属性声明（但实现时可以添加）

 5. 不会触发观察器的场景：
    ❌ 属性初始化时
    ❌ 在 init 方法中赋值
    ✅ 但在 didSet 中修改自身不会再次触发

 6. 最佳实践：
    ✅ 用于 UI 更新
    ✅ 数据验证和边界检查
    ✅ 状态同步
    ✅ 实现简单的观察者模式
    ⚠️ 避免在观察器中执行耗时操作
    ⚠️ 注意在 didSet 中修改自身可能导致逻辑混乱

 7. 计算属性 vs 存储属性的核心区别：
    【存储属性 + willSet/didSet】
    ✅ 实际存储值，占用内存
    ✅ 适合监听数据变化、UI 同步、数据验证
    ✅ willSet 在赋值前，didSet 在赋值后
    ✅ 可以访问 oldValue 和 newValue
    ❌ 子类不能重新声明，只能添加观察器

    【计算属性 + get/set】
    ✅ 不存储值，每次访问都计算
    ✅ 适合数据转换、依赖计算、虚拟属性
    ✅ get 在读取时调用，set 在写入时调用
    ✅ 子类可以完全重写 get/set 实现
    ❌ 不能添加 willSet/didSet

 8. Struct 和 Class 在计算属性上的差异：
    ✅ Struct：计算属性的 set 隐式是 mutating 的
    ✅ Class：不需要 mutating 关键字
    ✅ 如果 get 中修改 struct 属性，需要显式标记 mutating get
    ✅ 两者在语法上基本相同，主要是值类型 vs 引用类型的差异

 9. 🔥 继承中父类方法是否会被调用（重要）：
    【存储属性 + willSet/didSet】
    ✅ 子类 override 添加观察器时，父类的观察器会自动调用
    ✅ 调用链：子类 willSet → 父类 willSet → 赋值 → 父类 didSet → 子类 didSet
    ✅ 完全不需要手动调用 super（Swift 自动处理）
    ✅ 多层继承时，所有层级的观察器都会被调用

    【计算属性 + get/set】
    ❌ 子类 override 时，父类的 get/set 完全不会被调用
    ❌ 子类的实现完全替换父类的实现
    ✅ 如果需要调用父类实现，必须手动使用 super.property
    ❌ 多层继承时，只有最底层子类的 get/set 会被调用

    ⚠️ 这是存储属性和计算属性的最大区别之一！
 */

// MARK: - 九、计算属性 get/set vs 存储属性 willSet/didSet 深度对比

/*
 核心区别：
 1. 计算属性（get/set）：不存储值，每次访问都重新计算
 2. 存储属性（willSet/didSet）：存储值，观察值的变化
 3. Struct 和 Class 在计算属性上的行为差异
 */

// MARK: 9.1 Struct 的计算属性 vs 存储属性

struct StructPropertyComparison {

    // 存储属性：直接存储值
    var storedValue: Int = 0 {
        willSet {
            print("📦 存储属性 willSet: \(storedValue) -> \(newValue)")
        }
        didSet {
            print("📦 存储属性 didSet: \(oldValue) -> \(storedValue)")
        }
    }

    // 私有存储，供计算属性使用
    private var _computedBackingValue: Int = 0

    // 计算属性：不存储值，通过 get/set 访问
    var computedValue: Int {
        get {
            print("🔢 计算属性 get: 返回 \(_computedBackingValue)")
            return _computedBackingValue
        }
        set {
            print("🔢 计算属性 set: 新值 \(newValue)")
            _computedBackingValue = newValue
        }
    }

    // 只读计算属性
    var readOnlyComputed: Int {
        print("📖 只读计算属性被访问")
        return storedValue * 2
    }

    // ⚠️ 注意：struct 修改属性需要 mutating
    mutating func modifyProperties() {
        storedValue = 10      // 触发 willSet/didSet
        computedValue = 20    // 调用 set
    }
}

// MARK: 9.2 Class 的计算属性 vs 存储属性

class ClassPropertyComparison {

    // 存储属性：直接存储值
    var storedValue: Int = 0 {
        willSet {
            print("📦 Class 存储属性 willSet: \(storedValue) -> \(newValue)")
        }
        didSet {
            print("📦 Class 存储属性 didSet: \(oldValue) -> \(storedValue)")
        }
    }

    // 私有存储，供计算属性使用
    private var _computedBackingValue: Int = 0

    // 计算属性：不存储值，通过 get/set 访问
    var computedValue: Int {
        get {
            print("🔢 Class 计算属性 get: 返回 \(_computedBackingValue)")
            return _computedBackingValue
        }
        set {
            print("🔢 Class 计算属性 set: 新值 \(newValue)")
            _computedBackingValue = newValue
        }
    }

    // 只读计算属性
    var readOnlyComputed: Int {
        print("📖 Class 只读计算属性被访问")
        return storedValue * 2
    }

    // Class 不需要 mutating 关键字
    func modifyProperties() {
        storedValue = 10      // 触发 willSet/didSet
        computedValue = 20    // 调用 set
    }
}

// MARK: 9.3 详细对比：存储属性 vs 计算属性

class PropertyTypeComparison {

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 1. 存储属性 + willSet/didSet
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var storedProperty: String = "初始值" {
        willSet {
            // willSet：在值被存储之前调用
            // 此时还可以访问旧值（通过属性名）
            // newValue 是即将被设置的新值
            print("willSet - 当前值: \(storedProperty), 新值: \(newValue)")
        }
        didSet {
            // didSet：在值被存储之后调用
            // oldValue 是之前的值
            // 此时属性已经是新值了
            print("didSet - 旧值: \(oldValue), 当前值: \(storedProperty)")

            // 可以在 didSet 中修改自身（不会再次触发）
            if storedProperty.isEmpty {
                storedProperty = oldValue
            }
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 2. 计算属性 + get/set
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    private var _backingValue: String = "初始值"

    var computedProperty: String {
        get {
            // get：每次访问属性时调用
            // 可以进行任何计算或转换
            print("get - 返回计算后的值")
            return _backingValue.uppercased()
        }
        set {
            // set：每次设置属性时调用
            // newValue 是传入的新值
            print("set - 接收到新值: \(newValue)")
            _backingValue = newValue.lowercased()
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 3. 只读计算属性（简化语法）
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var readOnlyProperty: String {
        // 只有 get，没有 set
        // 可以省略 get 关键字
        return "这是只读属性: \(storedProperty)"
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 4. 混合使用：存储属性被计算属性访问
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var firstName: String = "" {
        didSet {
            print("firstName 已改变")
            // 访问计算属性会触发它的 get
            print("fullName 现在是: \(fullName)")
        }
    }

    var lastName: String = "" {
        didSet {
            print("lastName 已改变")
        }
    }

    var fullName: String {
        get {
            return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        }
        set {
            let components = newValue.split(separator: " ")
            firstName = String(components.first ?? "")
            lastName = String(components.last ?? "")
        }
    }
}

// MARK: 9.4 Struct 和 Class 在计算属性上的关键差异

/*
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 核心差异：mutating 关键字
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 */

struct MutatingExample {
    private var _value: Int = 0

    var value: Int {
        get {
            return _value
        }
        // ⚠️ Struct 的计算属性 setter 隐式是 mutating 的
        set {
            _value = newValue
        }
    }

    // 但如果在 get 中修改属性，需要显式标记
    var doubleValue: Int {
        mutating get {
            _value += 1  // 修改了 struct 的属性
            return _value * 2
        }
    }
}

class NonMutatingExample {
    private var _value: Int = 0

    var value: Int {
        get {
            return _value
        }
        // ✅ Class 不需要 mutating 关键字
        set {
            _value = newValue
        }
    }

    var doubleValue: Int {
        get {
            _value += 1  // Class 可以直接修改
            return _value * 2
        }
    }
}

// MARK: 9.5 性能和内存对比

class PerformanceComparison {

    // 存储属性：占用内存空间
    var storedAge: Int = 0  // 占用 8 字节（64位系统）

    var storedName: String = ""  // 占用指针大小

    // 计算属性：不占用额外内存（除了可能的 backing storage）
    var ageDescription: String {
        // 每次访问都重新计算，不存储结果
        return "年龄是 \(storedAge) 岁"
    }

    private var _cachedValue: String?

    // 带缓存的计算属性
    var expensiveComputation: String {
        get {
            if let cached = _cachedValue {
                print("返回缓存值")
                return cached
            }
            print("执行昂贵的计算...")
            let result = "计算结果"
            _cachedValue = result
            return result
        }
    }

    func invalidateCache() {
        _cachedValue = nil
    }
}

// MARK: 9.6 实际使用场景对比

class PracticalUseCases {

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 场景 1: 数据验证 - 使用存储属性 + didSet
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var username: String = "" {
        didSet {
            // 验证用户名长度
            if username.count < 3 {
                print("⚠️ 用户名太短，恢复旧值")
                username = oldValue
            }
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 场景 2: 数据转换 - 使用计算属性
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var temperatureCelsius: Double = 0

    var temperatureFahrenheit: Double {
        get {
            return temperatureCelsius * 9 / 5 + 32
        }
        set {
            temperatureCelsius = (newValue - 32) * 5 / 9
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 场景 3: UI 同步 - 使用存储属性 + didSet
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var isLoading: Bool = false {
        didSet {
            if isLoading {
                print("🔄 显示加载指示器")
            } else {
                print("✅ 隐藏加载指示器")
            }
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 场景 4: 组合属性 - 使用计算属性
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    var width: CGFloat = 0
    var height: CGFloat = 0

    var area: CGFloat {
        return width * height
    }

    var aspectRatio: CGFloat {
        guard height != 0 else { return 0 }
        return width / height
    }
}

// MARK: 9.7 willSet/didSet 和 get/set 不能混用

class PropertyMixingExample {

    // ❌ 错误示例：不能在同一个属性上同时使用 willSet/didSet 和 get/set
    // var invalidProperty: String {
    //     willSet { }  // 编译错误！
    //     didSet { }   // 编译错误！
    //     get { return "value" }
    //     set { }
    // }

    // ✅ 正确方式 1：存储属性使用 willSet/didSet
    var storedWithObservers: String = "" {
        willSet {
            print("willSet: \(newValue)")
        }
        didSet {
            print("didSet: \(oldValue)")
        }
    }

    // ✅ 正确方式 2：计算属性使用 get/set
    private var _backing: String = ""
    var computedWithGetSet: String {
        get {
            print("get")
            return _backing
        }
        set {
            print("set: \(newValue)")
            _backing = newValue
        }
    }

    // ✅ 正确方式 3：如果需要在 get/set 中实现类似观察器的功能
    var simulatedObservers: String {
        get {
            return _backing
        }
        set {
            // 类似 willSet
            let oldValue = _backing
            print("即将改变: \(oldValue) -> \(newValue)")

            // 执行赋值
            _backing = newValue

            // 类似 didSet
            print("已经改变: \(oldValue) -> \(_backing)")
        }
    }
}

// MARK: 9.8 继承中的区别：父类方法是否会被调用

/*
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 核心区别：
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. 存储属性 + willSet/didSet：
    ✅ 子类 override 添加观察器时，父类的观察器会自动调用
    ✅ 不需要手动调用 super
    ✅ 调用链会自动传递

 2. 计算属性 + get/set：
    ❌ 子类 override 时，父类的 get/set 不会自动调用
    ❌ 完全替换父类的实现
    ✅ 如果需要，必须手动调用 super.property
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 */

class BasePropertyClass {
    // 存储属性：子类不能重新声明，但可以添加观察器
    var storedProperty: String = "Base" {
        didSet {
            print("✅ Base didSet 被调用")
        }
    }

    // 计算属性：子类可以完全重写
    private var _computedBacking: String = "Base Computed"
    var computedProperty: String {
        get {
            print("❌ Base get 被调用")  // 子类 override 后，这个不会被调用
            return _computedBacking
        }
        set {
            print("❌ Base set 被调用")  // 子类 override 后，这个不会被调用
            _computedBacking = newValue
        }
    }
}

class DerivedPropertyClass: BasePropertyClass {
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 1. Override 存储属性：父类的 didSet 会自动调用
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    override var storedProperty: String {
        didSet {
            print("✅ Derived didSet 被调用")
            // 不需要手动调用 super，父类的 didSet 会自动执行
        }
    }

    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    // 2. Override 计算属性：父类的 get/set 不会自动调用
    // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    private var _derivedBacking: String = "Derived Computed"

    override var computedProperty: String {
        get {
            print("✅ Derived get 被调用")
            // 父类的 get 不会被调用！
            // 如果需要调用父类的实现，必须手动调用 super
            return _derivedBacking
        }
        set {
            print("✅ Derived set 被调用")
            // 父类的 set 不会被调用！
            _derivedBacking = newValue
        }
    }

    // ✅ 可以将父类计算属性改为只读
    // override var computedProperty: String {
    //     return "Read Only"
    // }

    // ❌ 不能将父类存储属性改为计算属性
    // override var storedProperty: String {
    //     get { return "Can't do this" }
    //     set { }
    // }
}

// MARK: 9.8.1 如果需要调用父类的计算属性实现

class ManualSuperCallExample: BasePropertyClass {
    private var _extraInfo: String = ""

    override var computedProperty: String {
        get {
            print("子类 get：调用父类实现")
            // ✅ 手动调用父类的 get
            let baseValue = super.computedProperty
            return "\(baseValue) + \(_extraInfo)"
        }
        set {
            print("子类 set：调用父类实现")
            // ✅ 手动调用父类的 set
            super.computedProperty = newValue
            _extraInfo = "额外信息"
        }
    }
}

// MARK: 9.8.2 完整对比示例

class ComparisonBase {
    // 存储属性
    var stored: Int = 0 {
        willSet { print("1️⃣ Base willSet") }
        didSet { print("4️⃣ Base didSet") }
    }

    // 计算属性
    private var _computed: Int = 0
    var computed: Int {
        get {
            print("❌ Base computed get (不会被调用)")
            return _computed
        }
        set {
            print("❌ Base computed set (不会被调用)")
            _computed = newValue
        }
    }
}

class ComparisonDerived: ComparisonBase {
    // Override 存储属性：父类观察器会自动调用
    override var stored: Int {
        willSet { print("2️⃣ Derived willSet") }
        didSet { print("3️⃣ Derived didSet") }
    }

    // Override 计算属性：父类 get/set 不会自动调用
    private var _derivedComputed: Int = 0
    override var computed: Int {
        get {
            print("✅ Derived computed get (只有这个会被调用)")
            return _derivedComputed
        }
        set {
            print("✅ Derived computed set (只有这个会被调用)")
            _derivedComputed = newValue
        }
    }
}

// MARK: 9.8.3 多层继承对比

class GrandParent {
    var storedValue: Int = 0 {
        didSet { print("🔵 GrandParent didSet") }
    }

    private var _computedValue: Int = 0
    var computedValue: Int {
        get {
            print("❌ GrandParent get (不会被调用)")
            return _computedValue
        }
        set {
            print("❌ GrandParent set (不会被调用)")
            _computedValue = newValue
        }
    }
}

class Parent: GrandParent {
    override var storedValue: Int {
        didSet { print("🟢 Parent didSet") }
    }

    private var _parentComputedValue: Int = 0
    override var computedValue: Int {
        get {
            print("❌ Parent get (也不会被调用)")
            return _parentComputedValue
        }
        set {
            print("❌ Parent set (也不会被调用)")
            _parentComputedValue = newValue
        }
    }
}

class Child: Parent {
    override var storedValue: Int {
        didSet { print("🟡 Child didSet") }
    }

    private var _childComputedValue: Int = 0
    override var computedValue: Int {
        get {
            print("✅ Child get (只有这个被调用)")
            return _childComputedValue
        }
        set {
            print("✅ Child set (只有这个被调用)")
            _childComputedValue = newValue
        }
    }
}

// MARK: 9.9 测试函数

extension MMSetTest {

    // MARK: 9.9.1 测试 Struct 属性对比

    static func testStructPropertyComparison() {
        print("\n========================================")
        print("测试 Struct 属性对比")
        print("========================================\n")

        var structObj = StructPropertyComparison()

        print("--- 修改存储属性 ---")
        structObj.storedValue = 100

        print("\n--- 修改计算属性 ---")
        structObj.computedValue = 200

        print("\n--- 访问只读计算属性 ---")
        let _ = structObj.readOnlyComputed
    }

    // MARK: 9.9.2 测试 Class 属性对比

    static func testClassPropertyComparison() {
        print("\n========================================")
        print("测试 Class 属性对比")
        print("========================================\n")

        let classObj = ClassPropertyComparison()

        print("--- 修改存储属性 ---")
        classObj.storedValue = 100

        print("\n--- 修改计算属性 ---")
        classObj.computedValue = 200

        print("\n--- 访问只读计算属性 ---")
        let _ = classObj.readOnlyComputed
    }

    // MARK: 9.9.3 测试属性类型详细对比

    static func testPropertyTypeComparison() {
        print("\n========================================")
        print("测试存储属性 vs 计算属性")
        print("========================================\n")

        let obj = PropertyTypeComparison()

        print("--- 存储属性 ---")
        obj.storedProperty = "新值"

        print("\n--- 计算属性 ---")
        obj.computedProperty = "Computed"
        print("读取计算属性: \(obj.computedProperty)")

        print("\n--- 只读计算属性 ---")
        print(obj.readOnlyProperty)

        print("\n--- 混合使用 ---")
        obj.fullName = "张 三"
        print("firstName: \(obj.firstName), lastName: \(obj.lastName)")
    }

    // MARK: 9.9.4 测试继承中的属性

    static func testInheritedProperties() {
        print("\n========================================")
        print("测试继承中的属性 - 父类方法是否会被调用")
        print("========================================\n")

        let derived = DerivedPropertyClass()

        print("--- 1. 修改存储属性（父类 didSet 会自动调用）---")
        derived.storedProperty = "New Value"
        print("输出说明：父类的 didSet 会自动被调用\n")

        print("--- 2. 修改计算属性（父类 get/set 不会被调用）---")
        derived.computedProperty = "New Computed"
        print("读取: \(derived.computedProperty)")
        print("输出说明：父类的 get/set 完全不会被调用\n")

        print("--- 3. 手动调用父类计算属性 ---")
        let manual = ManualSuperCallExample()
        manual.computedProperty = "Test"
        print("读取: \(manual.computedProperty)")
        print("输出说明：通过 super.property 手动调用父类实现\n")

        print("--- 4. 完整对比 ---")
        let comparison = ComparisonDerived()
        print("设置存储属性:")
        comparison.stored = 100
        print("\n设置计算属性:")
        comparison.computed = 200
        print("\n读取计算属性:")
        let _ = comparison.computed

        print("\n--- 5. 多层继承对比 ---")
        let child = Child()
        print("设置存储属性（所有层级的 didSet 都会被调用）:")
        child.storedValue = 999
        print("\n设置计算属性（只有最底层的 get/set 会被调用）:")
        child.computedValue = 888
    }

    // MARK: 9.9.5 测试实际使用场景

    static func testPracticalCases() {
        print("\n========================================")
        print("测试实际使用场景")
        print("========================================\n")

        let practical = PracticalUseCases()

        print("--- 数据验证 ---")
        practical.username = "ab"  // 太短，会恢复
        practical.username = "alice"  // 有效

        print("\n--- 数据转换 ---")
        practical.temperatureCelsius = 0
        print("0°C = \(practical.temperatureFahrenheit)°F")
        practical.temperatureFahrenheit = 100
        print("100°F = \(practical.temperatureCelsius)°C")

        print("\n--- UI 同步 ---")
        practical.isLoading = true
        practical.isLoading = false

        print("\n--- 组合属性 ---")
        practical.width = 10
        practical.height = 5
        print("面积: \(practical.area)")
        print("宽高比: \(practical.aspectRatio)")
    }

    // MARK: 9.9.6 运行所有属性对比测试

    static func runAllPropertyComparisonTests() {
        testStructPropertyComparison()
        testClassPropertyComparison()
        testPropertyTypeComparison()
        testInheritedProperties()
        testPracticalCases()
    }
}

// MARK: - 快速参考卡片

/*
 ┌────────────────────────────────────────────────────────────────┐
 │                  Swift 属性观察器快速参考                        │
 └────────────────────────────────────────────────────────────────┘

 ▶ 问题 1: Struct 和 Class 对存储属性的 willSet/didSet 有什么不同？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 答：语法完全相同，都支持 willSet/didSet

 【Struct - 值类型】
 ✅ 修改属性 = 修改整个实例
 ✅ 赋值时会复制整个值（每个变量独立）
 ✅ 修改一个副本不影响其他副本
 ✅ 需要 mutating 关键字标记修改方法
 ✅ let 声明的实例完全不可变
 ⚡ 性能：栈分配，快速，但大对象复制开销高

 【Class - 引用类型】
 ✅ 修改属性只改变对象内容
 ✅ 赋值时只复制引用（指针），数据共享
 ✅ 修改会影响所有引用同一对象的变量
 ✅ 不需要 mutating 关键字
 ✅ let 只是引用不可变，对象本身可变
 ⚡ 性能：堆分配，有引用计数开销

 参考示例：
   - 语法对比：StructExample (1.1)、ClassExample (1.2)
   - 复制行为：ValueTypeDemo (10.1)
   - 共享行为：ReferenceTypeDemo (10.2)
   - COW 机制：CopyOnWriteDemo (10.3)

 ▶ 问题 2: 计算属性可以 override 吗？存储属性呢？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 答：✅ 计算属性可以被 override（可以改变 get/set 实现）
     ✅ 存储属性不能被重新声明，但可以添加属性观察器
     ❌ 不能将计算属性 override 为存储属性（反之可以，但少见）

 参考示例：Animal (2.1)、Dog (2.2)、GoldenRetriever (2.3)

 ▶ 问题 3: 父类如何收到 set 方法的调用？需要像 OC 那样调用 super 吗？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 答：🎯 分两种情况：

 【存储属性 + willSet/didSet】
 ✅ 不需要手动调用 super
 ✅ 父类观察器会自动被调用
 ✅ 调用顺序：子类 willSet → 父类 willSet → 赋值 → 父类 didSet → 子类 didSet

 【计算属性 + get/set】
 ❌ 父类的 get/set 不会自动调用
 ❌ 子类完全替换父类的实现
 ✅ 如果需要调用父类实现，必须手动使用 super.property

 参考示例：
   - 存储属性自动调用：BaseClass、MiddleClass、FinalClass (3.1)
   - 计算属性不自动调用：ComparisonBase、ComparisonDerived (9.8.2)
   - 手动调用父类：ManualSuperCallExample (9.8.1)

 ▶ 问题 4: willSet/didSet 的完整使用场景有哪些？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 ✅ 支持的场景：
     - 存储属性（普通、lazy、可选类型、静态属性）
     - 在 override 时为父类属性添加观察器
     - 在 didSet 中修改自身（不会再次触发）
     - 协议实现时添加观察器
     - struct 的 mutating 方法、inout 参数

 ❌ 不支持的场景：
     - 计算属性（应使用 get/set）
     - let 常量属性
     - 属性初始化时（不会触发）
     - init 方法中的赋值（不会触发）

 参考示例：PropertyObserverDemo (4.1-4.7)、特殊场景 (5.1-5.5)

 ▶ 实际应用场景：
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 📱 UI 自动更新        → UserViewModel (6.1)
 ✔️ 数据验证          → User (6.2)
 🎮 状态同步          → GameCharacter (6.3)
 👁️ 观察者模式        → Observable<T> (6.4)

 ▶ 问题 5: 计算属性 get/set 和存储属性 willSet/didSet 有什么区别？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 【存储属性 + willSet/didSet】
 ✅ 实际存储值，占用内存
 ✅ willSet 在赋值前调用，didSet 在赋值后调用
 ✅ 可以访问 oldValue 和 newValue
 ✅ 适合：数据验证、UI 同步、状态监听

 【计算属性 + get/set】
 ✅ 不存储值，每次访问都重新计算
 ✅ get 在读取时调用，set 在写入时调用
 ✅ 可以进行数据转换和组合
 ✅ 适合：数据转换、依赖计算、虚拟属性

 ┌──────────────────────────────────────────────────────────────────────┐
 │                        核心对比表格                                    │
 ├──────────────────┬──────────────────────┬──────────────────────────┤
 │  特性              │ 存储属性              │ 计算属性                  │
 ├──────────────────┼──────────────────────┼──────────────────────────┤
 │ 是否存储值        │ ✅ 是                 │ ❌ 否                     │
 │ 内存占用          │ ✅ 占用               │ ❌ 不占用                 │
 │ 访问方式          │ 直接读取              │ 通过 get 计算             │
 │ 修改方式          │ 直接赋值              │ 通过 set 转换             │
 │ 观察器            │ willSet/didSet       │ get/set                  │
 │ 初始化            │ ✅ 需要初始值         │ ❌ 不需要                 │
 │ Override          │ 只能添加观察器        │ 可以完全重写              │
 │ 父类方法调用      │ ✅ 自动调用（无需super）│ ❌ 不调用（需手动super）  │
 │ Struct mutating   │ 自动 mutating         │ set 自动 mutating         │
 │ 典型用途          │ 数据验证、UI同步      │ 数据转换、依赖计算        │
 └──────────────────┴──────────────────────┴──────────────────────────┘

 参考示例：
   - Struct 对比：StructPropertyComparison (9.1)
   - Class 对比：ClassPropertyComparison (9.2)
   - 详细对比：PropertyTypeComparison (9.3)
   - mutating 差异：MutatingExample (9.4)
   - 性能对比：PerformanceComparison (9.5)
   - 实际场景：PracticalUseCases (9.6)
   - 混用限制：PropertyMixingExample (9.7)
   - 继承差异：BasePropertyClass、DerivedPropertyClass (9.8)

 ▶ 运行测试：
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 MMSetTest.runAllTests()                    // 运行属性观察器测试
 MMSetTest.runAllPropertyComparisonTests()  // 运行属性对比测试
 MMSetTest.runAllValueVsReferenceTests()    // 运行值类型 vs 引用类型测试

 ┌────────────────────────────────────────────────────────────────┐
 │ 💡 关键要点：                                                    │
 │                                                                  │
 │ 1. 存储属性的观察器会自动向上传递，无需手动调用 super           │
 │ 2. 计算属性 override 时完全替换父类实现，不会自动调用父类       │
 │ 3. 在 didSet 中修改自身不会再次触发观察器（避免死循环）         │
 │ 4. 初始化时不会触发观察器（包括属性声明和 init 方法）           │
 │ 5. 存储属性不能被重新声明，但可以在子类中添加观察器             │
 │ 6. 计算属性不存储值，每次访问都重新计算                         │
 │ 7. Struct 的 set 隐式是 mutating 的，Class 不需要              │
 │ 8. 存储属性用于监听变化，计算属性用于转换和组合数据             │
 │ 9. willSet/didSet 和 get/set 不能在同一个属性上混用            │
 │ 10. 多层继承：存储属性所有层级都调用，计算属性只调用最底层      │
 └────────────────────────────────────────────────────────────────┘
 */

// MARK: - 十、值类型 vs 引用类型的内存模型深度解析

/*
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 核心问题：为什么说"Struct 是值类型，修改属性会触发整个实例的复制"？
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 这涉及到 Swift 类型系统的核心概念：值语义 vs 引用语义
 */

/*
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 可视化对比：Struct vs Class 的内存模型
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 【Struct - 值类型】

     var person1 = Person(name: "张三", age: 20)
     ┌─────────────────────┐
     │ person1 (栈上)       │
     │  ┌─────────────┐    │
     │  │ name: "张三" │    │  ← 直接存储数据
     │  │ age: 20     │    │
     │  └─────────────┘    │
     └─────────────────────┘

     var person2 = person1  // 复制整个数据
     ┌─────────────────────┐
     │ person1 (栈上)       │      ┌─────────────────────┐
     │  ┌─────────────┐    │      │ person2 (栈上)       │
     │  │ name: "张三" │    │      │  ┌─────────────┐    │
     │  │ age: 20     │    │      │  │ name: "张三" │    │
     │  └─────────────┘    │      │  │ age: 20     │    │
     └─────────────────────┘      │  └─────────────┘    │
                                   └─────────────────────┘
                                   ↑ 完全独立的副本

     person2.age = 25  // 只修改 person2
     ┌─────────────────────┐      ┌─────────────────────┐
     │ person1 (栈上)       │      │ person2 (栈上)       │
     │  ┌─────────────┐    │      │  ┌─────────────┐    │
     │  │ name: "张三" │    │      │  │ name: "张三" │    │
     │  │ age: 20     │←不变│      │  │ age: 25     │←改了│
     │  └─────────────┘    │      │  └─────────────┘    │
     └─────────────────────┘      └─────────────────────┘

 【Class - 引用类型】

     let person1 = Person(name: "张三", age: 20)
     ┌─────────────────────┐              ┌──────────────────┐
     │ person1 (栈上)       │              │  堆上的对象       │
     │  ┌──────────────┐   │   指向 ────→ │ ┌──────────────┐ │
     │  │ 引用(指针)    │───┼──────────→  │ │ name: "张三"  │ │
     │  └──────────────┘   │              │ │ age: 20      │ │
     └─────────────────────┘              │ └──────────────┘ │
                                           │ metadata + rc   │
                                           └──────────────────┘

     let person2 = person1  // 只复制引用（指针）
     ┌─────────────────────┐              ┌──────────────────┐
     │ person1 (栈上)       │              │  堆上的对象       │
     │  ┌──────────────┐   │   指向 ─┐    │ ┌──────────────┐ │
     │  │ 引用(指针)    │───┼─────────┼──→ │ │ name: "张三"  │ │
     │  └──────────────┘   │         │    │ │ age: 20      │ │
     └─────────────────────┘         │    │ └──────────────┘ │
     ┌─────────────────────┐         │    │ refcount: 2     │
     │ person2 (栈上)       │         │    └──────────────────┘
     │  ┌──────────────┐   │   指向 ─┘             ↑
     │  │ 引用(指针)    │───┼───────────────────────┘
     │  └──────────────┘   │       共享同一个对象
     └─────────────────────┘

     person2.age = 25  // 修改对象会影响所有引用
     ┌─────────────────────┐              ┌──────────────────┐
     │ person1 (栈上)       │              │  堆上的对象       │
     │  ┌──────────────┐   │   指向 ─┐    │ ┌──────────────┐ │
     │  │ 引用(指针)    │───┼─────────┼──→ │ │ name: "张三"  │ │
     │  └──────────────┘   │         │    │ │ age: 25  ←改了│ │
     └─────────────────────┘         │    │ └──────────────┘ │
     ┌─────────────────────┐         │    │ refcount: 2     │
     │ person2 (栈上)       │         │    └──────────────────┘
     │  ┌──────────────┐   │   指向 ─┘             ↑
     │  │ 引用(指针)    │───┼───────────────────────┘
     │  └──────────────┘   │       两个引用都看到了变化
     └─────────────────────┘

 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
 关键理解：
 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

 1. Struct 赋值 = 复制整个数据 → 两个独立的实例
 2. Class 赋值 = 复制引用 → 两个变量指向同一个对象
 3. 修改 Struct 属性 = 修改整个实例（语义上）
 4. 修改 Class 属性 = 修改对象内容（所有引用都能看到）
 5. let struct = 整个实例不可变
 6. let class = 引用不可变，但对象内容可变
 */

// MARK: 10.1 值类型的复制行为

class ValueTypeDemo {

    static func demonstrateStructCopying() {
        print("\n" + String(repeating: "=", count: 60))
        print("值类型（Struct）的复制行为")
        print(String(repeating: "=", count: 60) + "\n")

        // 创建一个 struct 实例
        struct Person {
            var name: String
            var age: Int

            mutating func haveBirthday() {
                age += 1
                print("生日快乐！现在 \(age) 岁了")
            }
        }

        // 场景 1: 赋值时复制
        print("--- 场景 1: 赋值时复制 ---")
        var person1 = Person(name: "张三", age: 20)
        var person2 = person1  // 复制整个实例！

        print("修改前:")
        print("person1: \(person1.name), \(person1.age)")
        print("person2: \(person2.name), \(person2.age)")

        // 修改 person2 不会影响 person1
        person2.name = "李四"
        person2.age = 25

        print("\n修改 person2 后:")
        print("person1: \(person1.name), \(person1.age) <- 没有变化")
        print("person2: \(person2.name), \(person2.age) <- 已修改")

        // 场景 2: let vs var 的区别
        print("\n--- 场景 2: let 声明的 struct 完全不可变 ---")
        let person3 = Person(name: "王五", age: 30)
        // person3.age = 31  // ❌ 编译错误：let 声明的 struct 无法修改任何属性
        // person3.haveBirthday()  // ❌ 编译错误：无法调用 mutating 方法

        var person4 = Person(name: "赵六", age: 30)
        person4.age = 31  // ✅ var 声明的可以修改
        person4.haveBirthday()  // ✅ 可以调用 mutating 方法

        // 场景 3: 内存地址对比（使用指针查看）
        print("\n--- 场景 3: 内存地址对比 ---")
        var p1 = Person(name: "A", age: 1)
        var p2 = p1

        withUnsafePointer(to: &p1) { ptr1 in
            withUnsafePointer(to: &p2) { ptr2 in
                print("p1 的内存地址: \(ptr1)")
                print("p2 的内存地址: \(ptr2)")
                print("是否是同一块内存: \(ptr1 == ptr2)")  // false，不同的内存
            }
        }
    }
}

// MARK: 10.2 引用类型的共享行为

class ReferenceTypeDemo {

    static func demonstrateClassSharing() {
        print("\n" + String(repeating: "=", count: 60))
        print("引用类型（Class）的共享行为")
        print(String(repeating: "=", count: 60) + "\n")

        class Person {
            var name: String
            var age: Int

            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }

            func haveBirthday() {
                age += 1
                print("生日快乐！现在 \(age) 岁了")
            }
        }

        // 场景 1: 赋值时共享引用
        print("--- 场景 1: 赋值时共享引用 ---")
        let person1 = Person(name: "张三", age: 20)
        let person2 = person1  // 只复制引用（指针），不复制数据！

        print("修改前:")
        print("person1: \(person1.name), \(person1.age)")
        print("person2: \(person2.name), \(person2.age)")

        // 修改 person2 会影响 person1（因为它们指向同一个对象）
        person2.name = "李四"
        person2.age = 25

        print("\n修改 person2 后:")
        print("person1: \(person1.name), \(person1.age) <- 也变了！")
        print("person2: \(person2.name), \(person2.age)")

        // 场景 2: let vs var 的区别
        print("\n--- 场景 2: let 只是引用不可变，对象本身可变 ---")
        let person3 = Person(name: "王五", age: 30)
        person3.age = 31  // ✅ 可以修改属性（对象是可变的）
        person3.haveBirthday()  // ✅ 可以调用方法
        // person3 = Person(name: "Other", age: 20)  // ❌ 不能改变引用

        // 场景 3: 内存地址对比
        print("\n--- 场景 3: 内存地址对比 ---")
        let p1 = Person(name: "A", age: 1)
        let p2 = p1

        print("p1 的对象地址: \(Unmanaged.passUnretained(p1).toOpaque())")
        print("p2 的对象地址: \(Unmanaged.passUnretained(p2).toOpaque())")
        print("是否是同一个对象: \(p1 === p2)")  // true，同一个对象
    }
}

// MARK: 10.3 Copy-on-Write (COW) 机制详解

class CopyOnWriteDemo {

    static func demonstrateCOW() {
        print("\n" + String(repeating: "=", count: 60))
        print("Copy-on-Write (COW) 优化机制")
        print(String(repeating: "=", count: 60) + "\n")

        // Swift 的 Array 使用 COW 优化
        print("--- Array 的 COW 行为 ---")
        var array1 = [1, 2, 3, 4, 5]
        var array2 = array1  // 此时不会立即复制数据

        print("赋值后（还没修改）:")
        print("array1: \(array1)")
        print("array2: \(array2)")

        // 查看底层存储地址（通过 withUnsafeBufferPointer）
        array1.withUnsafeBufferPointer { ptr1 in
            array2.withUnsafeBufferPointer { ptr2 in
                print("array1 的缓冲区地址: \(ptr1.baseAddress!)")
                print("array2 的缓冲区地址: \(ptr2.baseAddress!)")
                print("共享同一块内存: \(ptr1.baseAddress == ptr2.baseAddress)")
            }
        }

        print("\n修改 array2[0]...")
        array2[0] = 999  // 此时才真正复制数据（Copy-on-Write）

        print("\n修改后:")
        print("array1: \(array1) <- 没变")
        print("array2: \(array2) <- 已修改")

        array1.withUnsafeBufferPointer { ptr1 in
            array2.withUnsafeBufferPointer { ptr2 in
                print("array1 的缓冲区地址: \(ptr1.baseAddress!)")
                print("array2 的缓冲区地址: \(ptr2.baseAddress!)")
                print("还共享内存吗: \(ptr1.baseAddress == ptr2.baseAddress)")  // false
            }
        }
    }

    // 自定义实现 COW 的 struct
    static func customCOWImplementation() {
        print("\n--- 自定义 COW 实现 ---")

        // 使用 class 作为存储，struct 提供值语义
        final class Storage {
            var value: Int
            init(_ value: Int) {
                self.value = value
            }
        }

        struct COWValue {
            private var storage: Storage

            init(_ value: Int) {
                storage = Storage(value)
            }

            var value: Int {
                get {
                    return storage.value
                }
                set {
                    // 只有当 storage 被多个实例共享时才复制
                    if !isKnownUniquelyReferenced(&storage) {
                        print("检测到共享引用，执行复制...")
                        storage = Storage(newValue)
                    } else {
                        print("唯一引用，直接修改...")
                        storage.value = newValue
                    }
                }
            }
        }

        var val1 = COWValue(10)
        print("val1.value = \(val1.value)")

        var val2 = val1
        print("创建 val2 = val1（共享存储）")

        print("\n修改 val2.value = 20")
        val2.value = 20

        print("val1.value = \(val1.value)")
        print("val2.value = \(val2.value)")

        print("\n再次修改 val2.value = 30（已经独立，无需复制）")
        val2.value = 30
    }
}

// MARK: 10.4 mutating 关键字的本质

class MutatingKeywordDemo {

    static func demonstrateMutating() {
        print("\n" + String(repeating: "=", count: 60))
        print("mutating 关键字的本质")
        print(String(repeating: "=", count: 60) + "\n")

        struct Counter {
            var count: Int = 0

            // mutating 方法：会修改 self
            mutating func increment() {
                count += 1
                // 等价于：self = Counter(count: self.count + 1)
            }

            // 非 mutating 方法：不修改 self
            func currentValue() -> Int {
                return count
            }

            // mutating 方法可以完全替换 self
            mutating func reset() {
                self = Counter(count: 0)  // 完全替换整个实例
            }
        }

        print("--- mutating 的本质 ---")
        var counter = Counter()
        print("初始值: \(counter.count)")

        counter.increment()
        print("调用 increment() 后: \(counter.count)")

        counter.reset()
        print("调用 reset() 后: \(counter.count)")

        // let 声明的实例无法调用 mutating 方法
        let immutableCounter = Counter()
        // immutableCounter.increment()  // ❌ 编译错误
        print("\nlet 声明的实例无法调用 mutating 方法")

        // 对比：Class 不需要 mutating
        class ClassCounter {
            var count: Int = 0

            func increment() {  // 不需要 mutating
                count += 1
            }
        }

        let classCounter = ClassCounter()
        classCounter.increment()  // ✅ let 声明的 class 可以修改属性
        print("let 声明的 class 可以修改属性: \(classCounter.count)")
    }

    static func demonstrateMutatingInProtocol() {
        print("\n--- 协议中的 mutating ---")

        protocol Incrementable {
            mutating func increment()
        }

        struct StructImpl: Incrementable {
            var value: Int = 0
            mutating func increment() {  // Struct 需要 mutating
                value += 1
            }
        }

        class ClassImpl: Incrementable {
            var value: Int = 0
            func increment() {  // Class 不需要 mutating
                value += 1
            }
        }

        var s = StructImpl()
        s.increment()
        print("Struct 实现: \(s.value)")

        let c = ClassImpl()
        c.increment()
        print("Class 实现: \(c.value)")
    }
}

// MARK: 10.5 内存和性能分析

class MemoryPerformanceDemo {

    static func analyzeMemoryBehavior() {
        print("\n" + String(repeating: "=", count: 60))
        print("内存和性能分析")
        print(String(repeating: "=", count: 60) + "\n")

        // 场景 1: Struct 的内存占用
        print("--- Struct 的内存占用 ---")
        struct Point {
            var x: Double  // 8 bytes
            var y: Double  // 8 bytes
            // 总共 16 bytes，直接存储在栈上
        }

        let point = Point(x: 10, y: 20)
        print("Point 结构体大小: \(MemoryLayout<Point>.size) bytes")
        print("Point 对齐后大小: \(MemoryLayout<Point>.stride) bytes")
        print("Point 对齐要求: \(MemoryLayout<Point>.alignment) bytes")

        // 场景 2: Class 的内存占用
        print("\n--- Class 的内存占用 ---")
        class PointClass {
            var x: Double = 0  // 8 bytes
            var y: Double = 0  // 8 bytes
            // 额外开销：type metadata (8 bytes) + refcount (8 bytes)
        }

        let pointClass = PointClass()
        print("PointClass 引用大小: \(MemoryLayout<PointClass>.size) bytes (指针)")
        print("实际对象大小: 约 32 bytes（8+8+16 元数据）")

        // 场景 3: 性能对比
        print("\n--- 性能对比 ---")
        print("✅ Struct 优势：")
        print("   - 栈分配，速度快")
        print("   - 无引用计数开销")
        print("   - 无堆内存分配")
        print("   - 线程安全（值拷贝）")

        print("\n❌ Struct 劣势：")
        print("   - 大对象复制开销高")
        print("   - 无法共享可变状态")

        print("\n✅ Class 优势：")
        print("   - 引用传递，无复制开销")
        print("   - 可以共享可变状态")
        print("   - 支持继承和多态")

        print("\n❌ Class 劣势：")
        print("   - 堆分配，速度较慢")
        print("   - 引用计数开销")
        print("   - 需要 ARC 管理内存")
        print("   - 需要考虑线程安全")
    }

    static func demonstrateWhenToUsEach() {
        print("\n--- 何时使用 Struct vs Class ---")
        print("\n推荐使用 Struct 的场景：")
        print("✅ 简单的数据类型（Point, Size, Rect）")
        print("✅ 值语义更合适（修改副本不影响原对象）")
        print("✅ 线程安全很重要")
        print("✅ 不需要继承")
        print("✅ 需要 Equatable/Hashable（Struct 自动合成）")

        print("\n推荐使用 Class 的场景：")
        print("✅ 需要继承和多态")
        print("✅ 需要共享可变状态")
        print("✅ 引用语义更合适（修改会影响所有引用）")
        print("✅ 需要精确控制生命周期（deinit）")
        print("✅ 与 Objective-C 互操作")
    }
}

// MARK: 10.6 测试函数

extension MMSetTest {

    // MARK: 10.6.1 运行所有值类型 vs 引用类型的测试

    static func runAllValueVsReferenceTests() {
        ValueTypeDemo.demonstrateStructCopying()
        ReferenceTypeDemo.demonstrateClassSharing()
        CopyOnWriteDemo.demonstrateCOW()
        CopyOnWriteDemo.customCOWImplementation()
        MutatingKeywordDemo.demonstrateMutating()
        MutatingKeywordDemo.demonstrateMutatingInProtocol()
        MemoryPerformanceDemo.analyzeMemoryBehavior()
        MemoryPerformanceDemo.demonstrateWhenToUsEach()
    }
}
