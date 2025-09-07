//
//  RecipeCategory.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

struct RecipeCategory: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
    
    // 预定义的分类
    static let defaultCategories = [
        RecipeCategory(name: "家常菜"),
        RecipeCategory(name: "凉菜"),
        RecipeCategory(name: "汤类"),
        RecipeCategory(name: "主食"),
        RecipeCategory(name: "小吃"),
        RecipeCategory(name: "甜点")
    ]
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: RecipeCategory, rhs: RecipeCategory) -> Bool {
        lhs.id == rhs.id
    }
}

