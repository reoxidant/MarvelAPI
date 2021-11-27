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

struct Character: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Image?
    let resourceURI: String?
    let comics: ComicList?
}

struct CharacterList: Decodable {
    let items: [CharacterSummary]?
}

struct CharacterSummary: Decodable {
    let resourceURI: String?
    let name: String?
    let role: String?
}
