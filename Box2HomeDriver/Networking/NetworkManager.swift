//
//  NetworkManager.swift
//  Box2HomeDriver
//
//  Created by MacHD on 3/7/19.
//  Copyright © 2019 MacHD. All rights reserved.
//

import Foundation


class NetworkManager: NSObject {
    
    var reachability: Reachability!
    
    // Create a singleton instance
    static let sharedInstance: NetworkManager = { return NetworkManager() }()
    
    
    override init() {
        super.init()
        
        // Initialise reachability
        reachability = Reachability()
        
        // Register an observer for the network status
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(networkStatusChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
        do {
            // Start the network status notifier
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    @objc func networkStatusChanged(_ notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            DispatchQueue.main.async {
                print("Reachable via WiFi")
                NotificationCenter.default.post(name: NSNotification.Name("reachable"), object: nil)
            }
        case .cellular:
            DispatchQueue.main.async {
                print("Reachable via Cellular")
                NotificationCenter.default.post(name: NSNotification.Name("reachable"), object: nil)
            }
        case .none:
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("unreachable"), object: nil)
                print("Network not reachable")
            }
        }
        
      
    }
    
    
    static func stopNotifier() -> Void {
        do {
            // Stop the network status notifier
            try (NetworkManager.sharedInstance.reachability).startNotifier()
        } catch {
            print("Error stopping notifier")
        }
    }
    
    // Network is reachable
    static func isReachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection != .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is unreachable
    static func isUnreachable(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .none {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WWAN/Cellular
    static func isReachableViaWWAN(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .cellular {
            completed(NetworkManager.sharedInstance)
        }
    }
    
    // Network is reachable via WiFi
    static func isReachableViaWiFi(completed: @escaping (NetworkManager) -> Void) {
        if (NetworkManager.sharedInstance.reachability).connection == .wifi {
            completed(NetworkManager.sharedInstance)
        }
    }
}
