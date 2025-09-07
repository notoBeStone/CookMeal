//
//  RecipeDetail.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

struct RecipeDetail: Codable, Identifiable {
    let id: UUID              // 与Recipe的id对应
    var name: String          // 菜品名称
    var description: String   // 描述
    var coverImagePath: String?  // 可选的封面图路径
    var ingredients: [String] // 食材清单
    var seasonings: [String] // 调料清单
    var steps: [StepModel]   // 烹饪步骤
    var category: String     // 分类
    var notes: [CookingNote] // 烹饪笔记
    var createDate: Date     // 创建时间
    var updateDate: Date     // 更新时间
    
    init(from recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.description = ""
        self.coverImagePath = nil
        self.ingredients = recipe.ingredients
        self.seasonings = []
        self.steps = []
        self.category = recipe.category
        self.notes = []
        self.createDate = recipe.createDate
        self.updateDate = Date()
    }
    
    init(id: UUID = UUID(),
         name: String = "",
         description: String = "",
         coverImagePath: String? = nil,
         ingredients: [String] = [],
         seasonings: [String] = [],
         steps: [StepModel] = [],
         category: String = "默认分类",
         notes: [CookingNote] = [],
         createDate: Date = Date(),
         updateDate: Date = Date()) {
        self.id = id
        self.name = name
        self.description = description
        self.coverImagePath = coverImagePath
        self.ingredients = ingredients
        self.seasonings = seasonings
        self.steps = steps
        self.category = category
        self.notes = notes
        self.createDate = createDate
        self.updateDate = updateDate
    }
}