//
//  ComicDetailsViewController.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 27.11.2021.
//

import UIKit

class ComicDetailsViewController: UIViewController {

    @IBOutlet weak var comicDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var comicResourceURI: String?
    var comic: Comic?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
        
        guard let resource = comicResourceURI else { return }
        let url = MarvelAPI.shared.getFullURLBy(resourceURI: resource)
        
        NetworkManager.shared.fetchComic(from: url) { [weak self] result in
            switch result {
            case .success(let comic):
                self?.comic = comic
                self?.title = comic?.title
                self?.comicDescriptionLabel.text = comic?.fullDescription
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let characterDetailsVC = segue.destination as? CharacterDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            characterDetailsVC.characterResourceURI = comic?.characters?.items?[indexPath.row].resourceURI
        }
    }
}

extension ComicDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        comic?.characters?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white.withAlphaComponent(0.5)
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.text = comic?.characters?.items?[indexPath.row].name
        return cell
    }
}

extension ComicDetailsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
