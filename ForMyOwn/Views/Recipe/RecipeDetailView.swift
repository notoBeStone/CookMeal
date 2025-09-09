//
//  RecipeDetailView.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import SwiftUI

struct RecipeDetailView: View {
    let detail: RecipeDetail
    @State private var showingEditSheet = false
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageManager = StorageManager.shared
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 16) {
                    // 标题和描述
                    Text(detail.name)
                        .font(.title)
                        .bold()
                    
                    if !detail.description.isEmpty {
                        Text(detail.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // 分类标签
                    HStack {
                        Text(detail.category)
                            .font(.subheadline)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        
                        Spacer()
                        
                        Text("创建于 \(detail.createDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                    
                    // 食材列表
                    VStack(alignment: .leading, spacing: 12) {
                        Text("食材")
                            .font(.title2)
                            .bold()
                        
                        ForEach(detail.ingredients, id: \.self) { ingredient in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.blue)
                                Text(ingredient)
                            }
                        }
                    }
                    
                    Divider()
                    
                    // 调料列表
                    VStack(alignment: .leading, spacing: 12) {
                        Text("调料")
                            .font(.title2)
                            .bold()
                        
                        ForEach(detail.seasonings, id: \.self) { seasoning in
                            HStack {
                                Image(systemName: "circle.fill")
                                    .font(.system(size: 6))
                                    .foregroundColor(.orange)
                                Text(seasoning)
                            }
                        }
                    }
                    
                    if !detail.steps.isEmpty {
                        Divider()
                        
                        // 步骤列表
                        VStack(alignment: .leading, spacing: 16) {
                            Text("步骤")
                                .font(.title2)
                                .bold()
                            
                            ForEach(Array(detail.steps.enumerated()), id: \.offset) { index, step in
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack(alignment: .top) {
                                        Text("\(index + 1).")
                                            .font(.headline)
                                            .foregroundColor(.blue)
                                        Text(step.description)
                                    }
                                    
                                    // 如果步骤有图片，显示图片
                                    if !step.imagePaths.isEmpty {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 8) {
                                                ForEach(step.imagePaths, id: \.self) { path in
                                                    if let image = ImageManager.shared.loadImage(from: path) {
                                                        Image(uiImage: image)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 200, height: 150)
                                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { showingEditSheet = true }) {
                    Text("编辑")
                }
            }
        }
        .sheet(isPresented: $showingEditSheet) {
            RecipeEditView(detail: detail, isEditing: true)
        }
    }
}

#Preview {
    NavigationStack {
        RecipeDetailView(detail: RecipeDetail(
            name: "示例菜谱",
            description: "这是一个示例菜谱的描述",
            ingredients: ["食材1", "食材2"],
            seasonings: ["调料1", "调料2"],
            steps: [
                StepModel(description: "步骤1"),
                StepModel(description: "步骤2", imagePaths: [])
            ],
            category: "家常菜"
        ))
    }
}
