//
//  AppDelegate.swift
//  AceList
//
//  Created by Ace Goulet on 8/27/18.
//  Copyright © 2018 AceGoulet, LLC. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 11,
            migrationBlock: { migration, oldSchemaVersion in
                print("inside migration block")
                if (oldSchemaVersion < 7) {
                    migration.enumerateObjects(ofType: Category.className()) { (old, new) in
                        new!["dateCreated"] = Date()
                    }
                    migration.enumerateObjects(ofType: Item.className()) { (old, new) in
                        new!["dateCreated"] = Date()
                    }
                }
                if (oldSchemaVersion < 9) {
                    migration.enumerateObjects(ofType: Category.className()) { (old, new) in
                        new!["dateModified"] = Date()
                    }
                    migration.enumerateObjects(ofType: Item.className()) { (old, new) in
                        new!["dateModified"] = Date()
                    }
                }
                if (oldSchemaVersion < 10) {
                    migration.enumerateObjects(ofType: Category.className()) { (old, new) in
                        new!["backgroundColor"] = "FFFFFF"
                    }
                    migration.enumerateObjects(ofType: Item.className()) { (old, new) in
                        new!["backgroundColor"] = "FFFFFF"
                    }
                }
                if (oldSchemaVersion < 11) {
                }
        })
        _ = try! Realm()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }


}

