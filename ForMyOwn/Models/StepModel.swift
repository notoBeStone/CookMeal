//
//  StepModel.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

struct StepModel: Codable, Hashable {
    var description: String        // 步骤描述
    var imagePaths: [String]      // 图片路径数组，不再是可选的
    
    init(description: String = "", 
         imagePaths: [String] = []) {
        self.description = description
        self.imagePaths = imagePaths
    }
}