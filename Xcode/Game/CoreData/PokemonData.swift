//
//  PokemonData.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/9/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import Foundation
import CoreData


class PokemonData: NSManagedObject {

    static func insertNew(inManagedObjectContext managedObjectContext:NSManagedObjectContext) -> PokemonData {
        
        let pokemonData = NSEntityDescription.insertNewObjectForEntityForName("PokemonData", inManagedObjectContext: managedObjectContext) as! PokemonData
        
        pokemonData.favorite = false
        
        return pokemonData
    }

}
