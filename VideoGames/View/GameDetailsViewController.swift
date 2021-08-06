//
//  GameDetailsViewController.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import UIKit
import Kingfisher
import JGProgressHUD
import MotionToastView

class GameDetailsViewController: UIViewController, Storyboardable {

    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!
    @IBOutlet weak var gameDescriptionTextView: UITextView!
    @IBOutlet weak var favoritesButton: UIButton!

    private let manager: CoreDataManager = CoreDataManager()

    private let apiManager = APIManager()
    let viewModel = GameDetailsViewModel()
    let hud = JGProgressHUD()
    var gameId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self

        hud.textLabel.text = "Loading"
        hud.show(in: self.view)
        viewModel.getGameDetails(gameId: gameId!)
        viewModel.checkFavoritesGame(gameId: gameId!)
        hud.dismiss()

    }

    @IBAction func buttonFavoriesClicked(_ sender: Any) {
        if manager.createGameId(gameId: gameId!) {
            favoritesButton.setImage(UIImage.init(named: "star.fill"), for: .normal)
            MotionToast(message: "Favorites to added", toastType: .success, toastCornerRadius: 12)

        } else {
            let alert = UIAlertController(title: "Alert", message: "will be deleted from favourites", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: { action in
                
                self.viewModel.deleteFavoritesGame(gameId: self.gameId!)

            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))

            self.present(alert, animated: true, completion: nil)



        }
    }
}

extension GameDetailsViewController: GameDetailsVMDelegate {

    func fetched(response: GameDetailsResponse) {

        if let url = URL(string: "\(response.backgroundImage)") {
            gameImageView.kf.setImage(with: url)
        }
        gameNameLabel.text = response.name
        gameRatingLabel.text = "\(response.metacritic)"
        gameDescriptionTextView.text = response.descriptionRaw
        gameReleasedLabel.text = response.released
    }

    func checkFavoritesGame(status: Bool) {
        if status {
            favoritesButton.setImage(UIImage.init(named: "star.fill"), for: .normal)
        } else {
            favoritesButton.setImage(UIImage.init(named: "star"), for: .normal)
        }
    }

}
