//
//  ViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {
    private let CellIdentifier = "MovieCellIdentifier"
    private let SegueMovieDetailsViewController = "SegueMovieDetailsViewController"
    
    @IBOutlet weak var movieTableView: UITableView!
    let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var movies: [Movie] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "StarWars"
        movieTableView.delegate = self
        movieTableView.dataSource = self;
        
        movies = Movie.getAll(in: viewContext!)
        movieTableView.reloadData()
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
        performSegue(withIdentifier: SegueMovieDetailsViewController, sender: self)
        movieTableView.deselectRow(at: indexPath, animated: true)
    }
}
