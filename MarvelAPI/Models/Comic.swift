//
//  Comic.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation

struct Comic: Decodable {
    let title: String?
    let description: String?
    let dates: [ComicDate]?
    let prices: [ComicPrice]?
}

struct ComicDate: Decodable {
    let type: String?
    let date: Date?
}

struct ComicPrice: Decodable {
    let type: String?
    let price: Float?
}

struct ComicList: Decodable {
    let items: [ComicSummary]?
}

struct ComicSummary: Decodable {
    let resourceURI: String?
    let name: String?
}
