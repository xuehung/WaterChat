//
//  ViewController.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 2/26/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit
import MultipeerConnectivity
import ExternalAccessory


class ViewController: UIViewController, MCNearbyServiceBrowserDelegate,
MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {
    
    let serviceType = "WaterChat"
    
    var browser : MCNearbyServiceBrowser!
    var advisor : MCNearbyServiceAdvertiser!
    var session: MCSession!
    var peerID: MCPeerID!
    var mp: MessagePasser!
    
    @IBOutlet var chatView: UITextView!
    @IBOutlet var messageField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.peerID = MCPeerID(displayName: UIDevice.currentDevice().name)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        
        // create the browser viewcontroller with a unique service name
        self.browser = MCNearbyServiceBrowser(peer:self.peerID, serviceType:serviceType)
        
        self.browser.delegate = self
        
        
        self.advisor = MCNearbyServiceAdvertiser(peer:self.peerID, discoveryInfo:nil, serviceType:serviceType)
        self.advisor.delegate = self
        // tell the assistant to start advertising our fabulous chat
        self.advisor.startAdvertisingPeer()
        self.browser.startBrowsingForPeers()
        
        
        
        
        //test()
    }
    
    @IBAction func sendChat(sender: UIButton) {
        // Bundle up the text in the message field, and send it off to all
        // connected peers
        
        let msg = self.messageField.text.dataUsingEncoding(NSUTF8StringEncoding,
            allowLossyConversion: false)
        
        var error : NSError?
        
        self.session.sendData(msg, toPeers: self.session.connectedPeers,
            withMode: MCSessionSendDataMode.Unreliable, error: &error)
        
        if error != nil {
            print("Error sending data: \(error?.localizedDescription)")
        }
        
        self.updateChat(self.messageField.text, fromPeer: self.peerID)
        
        self.messageField.text = ""
    }
    
    func updateChat(text : String, fromPeer peerID: MCPeerID) {
        // Appends some text to the chat view
        
        // If this peer ID is the local device's peer ID, then show the name
        // as "Me"
        var name : String
        
        switch peerID {
        case self.peerID:
            name = "Me"
        default:
            name = peerID.displayName
        }
        
        // Add the name to the message and display it
        let message = "\(name): \(text)\n"
        self.chatView.text = self.chatView.text + message
        
    }
    
    @IBAction func showBrowser(sender: UIButton) {
        // Show the browser view controller
        //self.presentViewController(self.browser, animated: true, completion: nil)
        
        //mp.rm.sendRouteRequest(2)
        println("take")
        mp.cb.takeOneFromIncomingBuffer()
        println("finish")
        
    }
    
    /*
    func browserViewControllerDidFinish(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is dismissed (ie the Done
            // button was tapped)
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(
        browserViewController: MCBrowserViewController!)  {
            // Called when the browser view controller is cancelled
            
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
    func browser(browser: MCNearbyServiceBrowser!,
        foundPeer: MCPeerID!,
        withDiscoveryInfo info: [NSObject : AnyObject]!) {
            println("found a peer");
            self.session.connectPeer(foundPeer, withNearbyConnectionData: nil)
            println(foundPeer.displayName);
            self.browser.invitePeer(foundPeer, toSession: self.session, withContext: nil, timeout: NSTimeInterval(300))
    }
    
    func browser(browser: MCNearbyServiceBrowser!,
        lostPeer peerID: MCPeerID!) {
            println("lost a peer");
    }
    
    
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            var m = Message.messageFactory(data)
            // Called when a peer sends an NSData to us
            
            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {
                
                var msg = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                self.updateChat(msg!, fromPeer: peerID)
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
    
    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
        didReceiveInvitationFromPeer peerID: MCPeerID!,
        withContext context: NSData!,
        invitationHandler: ((Bool,
        MCSession!) -> Void)!) {
            
            println("Received an invitation from \(peerID.displayName)")
            invitationHandler(true, self.session)
    }
    
    func test() {
        
        
        var cof = EAWiFiUnconfiguredAccessory()
        println("macaddr = \(cof.macAddress)")
        println("manufacturer = \(cof.manufacturer)")
        println("ssid = \(cof.ssid)")
        
        //self.mp = MessagePasser.getInstance
        
        //mp.send(<#nextHop: MacAddr#>, message: <#Message#>)
    }
}
