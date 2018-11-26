//
//  ApiSynchronizationViewController.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import UIKit

class ApiSynchronizationViewController: UIViewController {
    // MARK: - Class Properties
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var syncTextLabel: UILabel!
    weak var timer: Timer?
    let texts = [
        "The Jedi forbid Jedi having families, in case of of things like grief leading them to the dark side",
        "Ewok is never mentioned in the original trilogy.",
        "The Rebel Base on Yavin was a Sith temple, not a Jedi temple.",
        "One of the asteroids in the asteroid chase in Empire Strikes Back is a potato.",
        "Luke's original last name was Starkiller.",
        "Help me, Obi-Wan Kenobi. You're my only hope."
    ]
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        UserDefaults.standard.addObserver(self, forKeyPath: "ApiSynchronized", options: [.new], context: nil)
        
        scheduleLabelRotation()
    }
    
    // MARK: - Functions
    func scheduleLabelRotation() {
        syncTextLabel.text = self.texts.randomElement()
        timer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: true, block: { timer in
            self.syncTextLabel.text = self.texts.randomElement()
        })
    }
    
    // MARK: - Synchronization Observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let apiIsSynchronized = change?[.newKey] as? Bool {
            if (apiIsSynchronized) {
                
                // https://stackoverflow.com/questions/40100696/removing-all-previously-loaded-viewcontrollers-from-memory-ios-swift?rq=1
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainApplicationEntryStoryboard")
    
                    appDelegate.window?.rootViewController = rootViewController
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
        }
    }
}
