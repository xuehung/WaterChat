//
//  CommunicationBuffer.swift
//  WaterChat
//
//  Created by Hsueh-Hung Cheng on 3/10/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationBuffer {
    //var outgoingBuffer: [RawMessage] = []
    var outgoingBuffer = Dictionary<MacAddr, [NSData]>()
    var incomingBuffer: [Message] = []
    var mp: MessagePasser!
    var outgoingCountSem: dispatch_semaphore_t!
    var outgoingMutex: dispatch_semaphore_t!
    var incomingCountSem: dispatch_semaphore_t!
    var incomingMutex: dispatch_semaphore_t!
    
    init (mp: MessagePasser) {
        self.mp = mp
        self.outgoingCountSem = dispatch_semaphore_create(0)
        self.outgoingMutex = dispatch_semaphore_create(1)
        self.incomingCountSem = dispatch_semaphore_create(0)
        self.incomingMutex = dispatch_semaphore_create(1)
        
    }
    
    func addToIncomingBuffer(message: Message) {
        
        dispatch_semaphore_wait(self.incomingMutex, DISPATCH_TIME_FOREVER)
        self.incomingBuffer.append(message)
        dispatch_semaphore_signal(self.incomingMutex)
        
        dispatch_semaphore_signal(self.incomingCountSem)

    }
    
    func takeOneFromIncomingBuffer() -> Message {
        
        dispatch_semaphore_wait(self.incomingCountSem, DISPATCH_TIME_FOREVER)
        dispatch_semaphore_wait(self.incomingMutex, DISPATCH_TIME_FOREVER)
        var message = self.incomingBuffer.removeAtIndex(0)
        dispatch_semaphore_signal(self.incomingMutex)
        
        return message
    }
    /*
    func addToOutgoingBuffer(message: RawMessage) {
        
        dispatch_semaphore_wait(self.outgoingMutex, DISPATCH_TIME_FOREVER)
        self.outgoingBuffer.append(message)
        dispatch_semaphore_signal(self.outgoingMutex)
        
        dispatch_semaphore_signal(self.outgoingCountSem)
    }
    */
    
    func addToOutgoingBuffer(dest: MacAddr, data: NSData) {
        
        dispatch_semaphore_wait(self.outgoingMutex, DISPATCH_TIME_FOREVER)
        
        for peerID in self.mp.session.connectedPeers {
            if (peerID.displayName == dest.description) {
                self.mp.directSend(dest, data: data)
                break
            }
        }
        
        
        if let next = self.mp.rm.getNextHop(dest) {
            self.mp.directSend(next, data: data)
        } else {
            if self.outgoingBuffer[dest] == nil {
               self.outgoingBuffer[dest] = []
            }
            Logger.log("Added int outgoing buffer")
            self.outgoingBuffer[dest]?.append(data)
            Logger.log("Ask rm to send route request")
            self.mp.rm.sendRouteRequest(dest)
        }
        
        dispatch_semaphore_signal(self.outgoingMutex)
        
    }
    
    func cleanOutgoingBuffer(dest: MacAddr) {
        dispatch_semaphore_wait(self.outgoingMutex, DISPATCH_TIME_FOREVER)
        
        if let next = self.mp.rm.getNextHop(dest) {
            if let dataArray = self.outgoingBuffer[dest] {
                for data in dataArray {
                    self.mp.directSend(dest, data: data)
                }
                self.outgoingBuffer[dest] = []
            } else {
                Logger.log("data is nil")
            }
        } else {
            Logger.error("getNextHop is not available")
        }
        
        dispatch_semaphore_signal(self.outgoingMutex)
    }
    
    func broadcast(data: NSData) {
        
        Logger.log("connectedPeers = \(self.mp.session.connectedPeers)")
        
        var toPeers = self.mp.session.connectedPeers
        
        if (toPeers.count > 0) {
            // broadcast directly
            var error : NSError?
            self.mp.session.sendData(data, toPeers: toPeers, withMode: MCSessionSendDataMode.Unreliable, error: &error)
            if error != nil {
                Logger.log("Error broadcasting data: \(error?.localizedDescription)")
            }
        }
    }
    /*
    func createSendingQueue() {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            while (true) {
                dispatch_semaphore_wait(self.outgoingCountSem, DISPATCH_TIME_FOREVER)
                
                dispatch_semaphore_wait(self.outgoingMutex, DISPATCH_TIME_FOREVER)
                var msg: RawMessage = self.outgoingBuffer.removeLast()
                dispatch_semaphore_signal(self.outgoingMutex)
                
                var error : NSError?
                if let dest = msg.dest {
                    self.mp.session.sendData(msg.data, toPeers: [dest], withMode: MCSessionSendDataMode.Unreliable, error: &error)
                } else {
                    Logger.log("Error no dest: \(error?.localizedDescription)")
                }
                if error != nil {
                    Logger.log("Error sending data: \(error?.localizedDescription)")
                }
            }
        }
    }
    */
}
