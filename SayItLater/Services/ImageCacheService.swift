//
//  ImageCacheService.swift
//  SayItLater
//
//  Created by Ayodimeji Adedotun on 06/01/2026.
//

import Foundation
import UIKit

class ImageCacheService {
    static let shared = ImageCacheService()
    
    private let cache = NSCache<NSString, UIImage>()
    private var loadingTasks: [String: URLSessionDataTask] = [:]
    private let queue = DispatchQueue(label: "com.sayitlater.imagecache", attributes: .concurrent)
    
    private init() {
        cache.countLimit = 20
        cache.totalCostLimit = 50 * 1024 * 1024 // 50MB
    }
    
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        // Check cache first
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage)
            }
            return
        }
        
        // Check if already loading
        queue.async(flags: .barrier) { [weak self] in
            guard let self = self else { return }
            
            if let existingTask = self.loadingTasks[urlString] {
                // Task already exists, we could add multiple completion handlers here
                // For simplicity, we'll just let it complete
                return
            }
            
            guard let url = URL(string: urlString) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self,
                      let data = data,
                      error == nil,
                      let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    self?.queue.async(flags: .barrier) {
                        self?.loadingTasks.removeValue(forKey: urlString)
                    }
                    return
                }
                
                // Cache the image
                self.cache.setObject(image, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    completion(image)
                }
                
                self.queue.async(flags: .barrier) {
                    self.loadingTasks.removeValue(forKey: urlString)
                }
            }
            
            self.loadingTasks[urlString] = task
            task.resume()
        }
    }
    
    func preloadImage(from urlString: String) {
        loadImage(from: urlString) { _ in }
    }
}
