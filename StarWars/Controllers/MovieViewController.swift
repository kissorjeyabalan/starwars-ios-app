//
//  ViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    fileprivate let CellIdentifier = "MovieCellIdentifier"
    fileprivate let SegueMovieDetailsViewController = "MovieDetailsViewController"
    
    @IBOutlet weak var movieTableView: UITableView!
    var movies: [Movie] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "StarWars"
        movieTableView.delegate = self
        movieTableView.dataSource = self;
        
        fetchAllMovies()
     }
    
    func fetchAllMovies() {
        /*URLSession.shared.getAllMovies {
            movies, _, _ in
            if let movies = movies {
                DispatchQueue.main.async {
                    self.movies = movies.results
                    self.movies.sort(by: { (m1, m2) -> Bool in
                        return m1.episodeID < m2.episodeID
                    })
                    self.movieTableView.reloadData()
                }
            }
        }*/
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueMovieDetailsViewController {
            if let indexPath = movieTableView.indexPathForSelectedRow {
                let movieDetailsViewController = segue.destination as! MovieDetailsViewController
                movieDetailsViewController.movie = movies[indexPath.row]
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MovieDetailsViewController", sender: self)
        movieTableView.deselectRow(at: indexPath, animated: true)
    }
}
