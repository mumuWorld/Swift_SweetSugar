//
//  MMLog.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2025/4/25.
//  Copyright © 2025 Mumu. All rights reserved.
//

import Foundation

struct SDKLaunchLog: Codable {
    let timestamp: Date      // 记录时间
    let info: String         // 说明信息，例如 “初始化成功”
}

class SDKLogManager {
    static let shared = SDKLogManager()
    
    /// 用于读写日志的串行队列
    private let queue = DispatchQueue(label: "com.yourcompany.SDKLogQueue", qos: .utility)
    
    private var logs: [SDKLaunchLog] = []
    private let logFileURL: URL
    
    private init() {
        // 构建日志文件路径（沙盒 Documents/SDKLogs.json）
        let documentDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        logFileURL = documentDir.appendingPathComponent("SDKLogs.txt")
        
//        loadLogsFromDisk()
        // 添加启动分割线
        addLog(info: "===== 🚀 SDK 启动 @ \(formattedDate(Date())) =====")
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: date)
    }
    
    func addLog(info: String) {
        queue.async {
            let log = SDKLaunchLog(timestamp: Date(), info: info)
            self.logs.append(log)
            self.saveLogsToDisk()
        }
    }
    
    func allLogs(completion: @escaping ([SDKLaunchLog]) -> Void) {
        queue.async {
            completion(self.logs)
        }
    }
    
    // MARK: - 私有方法
    
    private func loadLogsFromDisk() {
        queue.sync {
            guard FileManager.default.fileExists(atPath: logFileURL.path) else { return }
            do {
                let data = try Data(contentsOf: logFileURL)
                logs = try JSONDecoder().decode([SDKLaunchLog].self, from: data)
            } catch {
                print("❌ Failed to load logs: \(error)")
            }
        }
    }
    
    private func saveLogsToDisk() {
        do {
            let data = try JSONEncoder().encode(self.logs)
            try data.write(to: logFileURL)
        } catch {
            print("❌ Failed to save logs: \(error)")
        }
    }
}
