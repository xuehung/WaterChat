//
//  MessagePasser.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MessagePasser: NSObject, MCNearbyServiceBrowserDelegate, MCSessionDelegate {
    
    // for multipeer conectivity
    var browser : MCNearbyServiceBrowser!
    var advisor : MCNearbyServiceAdvertiser!
    var session : MCSession!
    var peerID: MCPeerID!
    
    // Singlton Pattern
    class var getInstance: MessagePasser {
        struct Static {
            static var instance: MessagePasser?
        }
        
        if Static.instance == nil {
            Static.instance = MessagePasser()
        }
        return Static.instance!
    }
    
    // constructor is private so outsider has to call getInstance()
    private override init() {
        // I don't know what is super
        super.init();
        
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: Config.serviceType)
        
        self.browser.delegate = self;
        
        self.advisor = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo:nil, serviceType: Config.serviceType)
        
        Logger.log("Initialize MessagePasser with name = \(UIDevice.currentDevice().name)")
        
        // Begins advertising the service provided by a local peer
        self.advisor.startAdvertisingPeer()
        
        // Starts browsing for peers
        self.browser.startBrowsingForPeers()
        
        Logger.log("Started advertising and browsing")
    }
    
    // The following two methods are required for MCNearbyServiceBrowserDelegate
    
    func browser(browser: MCNearbyServiceBrowser!,
        foundPeer: MCPeerID!,
        withDiscoveryInfo info: [NSObject : AnyObject]!) {
            Logger.log("found a new peer \(foundPeer.displayName)")
            self.session.connectPeer(foundPeer, withNearbyConnectionData: nil)
    }
    
    func browser(browser: MCNearbyServiceBrowser!,
        lostPeer: MCPeerID!) {
            Logger.log("lost a new peer \(lostPeer.displayName)")
    }
    
    
    
    // Called when a peer sends an NSData to us
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                //self.updateChat(msg!, fromPeer: peerID)
            }
    }
    
    // The following methods do nothing, but the MCSessionDelegate protocol
    // requires that we implement them.
    func session(session: MCSession!,
        didStartReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!, withProgress progress: NSProgress!)  {
            
            // Called when a peer starts sending a file to us
    }
    
    func session(session: MCSession!,
        didFinishReceivingResourceWithName resourceName: String!,
        fromPeer peerID: MCPeerID!,
        atURL localURL: NSURL!, withError error: NSError!)  {
            // Called when a file has finished transferring from another peer
    }
    
    func session(session: MCSession!, didReceiveStream stream: NSInputStream!,
        withName streamName: String!, fromPeer peerID: MCPeerID!)  {
            // Called when a peer establishes a stream with us
    }
    
    func session(session: MCSession!, peer peerID: MCPeerID!,
        didChangeState state: MCSessionState)  {
            // Called when a connected peer changes state (for example, goes offline)
    }
    
    func broadcast(data: NSData) {
        for peer in self.session.connectedPeers {
            
        }
    }
    
    
}
