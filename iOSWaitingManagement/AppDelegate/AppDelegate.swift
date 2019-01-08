//
//  AppDelegate.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SQLite3

var APPDELEGATE : AppDelegate{
    get{
        return UIApplication.shared.delegate as! AppDelegate
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var db: OpaquePointer?
    var strSelectedFloorID : Int!
    
    var strSelectedLocationID : Int!
    var strSelectedCounterID : Int!
    var strSelectedTabletID : Int!
    
    var dictSelectedTab : [String:AnyObject] = [:]
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        self.createDatabase()
        
        // Open IPAD and IPHONE screen   
        let storyboard = ResolutePOS.getStoryBoard()
        let viewControllerVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationVC = UINavigationController(rootViewController: viewControllerVC)
        self.window?.rootViewController = navigationVC
        
        return true
    }
    
    //MARK:- CREATE DATABASE
    func createDatabase() {
        
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("iOSPOS.sqlite")
        print(fileURL)
        
        sqlite3_open(fileURL.path, &db)
        
        //CREATE ORDER CART DETAIL TABLE
        sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS CustomerMaster (ID INTEGER PRIMARY KEY AUTOINCREMENT, Name TEXT, ContactNo TEXT,NoOfPax TEXT,IsAssign TEXT)", nil, nil, nil)
    }
    
    func openLoginPage()  {
        let storyBoard: UIStoryboard!
        storyBoard = UIStoryboard(name: "iPad", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        let navigationVC = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navigationVC
    }
    
    func openHomePage()  {
        let storyBoard: UIStoryboard!
        storyBoard = UIStoryboard(name: "iPad", bundle: nil)
        let loginVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let navigationVC = UINavigationController(rootViewController: loginVC)
        self.window?.rootViewController = navigationVC
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
    }
}

