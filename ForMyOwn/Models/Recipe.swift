//
//  Recipe.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

struct Recipe: Codable, Identifiable, Hashable {
    let id: UUID
    var name: String           // 菜品名称
    var ingredients: [String]  // 食材清单
    var category: String      // 分类
    var createDate: Date      // 创建时间
    
    init(id: UUID = UUID(), 
         name: String = "", 
         ingredients: [String] = [], 
         category: String = "默认分类",
         createDate: Date = Date()) {
        self.id = id
        self.name = name
        self.ingredients = ingredients
        self.category = category
        self.createDate = createDate
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        lhs.id == rhs.id
    }
}