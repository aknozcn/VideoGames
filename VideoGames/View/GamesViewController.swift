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
    @IBOutlet weak var noDataLabel: UILabel!

    private let apiManager = APIManager()
    private let hud = JGProgressHUD()
    let viewModel = GamesViewModel()
    var games: GamesResponse? = nil

    var droppedGames: [GameResult]?
    var slideGames: [GameResult]?
    var searchedGames: [GameResult]?

    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(urls[urls.count - 1] as URL)
        UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
        collectionView.delegate = self
        collectionView.dataSource = self
        viewModel.delegate = self
        searchBar.delegate = self
        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        viewModel.getGames()
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeLeftImage))
        slideImageView.isUserInteractionEnabled = true
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        slideImageView.addGestureRecognizer(swipeLeftGesture)

        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(SwipeRightImage))
        swipeRightGesture.direction = UISwipeGestureRecognizer.Direction.right
        slideImageView.addGestureRecognizer(swipeRightGesture)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        slideImageView.addGestureRecognizer(tapGestureRecognizer)


    }

    @objc func SwipeLeftImage() {
        pageController.currentPage += 1
        setSlideImages()
    }
    @objc func SwipeRightImage() {
        pageController.currentPage -= 1
        setSlideImages()
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let viewController = GameDetailsViewController.instantiate()
        viewController.gameId = slideGames?[pageController.currentPage].id
        navigationController?.pushViewController(viewController, animated: true)
    }

    func setSlideImages() {

        switch pageController.currentPage {
        case 0:
            if let url = URL(string: "\(slideGames?[pageController.currentPage].backgroundImage ?? "")") {
                slideImageView.kf.setImage(with: url)
            }
            UIView.transition(with: slideImageView, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case 1:

            if let url = URL(string: "\(slideGames?[pageController.currentPage].backgroundImage ?? "")") {
                slideImageView.kf.setImage(with: url)
            }
            UIView.transition(with: slideImageView, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        case 2:

            if let url = URL(string: "\(slideGames?[pageController.currentPage].backgroundImage ?? "")") {
                slideImageView.kf.setImage(with: url)
            }
            UIView.transition(with: slideImageView, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        default:
            pageController.currentPage = 0
        }
    }
}

extension GamesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        if searching {
            return searchedGames?.count ?? 0
        } else {
            return droppedGames?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let viewController = GameDetailsViewController.instantiate()
        if searching {
            viewController.gameId = searchedGames?[indexPath.row].id
        } else {
            viewController.gameId = droppedGames?[indexPath.row].id
        }
        navigationController?.pushViewController(viewController, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? GamesCollectionViewCell else { return UICollectionViewCell() }

        if searching {
            if let element = searchedGames?[indexPath.row] {
                cell.cellItem = element
            }
        } else {
            if let element = droppedGames?[indexPath.row] {
                cell.cellItem = element
            }
        }

        return cell
    }
}

extension GamesViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            hud.textLabel.text = "Loading"
            hud.show(in: self.view)
            searchedGames = games?.results.filter({ data -> Bool in
                let searchLowercased = searchText.lowercased()
                let matches: [String?] = [data.name]
                let nonNilElements = matches.compactMap { $0 }

                for element in nonNilElements {
                    if element.lowercased().contains(searchLowercased) {
                        return true
                    }
                }
                return false
            }) ?? []

            if searchedGames!.count == 0 {
                noDataLabel.isHidden = false
                collectionView.isHidden = true
            }

            searching = true
            sliderStackView.isHidden = true
            collectionViewTopConstraint.constant = 0
            collectionView.reloadData()
            self.hud.dismiss()
        }

        if searchText.count < 1 {
            searching = false
            sliderStackView.isHidden = false
            noDataLabel.isHidden = true
            collectionView.isHidden = false
            collectionViewTopConstraint.constant = 252
            collectionView.reloadData()
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
        searching = false
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.endEditing(true)
    }
}

extension GamesViewController: GamesVMDelegate {
    func fetched(response: GamesResponse) {

        games = response
        let arraySlice = response.results[0..<3]
        slideGames = Array(arraySlice)

        if let dropGames = games?.results.dropFirst(3) {
            droppedGames = Array(dropGames)
        }

        if let url = URL(string: "\(slideGames?[pageController.currentPage].backgroundImage ?? "")") {
            slideImageView.kf.setImage(with: url)
        }

        collectionView.reloadData()
        hud.dismiss()
    }
}

