//
//  CoreDataRepository.swift
//  VideoGames
//
//  Created by Akin O. on 4.08.2021.
//

import Foundation
import CoreData

struct CoreDataRepository: Repository {

    func create(gameId: Int) -> Bool {

        if !checkExistsGameId(byId: gameId) {
            let cdGameId = CDGames(context: PersistentStorage.shared.context)
            cdGameId.game_id = String(gameId)
            PersistentStorage.shared.saveContext()
            return true
        }
        return false
    }

    func getAll() -> [String]? {

        var gameId: [String] = []
        let fetchRequest = NSFetchRequest<CDGames>(entityName: "CDGames")

        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest)

            for item in result as [NSManagedObject] {
                if let dataSelected = (item.value(forKey: "game_id")!) as? String {
                    gameId.append(dataSelected)
                }
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return gameId
    }


    func delete(id: Int) -> Bool {
        let cdGameId = getCDGameId(byId: id)
        guard cdGameId != nil else { return false }

        PersistentStorage.shared.context.delete(cdGameId!)
        PersistentStorage.shared.saveContext()
        return true
    }

    func checkExistsGameId(byId id: Int) -> Bool {
        let fetchRequest = NSFetchRequest<CDGames>(entityName: "CDGames")
        let predicate = NSPredicate(format: "game_id==%@", String(id) as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return false }
            return true

        } catch let error {
            debugPrint(error)
        }
        return false

    }

    private func getCDGameId(byId id: Int) -> CDGames? {
        let fetchRequest = NSFetchRequest<CDGames>(entityName: "CDGames")
        let predicate = NSPredicate(format: "game_id==%@", String(id) as CVarArg)

        fetchRequest.predicate = predicate
        do {
            let result = try PersistentStorage.shared.context.fetch(fetchRequest).first

            guard result != nil else { return nil }
            return result

        } catch let error {
            debugPrint(error)
        }
        return nil
    }
}

