//
//  ExercicioTeste2.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/1/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class ExercicioTeste2: GameScene {
    
    var dados:[String:AnyObject]!
    
    var onHandPokemonsScrollNode:ScrollNode!
    
    init(dados:[String:AnyObject]) {
        super.init()
        self.dados = dados
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.addChild(Control(textureName: "background", z:-1000, xAlign: .center, yAlign: .center))
        
        let trainerData = self.dados["data"] as! [String:AnyObject]
        
        let name = trainerData["name"] as! String
        let age = trainerData["age"] as! Int
        let photo = trainerData["photo"] as! String
        let town = trainerData["town"] as! String
        
        self.addChild(Trainer(name: name, age: age, photo: photo, town: town, x:103, y:25, xAlign:.center, yAlign:.center))
        
        for pokemon in (self.dados["data"] as! [String:AnyObject])["onHandPokemons"] as! [AnyObject] {
            
            let pokemonData = pokemon as! [String:AnyObject]
            
            let number = pokemonData["number"] as! Int
            let name = pokemonData["name"] as! String
            let icon = pokemonData["icon"] as! String
            let image = pokemonData["image"] as! String
            let level = pokemonData["level"] as! Int
            let type1 = pokemonData["type1"] as! String
            let type2 = pokemonData["type2"] as? String
            
            //pokemonData["status"] as! [String:AnyObject]
            //pokemonData["skills"] as! [[String:AnyObject]]
            
            PokemonCell.types.append(PokemonCellType(number: number, name: name, icon: icon, image: image, level: level, type1: type1, type2: type2))
        }
        
        var cells = Array<Control>()
        
        for var i = 0; i < PokemonCell.types.count; i++ {
            cells.append(PokemonCell(type: i))
        }
        
        self.onHandPokemonsScrollNode = ScrollNode(cells: cells, x: 135, y: 99, xAlign: .center, yAlign: .center, spacing: 19, scrollDirection: .horizontal)
        
        self.addChild(self.onHandPokemonsScrollNode)
    }
}
