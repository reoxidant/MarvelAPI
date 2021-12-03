//
//  Character.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation

struct CharacterDataWrapper: Decodable {
    let data: CharacterDataContainer?
}

struct CharacterDataContainer: Decodable {
    let results: [Character]?
}

struct Character: Codable {
    let name: String?
    let description: String?
    let thumbnail: Image?
    let resourceURI: String?
    let comics: ComicList?
    
    init(name: String, description: String, thumbnail: Image, resourceURI: String, comics: ComicList) {
        self.name = name
        self.description = description
        self.thumbnail = thumbnail
        self.resourceURI = resourceURI
        self.comics = comics
    }
    
    init?(json: [String: Any]) {
        name = json["name"] as? String
        description = json["description"] as? String
        thumbnail = json["thumbnail"] as? Image
        resourceURI = json["resourceURI"] as? String
        comics = json["comics"] as? ComicList
    }
    
    static func getCharacter(from value: Any) -> Character? {
        guard let value = value as? [String: Any] else { return nil }
        return Character(json: value)
    }
    
    static func getCharacters(from value: Any) -> [Character] {
        guard let value = value as? [[String: Any]] else { return [Character]() }
        return value.compactMap({ Character.init(json: $0) })
    }
}

struct CharacterList: Decodable {
    let items: [CharacterSummary]?
}

struct CharacterSummary: Decodable {
    let resourceURI: String?
    let name: String?
    let role: String?
}
