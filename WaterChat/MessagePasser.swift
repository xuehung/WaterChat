//
//  MessagePasser.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MessagePasser: NSObject, MCNearbyServiceBrowserDelegate, MCNearbyServiceAdvertiserDelegate, MCSessionDelegate {

    // for multipeer conectivity
    var browser : MCNearbyServiceBrowser!
    var advisor : MCNearbyServiceAdvertiser!
    var session : MCSession!
    var peerID: MCPeerID!
    var cb: CommunicationBuffer!
    var rm: RouteManager!
    var macPeerMapping = Dictionary<MacAddr, MCPeerID>()
    var broadcastSeqNum: UInt32 = 0
    var addr: MacAddr!
    var broadcastSeqDict = Dictionary<MacAddr, UInt32>()


    // Singlton Pattern
    class func getInstance(addr: MacAddr) -> MessagePasser {
        struct Static {
            static var instance: MessagePasser?
        }

        if Static.instance == nil {
            Static.instance = MessagePasser(addr: addr)
        }
        return Static.instance!
    }

    // constructor is private so outsider has to call getInstance()
    private init(addr: MacAddr) {
        // I don't know what is super
        super.init();

        self.addr = addr

        // display name is the mac addr in UInt64
        self.peerID = MCPeerID(displayName: addr.description)
        self.session = MCSession(peer: peerID)
        self.session.delegate = self
        self.cb = CommunicationBuffer(mp: self)
        self.rm = RouteManager(addr: addr, mp: self)

        // create the browser viewcontroller with a unique service name
        self.browser = MCNearbyServiceBrowser(peer: self.peerID, serviceType: Config.serviceType)

        self.browser.delegate = self;

        self.advisor = MCNearbyServiceAdvertiser(peer: self.peerID, discoveryInfo:nil, serviceType: Config.serviceType)
        self.advisor.delegate = self

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
            
            if (session.connectedPeers.count >= Config.maxNeighbor) {
                return
            }
            // send the invitation
            self.session.connectPeer(foundPeer,
                withNearbyConnectionData: nil)
            self.browser.invitePeer(foundPeer, toSession: self.session, withContext: nil, timeout: NSTimeInterval(300))
    }

    func browser(browser: MCNearbyServiceBrowser!,
        lostPeer: MCPeerID!) {
            var i = 0
            var userToRemove : User
            for element in userList{
                if element.macAddress == lostPeer.displayName{
                    userToRemove = userList[i]
                    userList.removeAtIndex(i)
                    userToRemove.type = NSNumber(unsignedChar: MessageType.RMVUSER.rawValue)    //sending broadcast message to let everyone know this user has left
                                                                                                //needed for multihop that do not directly lose this peer
                    broadcast(userToRemove.createJsonDict())
                }
                i = i+1
            }

            Logger.log("lost a new peer \(lostPeer.displayName)")
            var mac = Util.convertDisplayNameToMacAddr(lostPeer.displayName)
            Logger.log("remove \(mac) from mapping")
            self.macPeerMapping.removeValueForKey(mac)
    }

    func advertiser(advertiser: MCNearbyServiceAdvertiser!,
        didReceiveInvitationFromPeer peerID: MCPeerID!,
        withContext context: NSData!,
        invitationHandler: ((Bool,
        MCSession!) -> Void)!) {

            Logger.log("Received an invitation from \(peerID.displayName)")
            
            if (session.connectedPeers.count >= Config.maxNeighbor) {
                return
            }
            
            if (peerID.displayName > self.peerID.displayName) {
                Logger.log("accept")
                invitationHandler(true, self.session)
            } else {
                Logger.log("reject")
                invitationHandler(true, self.session)
            }
            var mac = Util.convertDisplayNameToMacAddr(peerID.displayName)
            self.macPeerMapping[mac] = peerID
            Logger.log("add \(mac) into mapping")
    }



    // Called when a peer sends an NSData to us
    // reveive
    func session(session: MCSession!, didReceiveData data: NSData!,
        fromPeer peerID: MCPeerID!)  {
            Logger.log("Got data from \(peerID.displayName)")

            // This needs to run on the main queue
            dispatch_async(dispatch_get_main_queue()) {

                var message = Message.messageFactory(data)
                var fromAddr = Util.convertDisplayNameToMacAddr(peerID.displayName)
                
                self.macPeerMapping[fromAddr] = peerID

                Logger.log("@@@@@@@@@@@@@ Message Type = \(message.type.rawValue.description)")


                switch message.type {
                case MessageType.RREP:
                    Logger.log("Got RouteReply")
                    self.rm.reveiveRouteReply(fromAddr, reply: message as! RouteReply)
                    break
                case MessageType.UNICASTJSON:
                    var um = message as! UnicastJSONMessage
                    if um.destMacAddr == self.addr {
                        Logger.log("Got a message for me")
                        var jmsg = JSONMessage(dict: um.getDict())
                        Logger.log("put jmsg into buffer")
                        self.cb.addToIncomingBuffer(jmsg)
                    } else {
                        Logger.log("The message is not for me (for \(um.destMacAddr))")
                        self.directSend(um.destMacAddr, data: message.serialize())
                    }
                    break
                case MessageType.RERR:
                    break
                case MessageType.BROADCAST:

                    var bmsg = message as! BroadcastMessage
                    if( bmsg.srcMacAddr == Config.address) {
                        break
                    }
                    Logger.log("bmsg.broadcastSeqNum = \(bmsg.broadcastSeqNum)")

                    if let seqNum = self.broadcastSeqDict[bmsg.srcMacAddr] {
                        Logger.log("old seqNum = \(seqNum)")
                        // the second condition is designed for smaller
                        // broadcast seqNum when device restarts

                        if ((bmsg.broadcastSeqNum <= seqNum &&
                            bmsg.broadcastSeqNum + 10 > seqNum)) {
                                println("stop")
                                break
                        }
                    }
                    self.broadcastSeqDict[bmsg.srcMacAddr] = bmsg.broadcastSeqNum
                    var innerMsg = bmsg.getInnerMessage()
                    if (innerMsg.type == MessageType.RREQ) {
                        Logger.log("Got RouteRequest")
                        self.rm.reveiveRouteRequest(fromAddr, message: innerMsg as! RouteRequest)
                    } else {
                        self.cb.addToIncomingBuffer(bmsg.getInnerMessage())
                        dispatch_async(dispatch_get_main_queue()) {
                            self.cb.broadcast(innerMsg.serialize())
                        }
                    }

                    break
                case MessageType.BROADCASTJSON:
                    var bmsg = message as! BroadcastJSONMessage
                    if( bmsg.srcMacAddr == Config.address) {
                        break
                    }
                    Logger.log("bmsg.broadcastSeqNum = \(bmsg.broadcastSeqNum)")
                    if let seqNum = self.broadcastSeqDict[bmsg.srcMacAddr] {
                        Logger.log("old seqNum = \(seqNum)")
                        // the second condition is designed for smaller
                        // broadcast seqNum when device restarts
                        if ((bmsg.broadcastSeqNum <= seqNum &&
                            bmsg.broadcastSeqNum + 10 > seqNum)) {
                                println("stop")
                                break
                        }
                    }
                    self.broadcastSeqDict[bmsg.srcMacAddr] = bmsg.broadcastSeqNum
                    var jmsg = JSONMessage(dict: bmsg.getDict())
                    Logger.log("put jmsg into buffer")
                    self.cb.addToIncomingBuffer(jmsg)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.cb.broadcast(bmsg.serialize())
                    }
                    break

                default:
                    Logger.error("Wrong Message!!!")
                    break
                }
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

    //func send(dest: MacAddr, message: Message) {
        //self.cb.send(dest, data: message.serialize())
    //}

    func directSend(dest: MacAddr, data: NSData) {
        Logger.log("Direct send to \(dest)")
        if let peerID = self.macPeerMapping[dest] {
            dispatch_async(dispatch_get_main_queue()) {
                var error : NSError?
                self.session.sendData(data, toPeers: [peerID], withMode: MCSessionSendDataMode.Reliable, error: &error)
                if error != nil {
                    Logger.log("Error sending data: \(error?.localizedDescription)")
                }
                Logger.log("Direct send to \(dest) successfully")
            }
        } else {
            Logger.error("Not found peerID \(dest) in macPeerMapping")
            Logger.error(self.macPeerMapping.description)
        }
    }

    /*
    func send(dest: MCPeerID, message: Message) {
        var rawMessage = RawMessage(dest: dest, data: message.serialize())
        self.cb.addToOutgoingBuffer(rawMessage)
    }
    */

    func broadcast(message: Message) {
        Logger.log("Broadcast")
        dispatch_async(dispatch_get_main_queue()) {
            self.broadcastSeqNum++
            var bmsg = BroadcastMessage(message: message, seqNum: self.broadcastSeqNum, srcMacAddr: self.addr)
            self.cb.broadcast(bmsg.serialize())
        }
    }

    /*
    func broadcast(message: JSONMessage) {
        Logger.log("Broadcast JSON Message")
        dispatch_async(dispatch_get_main_queue()) {
            self.broadcastSeqNum++
            var bmsg = BroadcastJSONMessage(message: message, seqNum: self.broadcastSeqNum, srcMacAddr: self.addr)
            self.cb.broadcast(bmsg.serialize())
        }
    }
    */

    func broadcast(message: NSDictionary) {
        Logger.log("Broadcast JSON Message")
        dispatch_async(dispatch_get_main_queue()) {
            self.broadcastSeqNum++
            var bmsg = BroadcastJSONMessage(message: message, seqNum: self.broadcastSeqNum, srcMacAddr: self.addr)
            self.cb.broadcast(bmsg.serialize())
        }
    }

    func send(dest: MacAddr, message: NSDictionary) {
        //self.cb.send(dest, data: message.serialize())
        Logger.log("Unicast JSON Message to \(dest)")
        Logger.log(message.description)
        dispatch_async(dispatch_get_main_queue()) {
            var msg = UnicastJSONMessage(message: message, destMacAddr: dest)
            self.cb.addToOutgoingBuffer(dest, data: msg.data)
        }
    }

    // called by the application
    func receive() -> Message {
        return self.cb.takeOneFromIncomingBuffer()
    }
    
    func getNeighbors() -> String{
        var x = self.session.connectedPeers
        return x.description
    }

}
