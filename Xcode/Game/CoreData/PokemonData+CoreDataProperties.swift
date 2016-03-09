//
//  PokemonData+CoreDataProperties.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/9/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension PokemonData {

    @NSManaged var name: String?
    @NSManaged var favorite: NSNumber
    @NSManaged var playerData: PlayerData?

}
