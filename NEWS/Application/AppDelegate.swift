//
//  AppDelegate.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 14/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import CoreData
import Toast_Swift
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    let manager                                 = NetworkReachabilityManager(host: "www.apple.com")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.makeKeyAndVisible()
        
        let headlinesVC                         = SwipeNavigationController(rootViewController: Headlines_VC())
        let headlinesTabBarItem                 = UITabBarItem(title: "Headlines", image: UIImage(named: "headline_deselect"), selectedImage: UIImage(named: "headline_select"))
        headlinesVC.tabBarItem                  = headlinesTabBarItem
        
        let customNewsVC                        = SwipeNavigationController(rootViewController: UserPreferred_VC())
        let newsTabBarItem                      = UITabBarItem(title: "News", image: UIImage(named: "news_deselect"), selectedImage: UIImage(named: "news_select"))
        customNewsVC.tabBarItem                 = newsTabBarItem
        
        let profileVC                           = SwipeNavigationController(rootViewController: Profile_VC())
        let profileTabBarItem                   = UITabBarItem(title: "Profile", image: UIImage(named: "profile_deselect"), selectedImage: UIImage(named: "profile_select"))
        profileVC.tabBarItem                    = profileTabBarItem
        
        let tabBarController                    = UITabBarController()
        tabBarController.viewControllers        = [headlinesVC, customNewsVC, profileVC]
        
        window?.rootViewController              = tabBarController
        
        URLCache.shared                         = AppConfig.si.urlCache
        
        var style                               = ToastStyle()
        style.messageColor                      = .white
        style.backgroundColor                   = UIColor.black.withAlphaComponent(0.7)
        ToastManager.shared.style               = style
        ToastManager.shared.position            = .center
        ToastManager.shared.duration            = 4.0
        ToastManager.shared.isTapToDismissEnabled = true
        
        manager?.listener = { status in
            if status == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
                self.showAlert(title: "Can't connect at the moment", message: "Check your network connection", alertAction: nil)
            } else {
                if var topController = UIApplication.shared.keyWindow?.rootViewController {
                    while let presentedViewController = topController.presentedViewController {
                        topController = presentedViewController
                    }
                    topController.dismiss(animated: true, completion: nil)
                }
            }
        }
        manager?.startListening()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
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
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "NEWS")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    // MARK: - Show Alert
    func showAlert(title: String! = nil, message: String! = nil, alertAction: UIAlertAction! = nil) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if alertAction != nil {
            ac.addAction(alertAction)
        } else {
            ac.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        }
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            topController.present(ac, animated: true, completion: nil)
        }
    }

}

