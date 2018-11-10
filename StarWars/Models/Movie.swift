//
//  Movie.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case title, director, producer
        case crawl = "opening_crawl"
        case episode = "episode_id"
        case releaseDate = "release_date"
        case characterUrls = "characters"
    }
    
    var characterUrls: [URL] = []
    
    public func encode(to encoder: Encoder) throws {
        var json = encoder.container(keyedBy: CodingKeys.self)
        try json.encode(title, forKey: .title)
        try json.encode(director, forKey: .director)
        try json.encode(producer, forKey: .producer)
        try json.encode(crawl, forKey: .crawl)
        try json.encode(episode, forKey: .episode)
        try json.encode(releaseDate, forKey: .releaseDate)
        try json.encode(characterUrls, forKey: .characterUrls)
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyContext = CodingUserInfoKey.context, let managedObjectContext = decoder.userInfo[codingUserInfoKeyContext] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Movie", in: managedObjectContext) else {
            fatalError("Movie.init(from decoder) -- Failed to decode")
        }
        self.init(entity: entity, insertInto: nil)
        
        if let json = try? decoder.container(keyedBy: CodingKeys.self) {
            self.title = try json.decodeIfPresent(String.self, forKey: .title)
            self.director = try json.decodeIfPresent(String.self, forKey: .director)
            self.producer = try json.decodeIfPresent(String.self, forKey: .producer)
            self.crawl = try json.decodeIfPresent(String.self, forKey: .crawl)
            self.episode = try json.decodeIfPresent(Int32.self, forKey: .episode) ?? -1
            self.releaseDate = try json.decodeIfPresent(String.self, forKey: .releaseDate)
            self.characterUrls = try json.decodeIfPresent([URL].self, forKey: .characterUrls)!

        }
        
    }
    
    class func findOrCreate(with matching: Movie, in context: NSManagedObjectContext) throws -> Movie {
        let req: NSFetchRequest<Movie> = Movie.fetchRequest()
        req.predicate = NSPredicate(format: "episode = %@", matching.episode)
        
        do {
            let found = try context.fetch(req)
            if found.count > 0 {
                assert(found.count > 1, "Movie.findOrCreate -- database failure")
                return found[0]
            }
        } catch {
            throw error
        }
        
        let movie = Movie(context: context)
        movie.title = matching.title
        movie.episode = matching.episode
        movie.crawl = matching.crawl
        movie.director = matching.director
        movie.producer = matching.producer
        movie.releaseDate = matching.releaseDate
        movie.characters = matching.characters
        return movie
        
    }
}
