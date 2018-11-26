//
//  AppDelegate.swift
//  StarWars
//
//  Created by XYZ on 09/11/2018.
//  Copyright © 2018 XYZ. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var rootViewController: UIViewController? = nil
        
        APISynchronizer.shared.managedObjectContext =
            (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.newBackgroundContext()
        
        // https://stackoverflow.com/questions/24723431/swift-days-between-two-nsdates
        
        let now = Date()
        let lastUpdated = UserDefaults.standard.object(forKey: "LastApiUpdate") as? Date ?? now
        let daysBetween = Calendar.current.dateComponents([.day], from: lastUpdated, to: Date()).day!
        
        if daysBetween > 6 || lastUpdated == now {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "ApiSynchronizationViewControllerStoryboard")
            print("Synchronizing database")
            APISynchronizer.shared.syncAll()
            UserDefaults.standard.set(now, forKey: "LastApiUpdate")
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "MainApplicationEntryStoryboard")
            print("Synchronization not required")
        }
        
        window?.rootViewController = rootViewController
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWars")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

