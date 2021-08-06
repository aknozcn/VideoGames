//
//  ViewController.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import UIKit
import Kingfisher
import JGProgressHUD

class GamesViewController: UIViewController, Storyboardable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var slideImageView: UIImageView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!

    private let apiManager = APIManager()
    private let hud = JGProgressHUD()
    let viewModel = GamesViewModel()
    var games: GamesResponse? = nil


    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        searchBar.delegate = self
        viewModel.getGames()
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")

    }
}

extension GamesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        games?.results.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let viewController = GameDetailsViewController.instantiate()
        viewController.movieId =  games?.results[indexPath.row].id
        navigationController?.pushViewController(viewController, animated: true)

    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GamesCollectionViewCell else { return UICollectionViewCell() }

        if let element = games?.results[indexPath.row] {
            cell.cellItem = element
        }
        return cell
    }
}

extension GamesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            //self.viewModel.searchMovies(title: searchText)

            sliderStackView.isHidden = true
            collectionViewTopConstraint.constant = 0

            self.hud.dismiss()
        }

        if searchText.count < 1 {

            sliderStackView.isHidden = false
            collectionViewTopConstraint.constant = 252

        }
    }

    func searchBarTextDidBeginEditing(_searchBar: UISearchBar) {

        searchBar.setShowsCancelButton(true, animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {

        searchBar.endEditing(true)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        searchBar.endEditing(true)
    }

    func searchBarCancelButtonClicked(_searchBar: UISearchBar) {

        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)

    }
}


extension GamesViewController: GamesVMDelegate {
    func fetched(response: GamesResponse) {
        games = response
        collectionView.reloadData()
    }
}

