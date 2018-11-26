//
//  MovieViewController.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    // MARK: - Identifiers
    private let CellIdentifier = "MovieCellIdentifier"
    private let SegueMovieDetailsViewController = "SegueMovieDetailsViewController"
    
    // MARK: - Class Properties
    @IBOutlet weak var movieTableView: UITableView!
    private let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var movies: [Movie] = [];
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "StarWars"
        movieTableView.delegate = self
        movieTableView.dataSource = self;
        
        movies = Movie.getAll(in: viewContext!)
        movieTableView.reloadData()
     }
    
    // MARK: - Segues
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
        performSegue(withIdentifier: SegueMovieDetailsViewController, sender: self)
        movieTableView.deselectRow(at: indexPath, animated: true)
    }
}
