//
//  RecipeEditView.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import SwiftUI
import PhotosUI

// 步骤编辑状态
enum StepEditMode: Equatable {
    case none
    case adding
    case editing(Int)
}

struct RecipeEditView: View {
    // MARK: - Properties
    @Environment(\.dismiss) private var dismiss
    @StateObject private var storageManager = StorageManager.shared
    
    // 如果是编辑模式，使用传入的recipe初始化，否则创建新的recipe
    @State private var editingDetail: RecipeDetail
    let isEditing: Bool
    
    // 食材和调料的临时输入
    @State private var newIngredient: String = ""
    @State private var newSeasoning: String = ""
    
    
    @State private var stepEditMode: StepEditMode = .none
    @State private var newStep = StepModel()
    
    // 预定义的分类
    private let categories = RecipeCategory.defaultCategories.map { $0.name }
    
    // MARK: - Initialization
    init(detail: RecipeDetail = RecipeDetail(), isEditing: Bool = false) {
        _editingDetail = State(initialValue: detail)
        self.isEditing = isEditing
    }
    
    // MARK: - Private Methods
    private func addIngredient() {
        guard !newIngredient.isEmpty else { return }
        editingDetail.ingredients.append(newIngredient)
        newIngredient = ""
    }
    
    private func removeIngredient(_ ingredient: String) {
        editingDetail.ingredients.removeAll { $0 == ingredient }
    }
    
    private func addSeasoning() {
        guard !newSeasoning.isEmpty else { return }
        editingDetail.seasonings.append(newSeasoning)
        newSeasoning = ""
    }
    
    private func removeSeasoning(_ seasoning: String) {
        editingDetail.seasonings.removeAll { $0 == seasoning }
    }
    
    private func addStep() {
        guard !newStep.description.isEmpty else { return }
        editingDetail.steps.append(newStep)
        newStep = StepModel()
    }
    
    private func updateStep() {
        guard !newStep.description.isEmpty,
              case let .editing(index) = stepEditMode else { return }
        
        // 如果图片路径发生变化，删除旧图片
        let oldStep = editingDetail.steps[index]
        let removedPaths = Set(oldStep.imagePaths).subtracting(Set(newStep.imagePaths))
        for path in removedPaths {
            ImageManager.shared.deleteImage(at: path)
        }
        
        // 更新步骤
        editingDetail.steps[index] = newStep
        
        // 重置状态
        newStep = StepModel()
    }
    
    private func removeStep(at index: Int) {
        // 删除步骤相关的图片
        for path in editingDetail.steps[index].imagePaths {
            ImageManager.shared.deleteImage(at: path)
        }
        editingDetail.steps.remove(at: index)
    }
    
    private func saveRecipe() {
        // 如果有未添加的食材，添加到列表中
        if !newIngredient.isEmpty {
            editingDetail.ingredients.append(newIngredient)
        }
        
        // 如果有未添加的调料，添加到列表中
        if !newSeasoning.isEmpty {
            editingDetail.seasonings.append(newSeasoning)
        }
        
        // 更新时间
        editingDetail.updateDate = Date()
        
        // 创建基本信息
        let recipe = Recipe(
            id: editingDetail.id,
            name: editingDetail.name,
            ingredients: editingDetail.ingredients,
            category: editingDetail.category,
            createDate: editingDetail.createDate
        )
        
        if isEditing {
            storageManager.updateRecipe(recipe, detail: editingDetail)
        } else {
            storageManager.addRecipe(recipe, detail: editingDetail)
        }
        
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // 基本信息
                Section("基本信息") {
                    TextField("菜品名称", text: $editingDetail.name)
                    TextField("描述", text: $editingDetail.description, axis: .vertical)
                        .lineLimit(3...6)
                    Picker("分类", selection: $editingDetail.category) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                }
                
                // 食材列表
                Section(header: Text("食材")) {
                    ForEach(editingDetail.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeIngredient(ingredient)
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                    }
                    
                    HStack {
                        TextField("添加食材", text: $newIngredient)
                        Button(action: addIngredient) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newIngredient.isEmpty)
                    }
                }
                
                // 调料列表
                Section(header: Text("调料")) {
                    ForEach(editingDetail.seasonings, id: \.self) { seasoning in
                        Text(seasoning)
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeSeasoning(seasoning)
                                } label: {
                                    Label("删除", systemImage: "trash")
                                }
                            }
                    }
                    
                    HStack {
                        TextField("添加调料", text: $newSeasoning)
                        Button(action: addSeasoning) {
                            Image(systemName: "plus.circle.fill")
                        }
                        .disabled(newSeasoning.isEmpty)
                    }
                }
                
                // 步骤列表
                Section(header: Text("步骤")) {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(Array(editingDetail.steps.enumerated()), id: \.offset) { index, step in
                            StepItemView(
                                step: step,
                                index: index,
                                onEdit: {
                                    newStep = step
                                    stepEditMode = .editing(index)
                                },
                                onDelete: {
                                    removeStep(at: index)
                                }
                            )
                        }
                        
                        // 添加步骤按钮
                        Label("添加步骤", systemImage: "plus.circle.fill")
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .onTapGesture {
                                stepEditMode = .adding
                            }
                    }
                }
            }
            .navigationTitle(isEditing ? "编辑菜谱" : "新建菜谱")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("保存") {
                        saveRecipe()
                    }
                    .disabled(editingDetail.name.isEmpty)
                }
            }
            .sheet(isPresented: Binding(
                get: { stepEditMode != .none },
                set: { if !$0 { stepEditMode = .none } }
            )) {
                StepEditSheet(
                    stepEditMode: $stepEditMode,
                    newStep: $newStep,
                    recipeId: editingDetail.id,
                    onAdd: addStep,
                    onUpdate: updateStep
                )
            }
        }
    }
}


#Preview {
    RecipeEditView()
}
