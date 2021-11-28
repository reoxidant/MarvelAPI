//
//  Image.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation

struct Image: Codable {
    let path: String?
    let imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path = "path"
        case imageExtension = "extension"
    }
    
    var url: String {
        if let path = path, let imageExt = imageExtension {
            return path + "." + imageExt
        }
        
        return ""
    }
}
