//
//  CookingNote.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

struct CookingNote: Codable, Identifiable, Hashable {
    let id: UUID
    var content: String       // 笔记内容
    var imagePaths: [String]? // 可选的图片路径数组
    var createDate: Date      // 创建时间
    
    init(id: UUID = UUID(),
         content: String,
         imagePaths: [String]? = nil,
         createDate: Date = Date()) {
        self.id = id
        self.content = content
        self.imagePaths = imagePaths
        self.createDate = createDate
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CookingNote, rhs: CookingNote) -> Bool {
        lhs.id == rhs.id
    }
}

