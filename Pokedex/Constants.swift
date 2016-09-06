//
//  Constants.swift
//  Pokedex
//
//  Created by Elias Salokivi on 6.9.2016.
//  Copyright © 2016 Elias Salokivi. All rights reserved.
//

import Foundation

let URL_BASE = "http://pokeapi.co"
let URL_POKEMON = "/api/v1/pokemon/"

public typealias DownloadComplete = () -> () //create a closeure that's called when a download is called. Returning nothing