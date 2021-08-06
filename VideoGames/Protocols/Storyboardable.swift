//
//  Storyboardable.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import Foundation
import UIKit

protocol Storyboardable {

    static var storyboardName: String { get }
    static var storyboardIdentifier: String { get }
    static func instantiate() -> Self
}

extension Storyboardable where Self: UIViewController {

    static var storyboardName: String {
        return "Main"
    }

    static var storyboardIdentifier: String {
        return String(describing: self)
    }

    static func instantiate() -> Self {
        guard let viewController = UIStoryboard(name: storyboardName, bundle: nil).instantiateViewController(withIdentifier: storyboardIdentifier) as? Self else {
            fatalError("storyboardIdentifier: \(storyboardIdentifier)")
        }
        return viewController
    }
}
