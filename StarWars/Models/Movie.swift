//
//  Movie.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation

struct Movie: Codable {
    let title: String
    let episodeID: Int
    let description: String
    let director: String
    let producer: String
    let releaseDate: String
    let characters: [String]
    let selfUrl: String
    
    enum CodingKeys: String, CodingKey {
        case title
        case episodeID = "episode_id"
        case description = "opening_crawl"
        case director
        case producer
        case releaseDate = "release_date"
        case characters
        case selfUrl = "url"
    }
}
