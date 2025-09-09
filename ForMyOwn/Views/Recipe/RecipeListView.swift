//
//  RecipeListView.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var storageManager = StorageManager.shared
    @State private var showingAddRecipe = false
    @State private var searchText = ""
    
    private var filteredRecipes: [Recipe] {
        if searchText.isEmpty {
            return storageManager.recipes
        } else {
            return storageManager.recipes.filter { recipe in
                recipe.name.localizedCaseInsensitiveContains(searchText) ||
                recipe.ingredients.joined().localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredRecipes) { recipe in
                    NavigationLink(value: recipe) {
                        RecipeRowView(recipe: recipe)
                    }
                }
                .onDelete(perform: deleteRecipes)
            }
            .navigationTitle("我的菜谱")
            .navigationDestination(for: Recipe.self) { recipe in
                if let detail = storageManager.loadRecipeDetail(for: recipe.id) {
                    RecipeDetailView(detail: detail)
                }
            }
            .searchable(text: $searchText, prompt: "搜索菜谱")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { showingAddRecipe = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddRecipe) {
                RecipeEditView()
            }
        }
        
    }
    
    private func deleteRecipes(at offsets: IndexSet) {
        for index in offsets {
            let recipe = filteredRecipes[index]
            storageManager.deleteRecipe(recipe)
        }
    }
}

struct RecipeRowView: View {
    let recipe: Recipe
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 菜品名称和分类
            HStack {
                Text(recipe.name)
                    .font(.headline)
                Spacer()
                Text(recipe.category)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(4)
            }
            
            // 食材列表
            if !recipe.ingredients.isEmpty {
                Text(recipe.ingredients.joined(separator: "、"))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            // 创建时间
            Text(recipe.createDate, style: .date)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    RecipeListView()
}
