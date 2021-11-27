//
//  NetworkManager.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import Foundation
import UIKit

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
