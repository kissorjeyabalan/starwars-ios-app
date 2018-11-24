//
//  AppDelegate.swift
//  StarWars
//
//  Created by Kissor Jeyabalan on 09/11/2018.
//  Copyright © 2018 Kissor Jeyabalan. All rights reserved.
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
            APISynchronizer.shared.syncAll()
            UserDefaults.standard.set(now, forKey: "LastApiUpdate")
            print("synchronized database")
        } else {
            rootViewController = storyboard.instantiateViewController(withIdentifier: "MainApplicationEntryStoryboard")
            print("no need to synchronize database")
        }
        
        window?.rootViewController = rootViewController
        
        return true
    }
    
    
    
    

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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

