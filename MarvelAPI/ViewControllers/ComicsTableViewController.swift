//
//  ComicsTableViewController.swift
//  MarvelAPI
//
//  Created by Виталий Шаповалов on 27.11.2021.
//

import UIKit

class ComicsTableViewController: UITableViewController {
    
    var comics: ComicList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 1)
        
        setupNavigationBar()
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let comicDetailsVC = segue.destination as? ComicDetailsViewController, let indexPath = tableView.indexPathForSelectedRow {
            comicDetailsVC.comicResourceURI = comics?.items?[indexPath.row].resourceURI
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return comics?.items?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "comicCell", for: indexPath)
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white.withAlphaComponent(0.5)
        cell.selectedBackgroundView = backgroundView
        
        cell.textLabel?.text = comics?.items?[indexPath.row].name ?? ""
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ComicsTableViewController {
    private func setupNavigationBar() {
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(red: 32 / 255, green: 32 / 255, blue: 32 / 255, alpha: 0.7)
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.barTintColor = .white
    }
}
