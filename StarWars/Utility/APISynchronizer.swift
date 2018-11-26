//
//  APISynchronizer.swift
//  StarWars
//
//  Created by XYZ on 10/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import Foundation
import CoreData

/**
 This class is used to synchronize core data with information from the API.
 It loops through all characters and movies, and saves them to core data.
 
 Unfortunately, it's kind of slow - this is because of the API being -very- slow.
 This is a known issue with SWAPI.
 **/
class APISynchronizer: NSObject {
    // MARK: - Class Properties
    static let shared = APISynchronizer()
    public var managedObjectContext: NSManagedObjectContext?
    
    
    // MARK: - Initializers
    override init() {
        super.init()
        UserDefaults.standard.addObserver(self, forKeyPath: "CharactersSynchronized", options: NSKeyValueObservingOptions.new, context: nil)
        UserDefaults.standard.addObserver(self, forKeyPath: "MoviesSynchronized", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    
    // MARK: - Synchronizers
    func syncAll() {
        UserDefaults.standard.set(false, forKey: "CharactersSynchronized")
        UserDefaults.standard.set(false, forKey: "MoviesSynchronized")
        UserDefaults.standard.set(false, forKey: "ApiSynchronized")
        syncMovies(with: URL(string: "https://swapi.co/api/films/")!)
        syncCharacters(with: URL(string: "https://swapi.co/api/people/")!)
    }
    
    func syncRelationships() {
        let allCharacters = Character.getAll(in: managedObjectContext!)
        for character in allCharacters {
            for url in character.movieUrls {
                let fetchReq: NSFetchRequest<Movie> = Movie.fetchRequest()
                fetchReq.predicate = NSPredicate(format: "selfUrl = %@", url.absoluteString)
                var results = try? managedObjectContext!.fetch(fetchReq)
                if results != nil && results!.count > 0 {
                    if let movie = results?[0] {
                        character.addToMovies(movie)
                        movie.addToCharacters(character)
                    }
                }
            }
        }
        try? managedObjectContext!.save()
    }
    
    func syncMovies(with startUrl: URL) {
        getFromApi(with: startUrl) { (swapi: SwapiResult<Movie>?) in
            for movie: Movie in (swapi?.results)! {
                _ = try? Movie.updateOrCreate(with: movie, in: self.managedObjectContext!)
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
                _ = try? Character.updateOrCreate(with: character, in: self.managedObjectContext!)
            }
            if swapi?.next != nil {
                self.syncCharacters(with: (swapi?.next)!)
            } else {
                UserDefaults.standard.set(true, forKey: "CharactersSynchronized")
            }
        }
    }
    
    
    // MARK: - NSUserDefaults Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let objectIsSynchronized = change?[.newKey] as? Bool {
            let other = keyPath == "MoviesSynchronized" ? "CharactersSynchronized" : "MoviesSynchronized"
            let otherIsSynchronized = UserDefaults.standard.bool(forKey: other)
            
            if (otherIsSynchronized && objectIsSynchronized) {
                syncRelationships()
                UserDefaults.standard.set(true, forKey: "ApiSynchronized")
            } else {
                UserDefaults.standard.set(false, forKey: "ApiSynchronized")
            }
        }
    }
    
    
    // MARK: - API Communication
    private func getFromApi<T: Decodable>(with url: URL, completionHandler: @escaping (T?) -> Void) {
        getSwapi(with: url) { (data, response, error) in
            guard let data = data, let managedObjectContext = self.managedObjectContext, error == nil else {
                return
            }
            
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
            completionHandler(data, response, nil)
        }
    }
}
