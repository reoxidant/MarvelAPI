//
//  NetworkManager.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation
import UIKit
import Alamofire

class NetworkManager {
    
    static let shared = NetworkManager()
    
    func fetchCharacters(from url: String, completion: @escaping (Result<[Character], Error>) -> Void ) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: Result<[Character], Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
            }
            
            guard let data = data, let container = try? JSONDecoder().decode(CharacterDataWrapper.self, from: data) else {
                return result = .success([])
            }
            
            if let characters = container.data?.results {
                result = .success(characters)
            } else {
                result = .success([])
            }
            
        }.resume()
    }
    
    func fetchAlamofireCharacters(from url: String, completion: @escaping (Result<[Character], Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url).validate().responseJSON { responseData in
            
            var result: Result<[Character], Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            switch responseData.result {
                
            case .success(_):
                guard let data = responseData.data else {
                    result = .success([])
                    return
                }
                
                do {
                    let container = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                    
                    if let characters = container.data?.results {
                        result = .success(characters)
                    } else {
                        result = .success([])
                    }
                }
                catch let error {
                    result = .failure(error)
                }
                
            case .failure(let error):
                result = .failure(error)
            }
        }
    }
    
    func pushAlamofirePostRequestWithDictionary(from url: String, completion: @escaping (Result<Character?, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        let character: [String : Any] = [
            "name": "Masha Sokolova",
            "description": "Masha has lived all her life in a parasha village with her drunken parents, she has a brother who is a complete fucker, she decided to leave her parents to get a home for herself, for this she used her ability to borrow, took 5 years of fucking loans and began to live unhappily",
            "thumbnail": ["path": "", "extension": ""],
            "resourceURI": "",
            "comics": ["items":["resourceURI": "", "name": ""]]
        ]
        
        AF.request(url, method: .post, parameters: character).validate().responseJSON { responseData in
            
            var result: Result<Character?, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            switch responseData.result {
            case .success(let value):
                guard let jsonData = value as? [String: Any] else {
                    result = .success(nil)
                    return
                }
                
                let character = Character.getCharacter(from: jsonData)
                
                result = .success(character)
            case .failure(let error):
                result = .failure(error)
            }
        }
    }
    
    func pushPostRequestWithDictionary(from url: String, completion: @escaping (Result<Character?, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        let character: [String : Any] = [
            "name": "Masha Sokolova",
            "description": "Masha has lived all her life in a parasha village with her drunken parents, she has a brother who is a complete fucker, she decided to leave her parents to get a home for herself, for this she used her ability to borrow, took 5 years of fucking loans and began to live unhappily",
            "thumbnail": ["path": "", "extension": ""],
            "resourceURI": "",
            "comics": ["items":["resourceURI": "", "name": ""]]
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: character, options: [])
            
            var request = URLRequest(url: url)
            request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                var result: Result<Character?, Error>
                
                defer {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
                if let error = error {
                    result = .failure(error)
                    return
                }
                
                guard let data = data else {
                    result = .success(nil)
                    return
                }
                
                do {
                    let value = try JSONSerialization.jsonObject(with: data, options: [])
                    result = .success(Character.getCharacter(from: value))
                }
                catch let error {
                    result = .failure(error)
                }
                
            }.resume()
        }
        catch let error {
            print(error)
        }
    }
    
    func pushPostRequestWithModel(from url: String, completion: @escaping (Result<Character?, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let character = Character(name: "Masha Sokolova", description: "Masha has lived all her life in a parasha village with her drunken parents, she has a brother who is a complete fucker, she decided to leave her parents to get a home for herself, for this she used her ability to borrow, took 5 years of fucking loans and began to live unhappily", thumbnail: Image(path: "", imageExtension: ""), resourceURI: "", comics: ComicList(items: nil))
        
        do {
            let data = try JSONEncoder().encode(character)
            
            var request = URLRequest(url: url)
            request.addValue("aplication/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                
                var result: Result<Character?, Error>
                
                defer {
                    DispatchQueue.main.async {
                        completion(result)
                    }
                }
                
                if let error = error {
                    result = .failure(error)
                    return
                }
                
                guard let data = data else {
                    result = .success(nil)
                    return
                }
                
                do {
                    let character = try JSONDecoder().decode(Character.self, from: data)
                    result = .success(character)
                }
                catch let error {
                    result = .failure(error)
                }
                
            }.resume()
        }
        catch let error {
            print(error)
        }
    }
    
    func fetchCharacter(from url: String, completion: @escaping (Result<Character?, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: Result<Character?, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
            }
            
            guard let data = data else {
                result = .success(nil)
                return
            }
            
            do {
                let container = try JSONDecoder().decode(CharacterDataWrapper.self, from: data)
                result = .success(container.data?.results?.first)
            }
            catch let error {
                result = .failure(error)
                return
            }
            
        }.resume()
    }
    
    func fetchComic(from url: String, completion: @escaping (Result<Comic?, Error>) -> Void) {
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            var result: Result<Comic?, Error>
            
            defer {
                DispatchQueue.main.async {
                    completion(result)
                }
            }
            
            if let error = error {
                result = .failure(error)
                return
            }
            
            guard let data = data else {
                result = .success(nil)
                return
            }
            
            do {
                let container = try JSONDecoder().decode(ComicDataWrapper.self, from: data)
                result = .success(container.data?.results?.first)
            }
            catch let error {
                result = .failure(error)
                return
            }
            
        }.resume()
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data, URLResponse) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data, let response = response else {
                return
            }
            
            completion(data, response)
            
        }.resume()
    }
}
