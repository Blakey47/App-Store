//
//  Models.swift
//  AppStore
//
//  Created by Darragh on 11/6/17.
//  Copyright © 2017 Darragh. All rights reserved.
//

import UIKit

class AppCategory: NSObject {
    
    var name: String?
    var apps: [App]?
    var type: String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            
            apps = [App]()
            for dict in value as! [[String: AnyObject]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
            
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping ([AppCategory]) -> ()) {
        
        let urlString = URL(string: "http://api.letsbuildthatapp.com/appstore/featured")
        let request = NSMutableURLRequest(url: urlString!)
        
        URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if error != nil {
                print(error as Any)
                return
            }
            
            do {
                
                let json = try(JSONSerialization.jsonObject(with: data!, options: .mutableContainers)) as! [String: AnyObject]
                
                var appCategories = [AppCategory]()
                
                for dict in json["categories"] as! [[String: AnyObject]] {
                    let appCategory = AppCategory()
                    appCategory.setValuesForKeys(dict)
                    appCategories.append(appCategory)
                }
                
                DispatchQueue.main.async {
                    completionHandler(appCategories)
                }
                
                print(appCategories)
                
            } catch let err {
                print(err)
            }
            
        }.resume()
        
    }
    
    static func sampleAppCategories() -> [AppCategory] {
        
        let bestNewAppsCategory = AppCategory()
        bestNewAppsCategory.name = "Best New Apps"
        
        var apps = [App]()
        
        // Logic
        let frozenApp = App()
        frozenApp.name = "Disney Build It: Frozen"
        frozenApp.imageName = "frozen"
        frozenApp.category = "Entertainment"
        frozenApp.price = NSNumber(value: 3.99)
        apps.append(frozenApp)
        
        bestNewAppsCategory.apps = apps
        
        
        let bestNewGamesCategory = AppCategory()
        bestNewGamesCategory.name = "Best New Games"
        
        var bestNewGamesApps = [App]()
        
        let telepaintApp = App()
        telepaintApp.name = "Telepaint"
        telepaintApp.category = "Games"
        telepaintApp.imageName = "telepaint"
        telepaintApp.price = NSNumber(value: 2.99)
        
        bestNewGamesApps.append(telepaintApp)
        
        bestNewGamesCategory.apps = bestNewGamesApps
        
        return [bestNewAppsCategory, bestNewGamesCategory]
    }
    
}

class App: NSObject {
    
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
    
}
