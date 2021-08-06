//
//  CDGames+CoreDataProperties.swift
//  VideoGames
//
//  Created by Akin O. on 6.08.2021.
//
//

import Foundation
import CoreData


extension CDGames {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDGames> {
        return NSFetchRequest<CDGames>(entityName: "CDGames")
    }

    @NSManaged public var game_id: String?

}

extension CDGames : Identifiable {

}
