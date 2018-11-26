//
//  MovieDetailsViewController.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    // MARK: - Class Properties
    private let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var movie: Movie!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var producerLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie.title
        episodeLabel.text = "Episode \(movie.episode)"
        directorLabel.text = movie.director
        producerLabel.text = movie.producer
        releaseDateLabel.text = movie.releaseDate
        descriptionLabel.text = movie.crawl
        
        updateFavoriteButtonText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateFavoriteButtonText()
    }
    
    // MARK: - Favorite Button Handlers
    @IBAction func toggleFavorite(_ sender: Any) {
        movie.toggleFavorite(in: viewContext!)
        updateFavoriteButtonText()
        
    }
    
    private func updateFavoriteButtonText() {
        if (movie.favorite) {
            favoriteButton.setTitle("Fjern som favoritt", for: UIControl.State.normal)
        } else {
            favoriteButton.setTitle("Legg til favoritt", for: UIControl.State.normal)
        }
    }
}
