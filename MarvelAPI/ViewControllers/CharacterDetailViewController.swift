//
//  CharacterDetailViewController.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: CharacterImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var characterResourceURI: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let resource = characterResourceURI else { return }
        let url = MarvelAPI.shared.getCharacterURL(resourceURI: resource)
        
        NetworkManager.shared.fetchCharacter(from: url) { [weak self] result in
            switch result {
            case .success(let character):
                guard let character = character else { return }
                self?.characterImageView.fetchImage(url: character.thumbnail?.url)
                self?.descriptionLabel.text = character.description ?? "Not found description"
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
