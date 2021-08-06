//
//  FavoritesViewController.swift
//  VideoGames
//
//  Created by Akin O. on 5.08.2021.
//

import UIKit
import Kingfisher
import JGProgressHUD

class FavoritesViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    let viewModel = FavoritesViewModel()
    let hud = JGProgressHUD()
    var games: GamesResponse? = nil
    var filteredGames: [GameResult]?

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self

        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        viewModel.getGames()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getGameId()
    }
}

extension FavoritesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredGames?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewController = GameDetailsViewController.instantiate()
        viewController.gameId = filteredGames?[indexPath.row].id
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? FavoritesCollectionViewCell else { return UICollectionViewCell() }
        if let element = filteredGames?[indexPath.row] {
            cell.cellItem = element
        }
        return cell
    }
}

extension FavoritesViewController: FavoritesVMDelegate {

    func fetched(response: GamesResponse) {
        games = response
        hud.dismiss()
    }

    func gameIdFetched(data: [String]?) {

        filteredGames = games?.results.filter({ (game) -> Bool in
            collectionView.reloadData()
            return data?.contains(String(game.id)) ?? false;
        })

    }
}
