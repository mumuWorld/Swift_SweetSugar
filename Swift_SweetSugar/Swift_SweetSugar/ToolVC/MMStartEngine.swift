//
//  MMStartEngine.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2024/1/10.
//  Copyright © 2024 Mumu. All rights reserved.
//

import Foundation
import os.log

class MMStartEngine {
    func start() {

        let signpost = OSLog(subsystem: "com.example.MyApp", category: "Networking")

        let urlString = "https://example.com"
        let statusCode = 404

        os_log("Request to %@ failed with status code: %d", log: signpost, type: .error, urlString, statusCode)
        
        // 启动时间间隔的符号记录
        let beginSignpostID = OSSignpostID(log: signpost)

        os_signpost(.begin, log: signpost, name: "MyInterval", signpostID: beginSignpostID)

        // 执行一些需要测量的操作

        // 结束时间间隔的符号记录
        let endSignpostID = OSSignpostID(log: signpost)

        os_signpost(.end, log: signpost, name: "MyInterval", signpostID: endSignpostID)
        
        
//        let logger = os_log_create("com.bytedance.tiktok", "performance");
//        let signPostId = os_signpost_id_make_with_pointer(logger,sign);
//        //标记时间段开始
//        os_signpost_interval_begin(logger, signPostId, "Launch","%{public}s", "");
//        //标记结束
//        os_signpost_interval_end(logger, signPostId, "Launch");
    }
}
