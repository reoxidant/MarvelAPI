//
//  Character.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation

struct Character: Decodable {
    let name: String?
    let description: String?
    let thumbnail: Image?
    let resourceURI: String?
    let comics: ComicList?
}

struct CharacterDataContainer: Decodable {
    let results: [Character]?
}

struct CharacterDataWrapper: Decodable {
    let data: CharacterDataContainer?
}
