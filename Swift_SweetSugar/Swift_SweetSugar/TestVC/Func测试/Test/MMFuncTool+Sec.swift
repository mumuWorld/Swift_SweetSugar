//
//  MMFuncTool+Sec.swift
//  Swift_SweetSugar
//
//  Created by 杨杰 on 2023/10/10.
//  Copyright © 2023 Mumu. All rights reserved.
//

import Foundation

//MARK: - Some Any

extension MMFuncTool {
    class MusicPlayer {
        var playlist: any Collection<String> = []

        func play(_ playlist: some Collection<String>) {
            self.playlist = playlist
        }
    }

}
