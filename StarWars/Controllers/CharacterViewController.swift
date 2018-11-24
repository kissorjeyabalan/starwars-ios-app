//
//  CharacterViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class CharacterViewController: UIViewController {
    
    fileprivate let CellIdentifier = "CharacterCellIdentifier"
    let viewContext = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var characters: [Character] = []
    
    @IBOutlet weak var characterCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        characterCollectionView.delegate = self
        characterCollectionView.dataSource = self
        
        characters = Character.getAll(in: viewContext!)
        characterCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        characterCollectionView.reloadData()
    }
}

extension CharacterViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = characterCollectionView.bounds.width/2.0
        let height = width
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension CharacterViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = characterCollectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifier, for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]
        cell.characterName.text = character.name
        
        if (character.favorite) {
            cell.characterImage.backgroundColor = UIColor.orange
        } else {
            cell.characterImage.backgroundColor = UIColor.black
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toggleFavorite(sender:)))
        tap.numberOfTapsRequired = 1
        cell.characterImage.isUserInteractionEnabled = true
        cell.characterImage.addGestureRecognizer(tap)
        return cell
    }
    
    @objc func toggleFavorite(sender: UITapGestureRecognizer) {
        print("TOGGLED FAVORITE")
        let tapPoint = sender.location(in: characterCollectionView)
        let indexPath = characterCollectionView.indexPathForItem(at: tapPoint)
        if let index = indexPath {
            let character = characters[index.row]
            character.toggleFavorite(in: viewContext!)
            characterCollectionView.reloadItems(at: [index])
        }
    }
    
}
