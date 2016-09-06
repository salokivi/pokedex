//
//  Pokemon.swift
//  Pokedex
//
//  Created by Elias Salokivi on 4.9.2016.
//  Copyright © 2016 Elias Salokivi. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name: String!
    private var _pokedexId: Int!
    private var _description: String!
    private var _type: String!
    private var _defense: String!
    private var _height: String!
    private var _weight: String!
    private var _attack: String!
    private var _nextEvolutionTxt: String!
    private var _nextEvolutionId: String!
    private var _nextEvolutionLvl: String!
    private var _pokemonUrl: String!
    
    var nextEvolutionTxt: String {
        if _nextEvolutionTxt == nil {
            _nextEvolutionTxt = ""
        }
        
        return _nextEvolutionTxt
    }
    
    var nextEvolutionLvl: String {
        if _nextEvolutionLvl == nil {
            _nextEvolutionLvl = ""
        }
        return _nextEvolutionLvl
    }
    
    var nextEvolutionId: String {
        if _nextEvolutionId == nil {
            _nextEvolutionId = ""
        }
        return _nextEvolutionId
    }
    
    var description: String {
        if _description == nil {
            _description = ""
        }
        return _description
    }
    
    var type: String {
        if _type == nil {
            _type = ""
        }
        return _type
    }
    
    var defense: String {
        if _defense == nil {
            _defense = ""
        }
        return _defense
    }
    
    var height: String {
        if _height == nil {
            _height = ""
        }
        return _height
    }
    
    var weight: String {
        if _weight == nil {
            _weight = ""
        }
        return _weight
    }
    
    var attack: String {
        if _attack == nil {
            _attack = ""
        }
        return _attack
    }
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    /*
    var pokemonUrl: String {
        return _pokemonUrl
    }
    */
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonUrl = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete) {
        
        let url = NSURL(string: _pokemonUrl)!
        
        Alamofire.request(.GET, url).responseJSON { response in
            let result = response.result // this is run when the request is done
            
            //convert the JSONresult into an iOS Dictionary
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                if let weight = dict["weight"] as? String {
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String {
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int {
                    self._attack = "\(attack)" // cast to integer
                }
                
                if let defense = dict["defense"] as? Int {
                    self._defense = "\(defense)"   // cast to integer
                }
                
                print(self._attack)     // API: integer
                print(self._defense)    // API: integer
                print(self._height)     // API: string
                print(self._weight)     // API: string
                
                // an array of type dictionary, and each dictionary has key:value = String:String. Casting it to array. Do nothing if it's empty
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0 {
                
                    // grab first element in array with the property "name" and assign it
                    if let name = types[0]["name"] {
                        self._type = name.capitalizedString
                    }
                    
                    // there could be several types. concatenate and add a slash between
                    if types.count > 1 {
                        
                        for var x = 1; x < types.count; x++ {
                            if let name = types[x]["name"] {
                                self._type! += "/\(name.capitalizedString)"
                            }
                        }
                    }
                    
                } else {
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0{
                    
                    if let url = descArr[0]["resource_uri"] {
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON { response in
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String, AnyObject> {
                                
                                if let description = descDict["description"] as? String {
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed() // call completed, when download is completed. ok or error
                        }
                    }
                } else {
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String, AnyObject>] where evolutions.count > 0 {
                    
                    if let to = evolutions[0]["to"] as? String {
                        
                        // nil -> Mega is not found. Can't support Mega right now. API still has mega data
                        if to.rangeOfString("mega") == nil {
                            
                            if let uri = evolutions[0]["resource_uri"] as? String {
                                
                                // get rid of the beginning. replace it with ""
                                let newString = uri.stringByReplacingOccurrencesOfString("/api/v1/pokemon", withString: "")
                                
                                let num = newString.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int {
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionLvl)
                                print(self._nextEvolutionTxt)
                            }
                        }
                    }
                }
            }
        }
    }
}