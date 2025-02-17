//
//  Movie.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import Foundation
import CoreData

class Movie: NSManagedObject, Codable {
    // MARK: - CodingKeys
    enum CodingKeys: String, CodingKey {
        case title, director, producer
        case crawl = "opening_crawl"
        case episode = "episode_id"
        case releaseDate = "release_date"
        case characterUrls = "characters"
        case selfUrl = "url"
    }
    
    // MARK: - Additional Class Properties
    var characterUrls: [URL] = []

    
    // MARK: - Encoder & Decoder
    // https://stackoverflow.com/a/46917019
    public func encode(to encoder: Encoder) throws {
        var json = encoder.container(keyedBy: CodingKeys.self)
        try json.encode(title, forKey: .title)
        try json.encode(director, forKey: .director)
        try json.encode(producer, forKey: .producer)
        try json.encode(crawl, forKey: .crawl)
        try json.encode(episode, forKey: .episode)
        try json.encode(releaseDate, forKey: .releaseDate)
        try json.encode(characterUrls, forKey: .characterUrls)
        try json.encode(selfUrl, forKey: .selfUrl)
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
            self.selfUrl = try json.decodeIfPresent(String.self, forKey: .selfUrl)
            self.characterUrls = try json.decodeIfPresent([URL].self, forKey: .characterUrls)!
        }
        
    }
    
    
    // MARK: - ManagedObject Mutators
    
    class func findOrCreate(with matching: Movie, in context: NSManagedObjectContext) throws -> Movie {
        let req: NSFetchRequest<Movie> = Movie.fetchRequest()
        req.predicate = NSPredicate(format: "title = %@", matching.title!)
        
        do {
            let found = try context.fetch(req)
            if found.count > 0 {
                assert(found.count == 1, "Movie.findOrCreate -- database failure")
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
        movie.characterUrls = matching.characterUrls
        movie.selfUrl = matching.selfUrl
        
        return movie
        
    }
    
    class func updateOrCreate(with matching: Movie, in context: NSManagedObjectContext) throws -> Movie {
        let req: NSFetchRequest<Movie> = Movie.fetchRequest()
        req.predicate = NSPredicate(format: "title = %@", matching.title!)
        var movie: Movie? = nil;
        
        do {
            let found = try context.fetch(req)
            
            if found.count > 0 {
                movie = found[0]
            } else {
                movie = Movie(context: context)
            }
        } catch {
            throw error
        }
        
        
        movie!.title = matching.title
        movie!.episode = matching.episode
        movie!.crawl = matching.crawl
        movie!.director = matching.director
        movie!.producer = matching.producer
        movie!.releaseDate = matching.releaseDate
        movie!.characterUrls = matching.characterUrls
        movie!.selfUrl = matching.selfUrl
        movie!.favorite = matching.favorite
        
        return movie!
    }
    
    
    // MARK: - Convenience Functions
    
    func toggleFavorite(in context: NSManagedObjectContext) {
        self.favorite = !favorite
    }
    
    class func getAll(in context: NSManagedObjectContext) -> [Movie] {
        let req: NSFetchRequest<Movie> = Movie.fetchRequest()
        req.sortDescriptors = [NSSortDescriptor(key: "episode", ascending: true)]
        do {
            return try context.fetch(req)
        } catch {
            return []
        }
    }
}
	
