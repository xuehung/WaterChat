//
//  RoutingManager.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/6/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation

typealias MacAddr = UInt64
typealias Time = UInt64

class RouteManager {
    // This number should be incremented in the following 2 cases
    // 1) before a node originates a route discovery
    // 2) before a destination node originates a RREP in response to a RREQ
    var seqNum: UInt32 = 0
    var PREQID: UInt32 = 0
    var mp: MessagePasser!
    var macAddr: MacAddr!
    
    var routeTable = Dictionary<MacAddr, TableEntry>()
    // when is the current request expired
    var PREQAttempt = Dictionary<MacAddr, Time>()
    // originatr addr : RREQ ID
    var receivedID = Dictionary<MacAddr, UInt32>()
    // originatr addr : received time
    var receivedTime = Dictionary<MacAddr, Time>()
    var failNumber = Dictionary<MacAddr, Int>()
    
    init(addr: MacAddr, mp: MessagePasser) {
        self.macAddr = addr
        self.mp = mp
    }
    
    func isRouteAvailable(addr: MacAddr) -> Bool {
        if let entry = routeTable[addr] {
            return isRouteValid(entry)
        }
        return false
    }
    
    func isRouteValid(route: TableEntry) -> Bool {
        return route.status == RouteStatus.valid && current() > route.lifeTime
    }
    
    func sendRouteRequest(addr: MacAddr) {
        
        // check wheather we have to send the request
        // we don't need to send if the route is available
        // or we just sent one and it hasn't timed out
        
        if isRouteAvailable(addr) {
            Logger.log("Route to \(addr) is available")
            return
        }
        if let time = self.PREQAttempt[addr] {
            if time < self.current() {
                Logger.log("Route to \(addr) is not available but request has been sent")
                return
            } else {
                Logger.log("Route to \(addr) is requested before but timeout")
                // not first, should have this key addr
                // update here in case of race condition
                self.failNumber[addr]!++
            }
        } else {
            Logger.log("Route to \(addr) is requested for the first time")
            // first time
            self.failNumber[addr] = 0
            // create the entry
            self.createEntry(addr)
        }
        refreshAttempt(addr)
        
        // creat the request
        var rr = RouteRequest()
        rr.destMacAddr = addr
        rr.origMacAddr = self.macAddr
        rr.PREQID = ++self.PREQID
        rr.origSeqNum = ++self.seqNum
        if let entry = routeTable[addr] {
            rr.destSeqNum = entry.destSeqNum
        } else {
            rr.U = 1
        }
        
        
        self.mp.broadcast(rr)
        
        
        
        /*
        Before broadcasting the RREQ, the originating node buffers the RREQ
        ID and the Originator IP address (its own address) of the RREQ for
            PATH_DISCOVERY_TIME.  In this way, when the node receives the packet
        again from its neighbors, it will not reprocess and re-forward the
        packet.
        */
        
        // For each additional attempt, the waiting time
        // for the RREP is multiplied by 2, so that the time conforms to a
        // binary exponential backoff
        
    }
    
    func reveiveRouteRequest(from: MacAddr, message: RouteRequest) {
        
        // creates or updates a route to the previous hop without a valid sequence number
        if self.routeTable[from] == nil {
            var entry = TableEntry()
            entry.destAddr = from
            self.routeTable[from] = entry
        }
        var fromEntry = self.routeTable[from]!
        fromEntry.isDestSeqNumValid = false
        fromEntry.status = RouteStatus.valid
        fromEntry.nextHop = from
        fromEntry.lifeTime = current() + AODVConfig.ACTIVE_ROUTE_TIMEOUT

        
        // it has received a RREQ with the same Originator IP Address and RREQ ID within at least the last PATH_DISCOVERY_TIME, return
        if (message.origMacAddr == self.macAddr) {
            Logger.log("got RREQ from myself")
            return
        }
        if (receivedID[message.origMacAddr] == message.PREQID) {
            Logger.log("got duplicate RREQ")
            if (receivedTime[message.origMacAddr]! + Time(AODVConfig.PATH_DISCOVERY_TIME) > current()) {
                Logger.log("within PATH_DISCOVERY_TIME")
                return
            }
            Logger.log("exceed PATH_DISCOVERY_TIME")
        }
        
        // update these tables to prevent duplicate broadcasting
        receivedID[message.origMacAddr] = message.PREQID
        receivedTime[message.origMacAddr] = current()
        
        
        // increments the hop count value in the RREQ by one
        message.hopCount++
        
        
        // reverse route is created or updated
        
        if (from != message.origMacAddr) {
            if let entry = self.routeTable[message.origMacAddr] {
                // the Originator Sequence Number from the RREQ is compared to
                // thecorresponding destination sequence number in the route 
                // table entry and copied if greater than the existing value 
                // there
                if (message.origSeqNum > entry.destSeqNum) {
                    entry.destSeqNum = message.origSeqNum
                }
                Logger.log("entry is updated")
            } else {
                var entry = TableEntry()
                entry.destAddr = message.origMacAddr
                entry.destSeqNum = message.origSeqNum
                // entry.lifetime is 0 here, will be updated later
                self.routeTable[message.origMacAddr] = entry
                Logger.log("entry is created")
            }
            var entry = self.routeTable[message.origMacAddr]!
            entry.isDestSeqNumValid = true
            entry.status = RouteStatus.valid
            entry.nextHop = from
            entry.hopCount = message.hopCount
            
            var minimalLifetime: UInt64 = current() + 2 * AODVConfig.NET_TRAVERSAL_TIME - UInt64(2 * message.hopCount) * UInt64(AODVConfig.NODE_TRAVERSAL_TIME)
            if (minimalLifetime > entry.lifeTime) {
                entry.lifeTime = minimalLifetime
                Logger.log("entry's life time is set to \(minimalLifetime)")
            }
        }
        
        if (message.destMacAddr == self.macAddr ||
            isRouteAvailable(message.destMacAddr)) {
            Logger.log("It is the destination or route is available")
            sendRouteReply(from, request: message)
        } else {
            Logger.log("no route available, rebroadcast")
            self.mp.broadcast(message)
        }
        
        //?
        //Lastly, the Destination Sequence number for the
        //requested destination is set to the maximum of the corresponding
        //value received in the RREQ message, and the destination sequence
        //value currently maintained by the node for the requested 
        //destination.
    }
    
