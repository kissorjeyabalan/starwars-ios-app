//
//  FavoriteViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 24/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit
import CoreData

class FavoriteViewController: UIViewController {
    private let SegueMovieDetailsViewController = "SegueMovieDetailsViewController"
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var favoriteTableView: UITableView!
    let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    
    var currentFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil
    
    lazy var moviesFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let movieFetchRequest: NSFetchRequest<NSFetchRequestResult> = Movie.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        movieFetchRequest.sortDescriptors = [sortDescriptor]
        movieFetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: movieFetchRequest,
            managedObjectContext: self.viewContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    lazy var charactersFetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let characterFetchRequest: NSFetchRequest<NSFetchRequestResult> = Character.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        characterFetchRequest.sortDescriptors = [sortDescriptor]
        characterFetchRequest.predicate = NSPredicate(format: "favorite == %@", NSNumber(value: true))
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: characterFetchRequest,
            managedObjectContext: self.viewContext!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoriteTableView.delegate = self
        favoriteTableView.dataSource = self
        
        refreshCurrentFetchedResultsControllerAndFetch()
    }
    
    
    @IBAction func changeTable(_ sender: Any) {
        refreshCurrentFetchedResultsControllerAndFetch()
    }
    
    private func showCharacter(at indexPath: IndexPath) {
        if let character = currentFetchedResultsController?.fetchedObjects?[indexPath.row] as? Character {
            let moviesArr = character.movies!.allObjects as! [Movie]
            print(moviesArr)
            let moviesCharacterWasIn = moviesArr.map { (movie) -> String in
                movie.title!
            }.joined(separator: ", ")
            
            print("MOVIES: ", moviesCharacterWasIn)
            
            let alert = UIAlertController(title: "\(character.name!) was in:", message: moviesCharacterWasIn, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Remove from favorites", style: UIAlertAction.Style.destructive, handler: { _ in
                character.toggleFavorite(in: self.viewContext!)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func refreshCurrentFetchedResultsControllerAndFetch() {
        switch segmentController.selectedSegmentIndex {
        case 0:
            currentFetchedResultsController = moviesFetchedResultsController
        case 1:
            currentFetchedResultsController = charactersFetchedResultsController
        default:
            break
        }
        
        fetchCurrentFetchedResultsController()
    }
    
    private func fetchCurrentFetchedResultsController() {
        do {
            try currentFetchedResultsController!.performFetch()
            favoriteTableView.reloadData()
        } catch {
            print(error)
        }
    }
}

extension FavoriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = currentFetchedResultsController?.sections {
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let rows = currentFetchedResultsController?.sections?[section].numberOfObjects {
            return rows
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let section = currentFetchedResultsController?.sections?[section] {
            return section.name
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = favoriteTableView.dequeueReusableCell(withIdentifier: getReuseIdentifier()!, for: indexPath)
        configureCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    private func getReuseIdentifier() -> String? {
        switch segmentController.selectedSegmentIndex {
        case 0:
            return "FavoriteMovieCellIdentifier"
        case 1:
            return "FavoriteCharacterCellIdentifier"
        default:
            return nil
        }
    }
    
    private func configureCell(cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        if let object = currentFetchedResultsController?.fetchedObjects?[indexPath.row] {
            switch segmentController.selectedSegmentIndex {
            case 0:
                cell.textLabel?.text = (object as! Movie).title
            case 1:
                cell.textLabel?.text = (object as! Character).name
                cell.detailTextLabel?.text = ((object as! Character).movies?.sortedArray(using: [NSSortDescriptor(key: "episode", ascending: true)]) as! [Movie])
                    .map({ (movie) -> String in
                        String(movie.episode)
                    }).joined(separator: ", ")
            default:
                break
            }
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch segmentController.selectedSegmentIndex {
        case 0:
            performSegue(withIdentifier: SegueMovieDetailsViewController, sender: self)
        default:
            showCharacter(at: indexPath)
        }
        favoriteTableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueMovieDetailsViewController {
            if let indexPath = favoriteTableView.indexPathForSelectedRow {
                let movieDetailsViewController = segue.destination as! MovieDetailsViewController
                movieDetailsViewController.movie = currentFetchedResultsController?.fetchedObjects?[indexPath.row] as? Movie
            }
        }
    }
}

// https://github.com/BeiningBogen/iOS-Westerdals/blob/master/forelesning08/README.pdf
extension FavoriteViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if (controller != currentFetchedResultsController) {return}
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                favoriteTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath, let cell = favoriteTableView.cellForRow(at: indexPath) {
                configureCell(cell: cell, atIndexPath: indexPath)
            }
        case .move:
        if let indexPath = indexPath, let newIndexPath = newIndexPath {
                favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
                favoriteTableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
           
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        favoriteTableView.endUpdates()
    }
}
