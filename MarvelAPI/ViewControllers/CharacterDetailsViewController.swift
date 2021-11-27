//
//  CharacterDetailsViewController.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 26.11.2021.
//

import UIKit

class CharacterDetailsViewController: UIViewController {
    
    @IBOutlet weak var characterImageView: CharacterImageView! {
        didSet {
            characterImageView.contentMode = .scaleToFill
            characterImageView.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var characterResourceURI: String?
    private var character: Character?
    private var characterDescription: String {
        get {
            guard let description = character?.description, !description.isEmpty else { return "Not found description" }
            return description
        }
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        setupNavigationBar()
        
        guard let resource = characterResourceURI else { return }
        let url = MarvelAPI.shared.getFullURLBy(resourceURI: resource)
        
        NetworkManager.shared.fetchCharacter(from: url) { [weak self] result in
            switch result {
            case .success(let character):
                self?.character = character
                self?.title = character?.name
                self?.characterImageView.fetchImage(url: character?.thumbnail?.url)
                self?.descriptionLabel.text = self?.characterDescription
                self?.activityIndicator.stopAnimating()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController, let comicsVC = navController.topViewController as? ComicsTableViewController {
            comicsVC.comics = character?.comics
        }
    }
}

extension CharacterDetailsViewController {
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func setupActivityIndicator() {
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
}
