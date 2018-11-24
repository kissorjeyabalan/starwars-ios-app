//
//  APISynchronizer.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 10/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation
import CoreData

class APISynchronizer: NSObject {
    static let shared = APISynchronizer()
    public var managedObjectContext: NSManagedObjectContext?
    
    override init() {
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: "CharactersSynchronized", options: NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "MoviesSynchronized", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    func syncAll() {
        UserDefaults.standard.set(false, forKey: "CharactersSynchronized")
        UserDefaults.standard.set(false, forKey: "MoviesSynchronized")
        UserDefaults.standard.set(false, forKey: "ApiSynchronized")
        syncMovies(with: URL(string: "https://swapi.co/api/films/")!)
        syncCharacters(with: URL(string: "https://swapi.co/api/people/")!)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let objectIsSynchronized = change?[.newKey] as? Bool {
            let other = keyPath == "MoviesSynchronized" ? "CharactersSynchronized" : "MoviesSynchronized"
            let otherIsSynchronized = UserDefaults.standard.bool(forKey: other)
            
            if (otherIsSynchronized && objectIsSynchronized) {
                UserDefaults.standard.set(true, forKey: "ApiSynchronized")
            } else {
                UserDefaults.standard.set(false, forKey: "ApiSynchronized")
            }
        }
    }
    
    func syncMovies(with startUrl: URL) {
        getFromApi(with: startUrl) { (swapi: SwapiResult<Movie>?) in
            for movie: Movie in (swapi?.results)! {
                self.syncMovie(with: movie)
            }
            if swapi?.next != nil {
                self.syncMovies(with: (swapi?.next)!)
            } else {
                UserDefaults.standard.set(true, forKey: "MoviesSynchronized")
            }
        }
    }
    
    func syncCharacters(with startUrl: URL) {
        getFromApi(with: startUrl) { (swapi: SwapiResult<Character>?) in
            for character: Character in (swapi?.results)! {
                self.syncCharacter(with: character)
            }
            if swapi?.next != nil {
                self.syncCharacters(with: (swapi?.next)!)
            } else {
                UserDefaults.standard.set(true, forKey: "CharactersSynchronized")
            }
        }
    }
    
    private func syncCharacter(with character: Character) {
        let foundCharacter = try? Character.updateOrCreate(with: character, in: managedObjectContext!)
        if foundCharacter != nil {
            for movieUrl in foundCharacter!.movieUrls {
                getFromApi(with: movieUrl) { (movie: Movie?) in
                    if movie != nil {
                        let foundMovie = try? Movie.updateOrCreate(with: movie!, in: self.managedObjectContext!)
                        if foundMovie != nil {
                            print("found movie not null")
                            foundCharacter!.addToMovies(foundMovie!)
                            foundMovie!.addToCharacters(foundCharacter!)
                            try! self.managedObjectContext?.save()
                        }
                    }
                }
            }
        }
    }
    
    private func syncMovie(with movie: Movie) {
        let foundMovie = try? Movie.updateOrCreate(with: movie, in: managedObjectContext!)
        if foundMovie != nil {
            for characterUrl in foundMovie!.characterUrls {
                getFromApi(with: characterUrl) { (character: Character?) in
                    if character != nil {
                        let foundCharacter = try? Character.updateOrCreate(with: character!, in: self.managedObjectContext!)
                        if foundCharacter != nil {
                            print("found character not null")
                            foundMovie!.addToCharacters(foundCharacter!)
                            foundCharacter!.addToMovies(foundMovie!)
                            try! self.managedObjectContext?.save()
                        }
                    }
                }
            }
        }
    }
    
    private func getFromApi<T: Decodable>(with url: URL, completionHandler: @escaping (T?) -> Void) {
        getSwapi(with: url) { (data, response, error) in
            guard let data = data, let managedObjectContext = self.managedObjectContext, error == nil else {
                print("failed")
                return
            }
            
            //print("data is \(data.)")
            let decoder = JSONDecoder()
            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = managedObjectContext
            }
            
            let decoded = try? decoder.decode(T.self, from: data)
            completionHandler(decoded)
            }.resume()
    }
    
    private func getSwapi(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            print("data is \(data.count)")
            completionHandler(data, response, nil)
        }
    }
}
