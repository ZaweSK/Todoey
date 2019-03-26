//
//  AppDelegate.swift
//  todoey
//
//  Created by Peter on 11/03/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
      print(Realm.Configuration.defaultConfiguration.fileURL)
        
        
        do{
            let _ = try Realm()
          
        }catch {
            print("Error trying to initialize realm instance upon app startup")
        }
        
        return true
    }

}

