//
//  CharactersTableViewController.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 25.11.2021.
//

import UIKit
import Network

class CharactersTableViewController: UITableViewController {
    
    @IBOutlet weak var prevPageBarButton: UIBarButtonItem!
    @IBOutlet weak var nextPageBarButton: UIBarButtonItem!
    
    @IBAction func managePageData(_ sender: UIBarButtonItem) {
        switch sender.tag {
        case 0:
            if currentPage == 0 { return }
            currentPage -= 1
        case 1:
            currentPage = currentPage + 1
        default:
            break
        }
    }
    
    private var currentPage: Int = 0 {
        didSet {
            let url = MarvelAPI.shared.getCharactersURL(page: currentPage, limit: 50)
            setupCharacters(with: url)
        }
    }
    
    private var characters: [Character] = []
    private var filteredCharacters: [Character] = []
    
    private lazy var searchController: UISearchController =  {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = .white
        return searchController
    }()
    
    private var searchBarIsActive: Bool {
        
        let textIsEmpty = searchController.searchBar.text?.isEmpty ?? false
        
        if searchController.isActive && !textIsEmpty {
            return true
        }
        
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.rowHeight = 125
        
        setupNavigationBar()
        setupSearchController()
        checkInternetConnection()
        setupCharacters(with: MarvelAPI.shared.getCharactersURL())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let characterDetailsVC = segue.destination as? CharacterDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            let character = searchBarIsActive ? filteredCharacters[indexPath.row] : characters[indexPath.row]
            characterDetailsVC.characterResourceURI = character.resourceURI
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBarIsActive ? filteredCharacters.count : characters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "characterCell", for: indexPath) as? CharacterTableViewCell else { return UITableViewCell() }
        
        let redBackgroundView = UIView()
        redBackgroundView.backgroundColor = UIColor(red: 230 / 255, green: 36 / 255, blue: 41 / 255, alpha: 1)
        cell.selectedBackgroundView = redBackgroundView
        
        let character = searchBarIsActive ? filteredCharacters[indexPath.row] : characters[indexPath.row]
        
        cell.configureCell(use: character)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CharactersTableViewController {
    private func setupNavigationBar() {
        title = "Marvel Characters"
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1)
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
    }
    
    private func setupSearchController() {
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.textColor = .white
        }
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func checkInternetConnection() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status != .satisfied {
                self?.showAlert(title: "Error:", message: "Failed Interner Connection!")
            }
        }
    }
    
    private func setupCharacters(with url: String) {
        NetworkManager.shared.fetchCharacters(from: url, completion: { [weak self] result in
            switch result {
            case .success(let characters):
                self?.characters = characters
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension CharactersTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filteredCharacters = characters.filter({ $0.name?.lowercased().contains(searchText.lowercased()) ?? false })
        tableView.reloadData()
    }
}
