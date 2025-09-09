//
//  StepEditView.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import SwiftUI
import PhotosUI

struct StepEditView: View {
    @Binding var step: StepModel
    @State private var selectedItems: [PhotosPickerItem] = []
    let recipeId: UUID
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 步骤描述输入
            TextField("添加步骤描述", text: $step.description, axis: .vertical)
                .lineLimit(3...6)
                .textFieldStyle(.roundedBorder)
            
            // 已选择的图片预览
            if !step.imagePaths.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(step.imagePaths.indices, id: \.self) { index in
                            if let image = ImageManager.shared.loadImage(from: step.imagePaths[index]) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .overlay(
                                        Button(action: { removeImage(at: index) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Color.black.opacity(0.5))
                                                .clipShape(Circle())
                                        }
                                        .padding(4),
                                        alignment: .topTrailing
                                    )
                            }
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            
            // 图片选择按钮
            PhotosPicker(selection: $selectedItems,
                        maxSelectionCount: 5,
                        matching: .images) {
                Label("添加图片", systemImage: "photo")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .onChange(of: selectedItems) { _, _ in
            Task {
                var newImagePaths: [String] = []
                for item in selectedItems {
                    if let data = try? await item.loadTransferable(type: Data.self),
                       let image = UIImage(data: data),
                       let path = ImageManager.shared.saveImage(image, forRecipe: recipeId) {
                        newImagePaths.append(path)
                    }
                }
                // 添加新的图片路径
                step.imagePaths.append(contentsOf: newImagePaths)
                // 清空选择
                selectedItems = []
            }
        }
    }
    
    private func removeImage(at index: Int) {
        // 删除图片文件
        let path = step.imagePaths[index]
        ImageManager.shared.deleteImage(at: path)
        // 从数组中移除路径
        step.imagePaths.remove(at: index)
    }
}

#Preview {
    @Previewable @State var step = StepModel(description: "示例步骤", imagePaths: [])
    return StepEditView(step: $step, recipeId: UUID())
}

