//
//  ViewController.swift
//  Pokedex
//
//  Created by Elias Salokivi on 4.9.2016.
//  Copyright © 2016 Elias Salokivi. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {

    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var pokemon = [Pokemon]()
    var filteredPokemon = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done // hitting return in the searchBar will hide the keyboard
        initAudio()
        parsePokemonCSV()
    }
    
    func initAudio() {
    
            let path = NSBundle.mainBundle().pathForResource("music", ofType: "mp3")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOfURL: NSURL(string: path!)!)
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func parsePokemonCSV() {
        let path = NSBundle.mainBundle().pathForResource("pokemon", ofType: "csv")!
        
        do {
            let csv = try CSV(contentsOfURL: path)
            let rows = csv.rows
            
            for row in rows {
                let pokeId = Int(row["id"]!)! // the csv: each row is a dictionary [id:name]
                let name = row["identifier"]! // name of the character
                let poke = Pokemon(name: name, pokedexId: pokeId)
                pokemon.append(poke)
            }
            
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PokeCell", forIndexPath: indexPath) as? PokeCell {
            
            //var pokemon = Pokemon(name: "Test", pokedexId: indexPath.row)
            //let poke = pokemon[indexPath.row] // get a pokemon from the pokemon-array
            
            let poke: Pokemon!
            
            if inSearchMode {
                poke = filteredPokemon[indexPath.row] // if we are searching, grab it from the filtered list
            } else {
                poke = pokemon[indexPath.row]       // if not searching, grab from the normal list
            }
            
            cell.configureCell(poke)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    // A pokemon was tapped
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var poke: Pokemon!
        
        if inSearchMode {
            poke = filteredPokemon[indexPath.row]
        } else {
            poke = pokemon[indexPath.row]
        }
        
        performSegueWithIdentifier("PokemonDetailVC", sender: poke) // pass in the pokemon when doing the segue
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredPokemon.count
        } else {
            return pokemon.count

        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    @IBAction func musicBtnPressed(sender: UIButton!) {
        if musicPlayer.playing {
            musicPlayer.stop()
            sender.alpha = 0.2 // dim the button a bit when the music is not playing
        } else {
            musicPlayer.play()
            sender.alpha = 1.0 // display the button normally when playing
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    // detect when text is etered in the searchBar
    func  searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true) // close the keyboard
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString // grab the current text in the searchBar
            filteredPokemon = pokemon.filter({$0.name.rangeOfString(lower) != nil}) // $0 grab an element from the array and put it in a variable and grab it's name property. For all Pokemon in thr array. Also rangeOfString checks if any of the name-string contain the string in the searchBar (lower). The closure is being run for every element
            collection.reloadData() // refresh with the datasource
        }
    }
    
    // this is done befoew viewDidLoad() in this ViewController. We'll get the Pokemon that was tapped, and will display it's details
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PokemonDetailVC" {
            
            // grab the UIViewController and Cast it to PokemonDetailVC (inherits from UIViewController)
            if let detailsVC = segue.destinationViewController as? PokemonDetailVC {
                
                // we're sending a pokemon but sender is an object so we must cast it to Pokemon for poke
                if let poke = sender as? Pokemon {
                    detailsVC.pokemon = poke
                }
            }
        }
    }
}




