# 我的菜谱 App

一个简洁优雅的个人菜谱管理应用，基于 SwiftUI 开发，支持 iOS 18.0+。

## 功能特点

### 核心功能
- 菜谱管理
  - 创建、编辑、查看、删除菜谱
  - 支持本地图片选择和管理
  - 支持菜谱分类和搜索
  - 支持烹饪笔记记录
- 本地存储
  - 菜谱数据以 JSON 格式存储
  - 图片资源本地存储，支持从相册选择
  - 完全离线运行，保护隐私

### 技术特性
- 纯 SwiftUI 开发，原生 iOS 体验
- MVVM 架构设计
- 完全离线运行，数据本地化存储
- 适配 iOS 18.0+ 系统特性

## 项目结构

```
ForMyOwn/
├── Models/                 # 数据模型
│   ├── Recipe.swift       # 菜谱基本信息模型
│   ├── RecipeDetail.swift # 菜谱详细信息模型
│   ├── StepModel.swift    # 烹饪步骤模型
│   ├── CookingNote.swift  # 烹饪笔记模型
│   └── RecipeCategory.swift   # 分类模型
├── Views/                  # 视图层
│   ├── Recipe/            # 菜谱相关视图
│   │   ├── RecipeListView.swift    # 列表视图
│   │   ├── RecipeDetailView.swift  # 详情视图
│   │   └── RecipeEditView.swift    # 编辑视图
│   └── Components/        # 可复用组件
├── Utils/                 # 工具类
│   ├── StorageManager.swift    # 存储管理
│   └── ImageManager.swift      # 图片管理
└── Resources/            # 资源文件
    └── Recipes/          # 菜谱数据存储目录
        ├── recipes.json  # 菜谱基本信息
        ├── RecipeDetails/  # 菜谱详细信息目录
        └── Images/       # 图片资源目录
```

## 数据结构

### 菜谱基本信息 (Recipe)
```swift
struct Recipe: Codable, Identifiable {
    let id: UUID
    var name: String           // 菜品名称
    var ingredients: [String]  // 食材清单
    var category: String      // 分类
    var createDate: Date      // 创建时间
}
```

### 菜谱详细信息 (RecipeDetail)
```swift
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
}
```

### 烹饪步骤 (StepModel)
```swift
struct StepModel: Codable {
    var description: String    // 步骤描述
    var imagePaths: [String]? // 可选的步骤图片路径数组
}
```

### 烹饪笔记 (CookingNote)
```swift
struct CookingNote: Codable, Identifiable {
    let id: UUID
    var content: String       // 笔记内容
    var imagePaths: [String]? // 可选的图片路径数组
    var createDate: Date      // 创建时间
}
```

## 存储设计

### 文件存储结构
- `recipes.json`: 存储所有菜谱的基本信息列表
- `RecipeDetails/{recipe-id}.json`: 每个菜谱的详细信息单独存储
- `Images/{recipe-id}_{image-id}.jpg`: 按菜谱ID组织的图片文件

### 数据管理
- 列表页面只加载基本信息，提高性能
- 详情页面按需加载完整信息
- 每个步骤和笔记可以包含多张图片
- 图片按需加载，减少内存占用

## 开发计划

### 第一阶段：基础框架
- [x] 项目初始化
- [x] 基础架构搭建
- [x] 存储管理器实现

### 第二阶段：核心功能
- [x] 菜谱列表实现
- [x] 菜谱详情页面
- [x] 菜谱创建和编辑功能

### 第三阶段：功能完善
- [x] 本地图片管理
- [x] 搜索功能
- [x] UI/UX 优化
- [ ] 烹饪笔记功能
- [ ] 封面图管理

## 技术依赖
- SwiftUI
- Foundation
- PhotosUI (本地图片选择)

## 最低系统要求
- iOS 18.0+
- Xcode 15.0+
- Swift 5.9+

## 注意事项
- 应用数据完全存储在本地，请定期备份重要数据
- 图片选择仅支持本地相册
- 首次使用需要授予相册访问权限