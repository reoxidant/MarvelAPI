//
//  CharacterTableViewCell.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var characterImageView: CharacterImageView! {
        didSet {
            characterImageView.contentMode = .scaleToFill
            characterImageView.clipsToBounds = true
            characterImageView.layer.cornerRadius = 10
            characterImageView.backgroundColor = .systemBackground
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    
    func configureCell(use character: Character) {
        nameLabel.text = character.name
        characterImageView.fetchImage(url: character.thumbnail?.url)
    }
}
