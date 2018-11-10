//
//  APISynchronizer.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 10/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation
import CoreData

class APISynchronizer {
    static let shared = APISynchronizer()
    public var managedObjectContext: NSManagedObjectContext?
    
    func syncAll() {
        getAllMovies { (movie) in
            print(movie?.count)
        }
        
        getAllCharacters {
            (character) in
                print(character?.count)
        }
    }
    
    private func getFromApi<T: Decodable>(with url: URL, completionHandler: @escaping (T?) -> Void) {
        getSwapi(with: url) { (data, response, error) in
            guard let data = data, let managedObjectContext = self.managedObjectContext, error == nil else {
                print("failed")
                return
            }
            
            let decoder = JSONDecoder()
            if let context = CodingUserInfoKey.context {
                decoder.userInfo[context] = managedObjectContext
            }
            
            print("data is", data)
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
    
    func getAllMovies(completionHandler: @escaping(SwapiResult<Movie>?) -> Void) {
        self.getFromApi(with: URL(string: "https://swapi.co/api/films/")!, completionHandler: completionHandler)
    }
    
    func getAllCharacters(completionHandler: @escaping(SwapiResult<Character>?) -> Void) {
        self.getFromApi(with: URL(string: "https://swapi.co/api/people/")!, completionHandler: completionHandler)
    }
}
