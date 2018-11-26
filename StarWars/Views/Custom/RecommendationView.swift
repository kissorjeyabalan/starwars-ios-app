//
//  RecommendedView.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 26/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class RecommendedView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recommendedMovieLabel: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        Bundle.main.loadNibNamed("RecommendedView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        
        
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
