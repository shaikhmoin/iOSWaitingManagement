//
//  RSRechability.swift
//  iOSWaitingManagement
//
//  Created by Akash on 12/27/18.
//  Copyright © 2018 Moin. All rights reserved.
//

import Foundation
import UIKit
import ReachabilitySwift

class RSReachabilityManager: NSObject {
    
    var reachability:Reachability!
    
    static let sharedManager : RSReachabilityManager = {
        let instance = RSReachabilityManager()
        return instance
    }()
    
    func isInternetAvailableForAllNetworks() -> Bool
    {
        if(self.reachability == nil){
            self.doSetupReachability()
            return self.reachability!.isReachable || reachability!.isReachableViaWiFi || self.reachability!.isReachableViaWWAN
        }
        else{
            return reachability!.isReachable || reachability!.isReachableViaWiFi || reachability!.isReachableViaWWAN
        }
    }
    
    func doSetupReachability() {
        
        do{
            let reachability = try Reachability()!
            
            self.reachability = reachability
        }
        catch ReachabilityError.FailedToCreateWithAddress(_){
            return
        }
        catch{}
        
        reachability.whenReachable = { reachability in
        }
        reachability.whenUnreachable = { reachability in
        }
        do {
            try reachability.startNotifier()
        }
        catch {
        }
    }
    
    deinit{
        reachability.stopNotifier()
        reachability = nil
    }
    
    //MARK: CHECK INTERNET CONNECTION
    func IS_INTERNET_AVAILABLE() -> Bool {
        return RSReachabilityManager.sharedManager.isInternetAvailableForAllNetworks()
    }
}
