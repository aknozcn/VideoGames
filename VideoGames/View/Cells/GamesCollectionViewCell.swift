//
//  GamesCollectionViewCell.swift
//  VideoGames
//
//  Created by Akin O. on 3.08.2021.
//

import UIKit

class GamesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gameImageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var gameRatingLabel: UILabel!
    @IBOutlet weak var gameReleasedLabel: UILabel!

    var cellItem: GameResult! {
        didSet{
            if let url = URL(string: "\(cellItem.backgroundImage)") {
                gameImageView.kf.setImage(with: url)
            }
            gameNameLabel.text = cellItem.name
            gameRatingLabel.text = "\(cellItem.metacritic)"
            gameReleasedLabel.text = cellItem.released
            self.clipsToBounds = false
            gameImageView.layer.cornerRadius = 9
            gameImageView.contentMode = .scaleAspectFill
        }
    }
    
}
