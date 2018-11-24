//
//  Character.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation
import CoreData

class Character: NSManagedObject, Codable {
    enum CodingKeys: String, CodingKey {
        case name, height, mass, gender
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case movieUrls = "films"
    }
    
    var movieUrls: [URL] = []
    
    
    func toggleFavorite(in context: NSManagedObjectContext) {
        self.favorite = !favorite
        try? context.save()
    }
    
    
    
    public func encode(to encoder: Encoder) throws {
        var json = encoder.container(keyedBy: CodingKeys.self)
        try json.encode(name, forKey: .name)
        try json.encode(height, forKey: .height)
        try json.encode(mass, forKey: .mass)
        try json.encode(gender, forKey: .gender)
        try json.encode(hairColor, forKey: .hairColor)
        try json.encode(skinColor, forKey: .skinColor)
        try json.encode(eyeColor, forKey: .eyeColor)
        try json.encode(birthYear, forKey: .birthYear)
        try json.encode(movieUrls, forKey: .movieUrls)
    }
    
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyContext = CodingUserInfoKey.context, let managedObjectContext = decoder.userInfo[codingUserInfoKeyContext] as? NSManagedObjectContext, let entity = NSEntityDescription.entity(forEntityName: "Character", in: managedObjectContext) else {
            fatalError("Character.init(from decoder) -- Failed to decode")
        }
        
        self.init(entity: entity, insertInto: nil)
        
        if let json = try? decoder.container(keyedBy: CodingKeys.self) {
            self.name = try json.decodeIfPresent(String.self, forKey: .name)
            self.height = try json.decodeIfPresent(String.self, forKey: .height)
            self.mass = try json.decodeIfPresent(String.self, forKey: .mass)
            self.hairColor = try json.decodeIfPresent(String.self, forKey: .hairColor)
            self.skinColor = try json.decodeIfPresent(String.self, forKey: .skinColor)
            self.eyeColor = try json.decodeIfPresent(String.self, forKey: .eyeColor)
            self.birthYear = try json.decodeIfPresent(String.self, forKey: .birthYear)
            self.gender = try json.decodeIfPresent(String.self, forKey: .gender)
            self.movieUrls = try json.decodeIfPresent([URL].self, forKey: .movieUrls)!
        }
    }
    
    class func findOrCreate(with matching: Character, in context: NSManagedObjectContext) throws -> Character {
        let req: NSFetchRequest<Character> = Character.fetchRequest()
        req.predicate = NSPredicate(format: "name = %@", matching.name!)
        
        do {
            let found = try context.fetch(req)
            if found.count > 0 {
                assert(found.count == 1, "Character.findOrCreate -- database failure")
                print("found \(found.count) for \(matching.name)")
                return found[0]
            }
        } catch {
            throw error
        }
        
        let character = Character(context: context)
        character.name = matching.name
        character.height = matching.height
        character.mass = matching.mass
        character.hairColor = matching.hairColor
        character.skinColor = matching.skinColor
        character.eyeColor = matching.eyeColor
        character.birthYear = matching.birthYear
        character.gender = matching.gender
        character.movieUrls = matching.movieUrls
        
        return character
    }
    
    class func updateOrCreate(with matching: Character, in context: NSManagedObjectContext) throws -> Character {
        let req: NSFetchRequest<Character> = Character.fetchRequest()
        req.predicate = NSPredicate(format: "name = %@", matching.name!)
        var character: Character? = nil;
        
        do {
            let found = try context.fetch(req)
            if found.count > 0 {
                character = found[0]
            } else {
                character = Character(context: context)
            }
        } catch {
            throw error
        }
            
        character!.name = matching.name
        character!.height = matching.height
        character!.mass = matching.mass
        character!.hairColor = matching.hairColor
        character!.skinColor = matching.skinColor
        character!.eyeColor = matching.eyeColor
        character!.birthYear = matching.birthYear
        character!.gender = matching.gender
        character!.movieUrls = matching.movieUrls
        character!.favorite = matching.favorite
        
        return character!
    }
    
    class func getAll(in context: NSManagedObjectContext) -> [Character] {
        let req: NSFetchRequest<Character> = Character.fetchRequest()
        do {
            return try context.fetch(req)
        } catch {
            return []
        }
    }
}
