//
//  PokemonDetailVC.swift
//  Pokedex
//
//  Created by Elias Salokivi on 5.9.2016.
//  Copyright © 2016 Elias Salokivi. All rights reserved.
//

import UIKit

class PokemonDetailVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    var pokemon: Pokemon!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl.text = pokemon.name
    }
}
