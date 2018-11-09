//
//  MovieDetailsViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    var movie: Movie!
    
    
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        episodeLabel.text = "Episode \(movie.episodeID)"
        directorLabel.text = movie.director
        producerLabel.text = movie.producer
        releaseDateLabel.text = movie.releaseDate
        descriptionLabel.text = movie.description
    }
}
