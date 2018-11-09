//
//  ViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    let CellIdentifier = "MovieCellIdentifier"
    
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [Movie] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        movieTableView.delegate = self
        movieTableView.dataSource = self;
        
        fetchAllMovies()
     }
    
    func fetchAllMovies() {
        URLSession.shared.getAllMovies {
            movies, url, error in
            if let movies = movies {
                print("movies", movies)
                DispatchQueue.main.async {
                    self.movies = movies.results
                    self.movieTableView.reloadData()
                }
            }
            if let error = error {
                print("error", error)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath)
        
        cell.textLabel?.text = movies[indexPath.row].title
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}

// MARK: - UITableViewDelegate
extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //do stuff
    }
}
