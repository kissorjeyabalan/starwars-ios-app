//
//  URLSession+Swapi.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation

extension URLSession {
    func getSwapi<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            
            completionHandler(try? JSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func getAllMovies(completionHandler: @escaping(SwapiResult<Movie>?, URLResponse?, Error?) -> Void) {
        self.getSwapi(with: URL(string: "https://swapi.co/api/films/")!, completionHandler: completionHandler).resume()
    }
    
    func getMovie(with url: URL, completionHandler: @escaping(Movie?, URLResponse?, Error?) -> Void) {
        self.getSwapi(with: url, completionHandler: completionHandler).resume()
    }
    
    func getMovie(with id: Int, completionHandler: @escaping(Movie?, URLResponse?, Error?) -> Void) {
        self.getMovie(with: URL(string: "https://swapi.co/api/films/\(id)")!, completionHandler: completionHandler)
    }
    
    func getAllCharacters(completionHandler: @escaping(SwapiResult<Character>?, URLResponse?, Error?) -> Void) {
        self.getSwapi(with: URL(string: "https://swapi.co/api/people/")!, completionHandler: completionHandler).resume()
    }
}