    func sendRouteReply(from: MacAddr, request: RouteRequest) {
        Logger.log("sendRouteReply is called")
        var reply = RouteReply()
        reply.destMacAddr = request.destMacAddr
        reply.origMacAddr = request.origMacAddr

        // it is the destination
        if (request.destMacAddr == self.macAddr) {
            Logger.log("I am the destination")
            // If the generating node is the destination itself, 
            // it MUST increment its own sequence number by one 
            // if the sequence number in the RREQ packet is equal 
            // to that incremented value.
            if (request.destSeqNum == self.seqNum + 1) {
                self.seqNum++
            }
            
            reply.destSeqNum = self.seqNum
            reply.hopCount = 0
            reply.lifeTime = UInt32(AODVConfig.MY_ROUTE_TIMEOUT)
            
            self.mp.send(from, message: reply)

        // it is the intermediate node
        } else {
            Logger.log("I am the intermediate node")
            if let entry = self.routeTable[request.destMacAddr] {
                reply.destSeqNum = entry.destSeqNum
                reply.hopCount = entry.hopCount
                reply.lifeTime = UInt32(entry.lifeTime - current())
            } else {
                Logger.error("not found entry")
            }
        }
    }
    
    func reveiveRouteReply(from: MacAddr, reply: RouteReply) {
        
        // creates or updates a route to the previous hop without a valid sequence number
        if self.routeTable[from] == nil {
            var entry = TableEntry()
            entry.destAddr = from
            self.routeTable[from] = entry
        }
        var fromEntry = self.routeTable[from]!
        fromEntry.isDestSeqNumValid = false
        fromEntry.status = RouteStatus.valid
        fromEntry.nextHop = from
        fromEntry.lifeTime = current() + AODVConfig.ACTIVE_ROUTE_TIMEOUT
        
        reply.hopCount++
        
        // forward route for this destination is created if it does not already exist
        if let entry = self.routeTable[reply.destMacAddr] {
            if (entry.isDestSeqNumValid == false ||
                reply.destSeqNum > entry.destSeqNum ||
                (reply.destSeqNum == entry.destSeqNum &&
                    (entry.status == RouteStatus.invalid ||
                     entry.hopCount < reply.hopCount))) {
                // leave empty
            } else {
                return
            }
        } else {
            var entry = TableEntry()
            entry.destAddr = reply.destMacAddr
            self.routeTable[reply.destMacAddr] = entry
        }
        
        
        if let entry = self.routeTable[reply.destMacAddr] {
            entry.status = RouteStatus.valid
            entry.isDestSeqNumValid = true
            entry.nextHop = from
            entry.hopCount = reply.hopCount
            entry.lifeTime = current() + Time(reply.lifeTime)
            entry.destSeqNum = reply.destSeqNum
        } else {
            Logger.error("impossible!")
            return
        }
        
        if (reply.origMacAddr != self.macAddr) {
            // forward
            Logger.log("Forward reply")
            var next = self.routeTable[reply.origMacAddr]!
            self.mp.directSend(next.nextHop, data: reply.serialize())
        } else {
            Logger.log("Reply arrived")
            // TODO
        }
        
        
    }
    
    func refreshAttempt(addr: MacAddr) {
        PREQAttempt[addr] = current() + AODVConfig.PATH_DISCOVERY_TIME
        if let num = self.failNumber[addr] {
            // wait longer for additional try
            PREQAttempt[addr]! += AODVConfig.NET_TRAVERSAL_TIME * Time(2 * num)
        }
    }
    
    func createEntry(addr: MacAddr) -> TableEntry {
        if let entry = self.routeTable[addr] {
            return entry
        } else {
            self.routeTable[addr] = TableEntry()
            // TODO
            return self.routeTable[addr]!
        }
    }
    
    func current() -> Time {
        return UInt64(NSDate().timeIntervalSince1970)
    }
}