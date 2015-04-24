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
    var outgoingBuffer: [RawMessage] = []
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
    
    func addToOutgoingBuffer(message: RawMessage) {
        
        dispatch_semaphore_wait(self.outgoingMutex, DISPATCH_TIME_FOREVER)
        self.outgoingBuffer.append(message)
        dispatch_semaphore_signal(self.outgoingMutex)
        
        dispatch_semaphore_signal(self.outgoingCountSem)
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
}
