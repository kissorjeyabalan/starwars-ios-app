//
//  Date+Localization.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 10/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import Foundation
extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY-MM-dd"
        return dateFormatter.string(from: self)
    }
}
