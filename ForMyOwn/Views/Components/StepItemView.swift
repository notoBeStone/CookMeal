import SwiftUI

struct StepItemView: View {
    let step: StepModel
    let index: Int
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                Text("\(index + 1). ")
                    .foregroundColor(.secondary)
                Text(step.description)
                    .foregroundColor(.primary)
            }
            
            // 显示步骤图片
            if !step.imagePaths.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 8) {
                        ForEach(step.imagePaths.indices, id: \.self) { imageIndex in
                            StepImageView(imagePath: step.imagePaths[imageIndex])
                        }
                    }
                }
                .frame(height: 100)
            }
        }
        .onTapGesture {
            onEdit()
        }
        .swipeActions {
            Button(role: .destructive, action: onDelete) {
                Label("删除", systemImage: "trash")
            }
        }
        
    }
}

// 异步加载图片的组件
struct StepImageView: View {
    let imagePath: String
    @State private var image: UIImage?
    
    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
        }
        .onAppear {
            if let loadedImage = ImageManager.shared.loadImage(from: imagePath) {
                self.image = loadedImage
            }
        }
    }
}

#Preview {
    StepItemView(
        step: StepModel(description: "示例步骤", imagePaths: []),
        index: 0,
        onEdit: {},
        onDelete: {}
    )
}
