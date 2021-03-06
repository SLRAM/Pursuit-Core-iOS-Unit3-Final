//
//  FavoritesViewController.swift
//  Elements
//
//  Created by Stephanie Ramirez on 1/4/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var favorites = [Favorite]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchFavorites()
    }
    
    private func fetchFavorites() {
        ElementAPIClient.getFavorites(name: "Stephanie") { (appError, favorites) in
            if let appError = appError {
                print(appError.errorMessage())
            } else if let favorites = favorites {
                self.favorites = favorites
            }
        }
    }
}

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
        let favorite = favorites[indexPath.row]
        cell.textLabel?.text = favorite.name
//        if let image = ImageHelper.shared.image(forKey: favorite.artworkUrl600.absoluteString as NSString) {
//            cell.imageView?.image = image
//        } else {
//            ImageHelper.shared.fetchImage(urlString: favorite.artworkUrl600.absoluteString) { (appError, image) in
//                if let appError = appError {
//                    print(appError.errorMessage())
//                } else if let image = image {
//                    cell.imageView?.image = image
//                }
//            }
//        }
        return cell
    }
}

