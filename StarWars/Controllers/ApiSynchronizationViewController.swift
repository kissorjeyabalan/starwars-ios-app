//
//  ApiSynchronizationViewController.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
//

import UIKit

class ApiSynchronizationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var syncTextLabel: UILabel!
    weak var timer: Timer?
    let texts = ["Synchronizing...", "This API is very slow, isn't it...", "Hang on, almost finished!", "Shouldn't take too long now..."]
    var currentTextIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        UserDefaults.standard.addObserver(self, forKeyPath: "ApiSynchronized", options: [.new], context: nil)
        
        scheduleLabelRotation()
    }
    
    func scheduleLabelRotation() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { timer in
            self.syncTextLabel.text = self.texts[self.currentTextIndex]
            self.currentTextIndex = (self.currentTextIndex + 1) % self.texts.count
        })
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let apiIsSynchronized = change?[.newKey] as? Bool {
            if (apiIsSynchronized) {
                
                // https://stackoverflow.com/questions/40100696/removing-all-previously-loaded-viewcontrollers-from-memory-ios-swift?rq=1
                DispatchQueue.main.async {
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let rootViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainApplicationEntryStoryboard")
                    
                    print("dismissing")
                        appDelegate.window?.rootViewController = rootViewController
                        appDelegate.window?.makeKeyAndVisible()
                    //self.present(rootViewController!, animated: true, completion: nil)
                }
                
                
            }
        }
    }
}
