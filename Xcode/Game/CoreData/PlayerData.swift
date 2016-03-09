//
//  PlayerData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/9/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import Foundation
import CoreData


class PlayerData: NSManagedObject {

    static func insertNew(inManagedObjectContext managedObjectContext:NSManagedObjectContext) -> PlayerData {
        let playerData = NSEntityDescription.insertNewObjectForEntityForName("PlayerData", inManagedObjectContext: managedObjectContext) as! PlayerData
        
        playerData.pokemons = NSSet()
        
        return playerData
    }
    
    func addPokemon(value: PokemonData) {
        let items = self.mutableSetValueForKey("pokemons");
        items.addObject(value)
    }
    
}
