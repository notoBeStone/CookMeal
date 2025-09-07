//
//  StorageManager.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation

@MainActor
class StorageManager: ObservableObject {
    static let shared = StorageManager()
    
    @Published private(set) var recipes: [Recipe] = []
    private let recipesFileName = "recipes.json"
    private let recipeDetailsDirectoryName = "RecipeDetails"
    
    private var recipesFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("Recipes").appendingPathComponent(recipesFileName)
    }
    
    private var recipeDetailsDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("Recipes").appendingPathComponent(recipeDetailsDirectoryName)
    }
    
    private init() {
        createDirectoriesIfNeeded()
        loadRecipes()
    }
    
    private func createDirectoriesIfNeeded() {
        let fileManager = FileManager.default
        let recipesDirectory = recipesFileURL.deletingLastPathComponent()
        let detailsDirectory = recipeDetailsDirectory
        let imagesDirectory = recipesDirectory.appendingPathComponent("Images")
        
        [recipesDirectory, detailsDirectory, imagesDirectory].forEach { directory in
            if !fileManager.fileExists(atPath: directory.path) {
                do {
                    try fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
                    debugPrint("Created directory at: \(directory.path)")
                } catch {
                    debugPrint("Error creating directory: \(error)")
                }
            }
        }
    }
    
    // MARK: - Recipe List Operations
    
    private func loadRecipes() {
        do {
            let data = try Data(contentsOf: recipesFileURL)
            recipes = try JSONDecoder().decode([Recipe].self, from: data)
            debugPrint("Loaded \(recipes.count) recipes")
        } catch {
            debugPrint("Error loading recipes: \(error)")
            recipes = []
        }
    }
    
    private func saveRecipes() {
        do {
            let data = try JSONEncoder().encode(recipes)
            try data.write(to: recipesFileURL)
            debugPrint("Saved \(recipes.count) recipes")
        } catch {
            debugPrint("Error saving recipes: \(error)")
        }
    }
    
    // MARK: - Recipe Detail Operations
    
    private func recipeDetailURL(for id: UUID) -> URL {
        recipeDetailsDirectory.appendingPathComponent("\(id.uuidString).json")
    }
    
    func loadRecipeDetail(for id: UUID) -> RecipeDetail? {
        do {
            let data = try Data(contentsOf: recipeDetailURL(for: id))
            return try JSONDecoder().decode(RecipeDetail.self, from: data)
        } catch {
            debugPrint("Error loading recipe detail: \(error)")
            return nil
        }
    }
    
    private func saveRecipeDetail(_ detail: RecipeDetail) {
        do {
            let data = try JSONEncoder().encode(detail)
            try data.write(to: recipeDetailURL(for: detail.id))
            debugPrint("Saved recipe detail for id: \(detail.id)")
        } catch {
            debugPrint("Error saving recipe detail: \(error)")
        }
    }
    
    // MARK: - Public Operations
    
    func addRecipe(_ recipe: Recipe, detail: RecipeDetail? = nil) {
        recipes.append(recipe)
        saveRecipes()
        
        if let detail = detail {
            saveRecipeDetail(detail)
        } else {
            // 如果没有提供详情，创建一个基于recipe的新详情
            saveRecipeDetail(RecipeDetail(from: recipe))
        }
    }
    
    func updateRecipe(_ recipe: Recipe, detail: RecipeDetail? = nil) {
        if let index = recipes.firstIndex(where: { $0.id == recipe.id }) {
            recipes[index] = recipe
            saveRecipes()
            
            // 如果提供了新的详情，就保存新的；否则保持原有的详情不变
            if let detail = detail {
                saveRecipeDetail(detail)
            } else if let existingDetail = loadRecipeDetail(for: recipe.id) {
                // 更新基本信息，保持其他信息不变
                var updatedDetail = existingDetail
                updatedDetail.name = recipe.name
                updatedDetail.ingredients = recipe.ingredients
                updatedDetail.category = recipe.category
                updatedDetail.updateDate = Date()
                saveRecipeDetail(updatedDetail)
            }
        }
    }
    
    func deleteRecipe(_ recipe: Recipe) {
        recipes.removeAll { $0.id == recipe.id }
        
        // 删除详情文件
        let detailURL = recipeDetailURL(for: recipe.id)
        try? FileManager.default.removeItem(at: detailURL)
        
        // 删除相关图片
        if let detail = loadRecipeDetail(for: recipe.id) {
            deleteImagesForRecipe(detail)
        }
        
        saveRecipes()
    }
    
    private func deleteImagesForRecipe(_ detail: RecipeDetail) {
        let fileManager = FileManager.default
        // 遍历所有步骤的图片
        for step in detail.steps {
            for path in step.imagePaths {
                do {
                    try fileManager.removeItem(atPath: path)
                    debugPrint("Deleted image at path: \(path)")
                } catch {
                    debugPrint("Error deleting image: \(error)")
                }
            }
        }
    }
}