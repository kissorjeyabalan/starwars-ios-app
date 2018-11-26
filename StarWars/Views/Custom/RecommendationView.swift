//
//  RecommendationView.swift
//  StarWars
//
//  Created by XYZ on 26/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import UIKit


// https://medium.com/swift2go/swift-custom-uiview-with-xib-file-211bb8bbd6eb
class RecommendationView: UIView {
    // MARK: - Class Properties
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recommendedTitleLabel: UILabel!
    @IBOutlet weak var recommendedMovieLabel: UILabel!
    let possibleTitles = ["Darth Vidius Filmanbefalinger", "Jar Jar's Topp 1-liste", "Jabbas favorittfilm", "Yoda du måda se denne", "Prinsesse Leia'n på DVD"]
    
    
    // MARK: - Intializers
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("RecommendationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }

}
