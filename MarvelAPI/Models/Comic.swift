//
//  Comic.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation

struct ComicDataWrapper: Decodable {
    let data: ComicDataContainer?
}

struct ComicDataContainer: Decodable {
    let results: [Comic]?
}

struct Comic: Decodable {
    let title: String?
    let description: String?
    let characters: CharacterList?
    
    var fullDescription: String {
        guard let description = description, !description.isEmpty else { return "Not found description" }
        
        return """
        Description:
        
        \(description)
        """
    }
}

struct ComicList: Codable {
    let items: [ComicSummary]?
}

struct ComicSummary: Codable {
    let resourceURI: String?
    let name: String?
}
