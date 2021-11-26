//
//  CharacterImageView.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import UIKit

class CharacterImageView: UIImageView {
    
    func fetchImage(url: String?) {
        
        guard let url = url, let imageUrl = URL(string: url) else {
            image = UIImage(named: "picture")
            return
        }
        
        if let cachedImage = getImageFromCache(with: imageUrl) {
            image = cachedImage
            return
        }
        
        NetworkManager.shared.fetchImage(from: imageUrl) { [weak self] data, response in
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
            
            self?.saveImageToCache(with: data, and: response)
        }
    }
    
    private func getImageFromCache(with url: URL) -> UIImage? {
        let urlRequest = URLRequest(url: url)
        if let cachedResponse = URLCache.shared.cachedResponse(for: urlRequest) {
            return UIImage(data: cachedResponse.data)
        }
        
        return nil
    }
    
    private func saveImageToCache(with data: Data, and response: URLResponse) {
        guard let url = response.url else { return }
        let urlRequest = URLRequest(url: url)
        let cachedResponse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResponse, for: urlRequest)
    }
}
