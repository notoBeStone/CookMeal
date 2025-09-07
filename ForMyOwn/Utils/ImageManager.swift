//
//  ImageManager.swift
//  ForMyOwn
//
//  Created by 彭瑞淋 on 2024/3/27.
//

import Foundation
import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private init() {}
    
    private var imagesDirectory: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentsDirectory.appendingPathComponent("Recipes/Images")
    }
    
    func saveImage(_ image: UIImage, forRecipe recipeId: UUID) -> String? {
        let fileName = "\(recipeId)_\(UUID().uuidString).jpg"
        let fileURL = imagesDirectory.appendingPathComponent(fileName)
        
        guard let data = image.jpegData(compressionQuality: 0.8) else {
            debugPrint("Error converting image to data")
            return nil
        }
        
        do {
            try data.write(to: fileURL)
            debugPrint("Saved image at: \(fileURL.path)")
            return fileURL.path
        } catch {
            debugPrint("Error saving image: \(error)")
            return nil
        }
    }
    
    func loadImage(from path: String) -> UIImage? {
        return UIImage(contentsOfFile: path)
    }
    
    func deleteImage(at path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
            debugPrint("Deleted image at: \(path)")
        } catch {
            debugPrint("Error deleting image: \(error)")
        }
    }
}

