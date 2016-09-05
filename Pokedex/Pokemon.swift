//
//  Pokemon.swift
//  Pokedex
//
//  Created by Elias Salokivi on 4.9.2016.
//  Copyright © 2016 Elias Salokivi. All rights reserved.
//

import Foundation

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
    }
}