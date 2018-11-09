//
//  SwapiResult.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation

struct SwapiResult<T: Codable>: Codable {
    let count: Int
    let next, previous: JSONNull?
    let results: [T]
}
