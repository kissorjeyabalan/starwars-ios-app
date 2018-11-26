//
//  SwapiResult.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import Foundation

struct SwapiResult<T: Codable>: Codable {
    let count: Int
    let results: [T]
    let next: URL?
    let previous: URL?
}
