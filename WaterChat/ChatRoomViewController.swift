//
//  ChatRoomViewController.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/12/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//
import UIKit

var chatMessages = [ChatMessage]()
var isListening = false

class ChatRoomViewController: JSQMessagesViewController {
    
    var roomChatMessages = [ChatMessage]()
    var curRoom = RoomInfo()
    var avatars = Dictionary<String, UIImage>()
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory.outgoingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory.incomingMessageBubbleImageViewWithColor(UIColor.jsq_messageBubbleGreenColor())
    var senderImageUrl: String!
    var batchMessages = true
    //var ref: Firebase!
    
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    //var messagesRef: Firebase!
    
    /*func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://swift-chat.firebaseio.com/messages")
        
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        messagesRef.queryLimitedToNumberOfChildren(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            let text = snapshot.value["text"] as? String
            let sender = snapshot.value["sender"] as? String
            let imageUrl = snapshot.value["imageUrl"] as? String
            
            let message = Message(text: text, sender: sender, imageUrl: imageUrl)
            self.messages.append(message)
            self.finishReceivingMessage()
        })
    }*/
    
    func setUpEventsListener() {
        events.listenTo("newchat", action: self.finishReceivingMessage)
        events.listenTo("newchat", action:  {
            println("trigger listened!!!!!!!!!!!!!!!!!!!!!!!");
        })

        
        /*dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
            
            while(true) {
                
                                //sleep(5)
                
            }
            
        }*/
    }
    
    
    func sendMessage(text: String!, sender: String!) {
        // *** STEP 3: ADD A MESSAGE TO FIREBASE
        /*messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender,
            "imageUrl":senderImageUrl
            ])*/
        tempSendMessage(text, sender: sender)
    }
    
    func tempSendMessage(text: String!, sender: String!) {
        let message = ChatMessage(text: text, sender: sender, imageUrl: senderImageUrl)
        
        
        if (curRoom.isPrivate) {
            var dest = Config.address
            for mem in curRoom.memberList {
                if (mem != Config.address.description) {
                    dest = Util.convertDisplayNameToMacAddr(mem)
                    break
                }
            }
            if (dest != Config.address) {
                One2OneCommunication.addMessage(dest, message: message)
            } else {
                Logger.error("impossible")
            }
            
        }
        roomChatMessages.append(message)
        sendToRoom(message)
        //self.collectionView.reloadData()
        //finishReceivingMessage()
    }
    
    func sendToRoom(msg: ChatMessage) {
        var mp = MessagePasser.getInstance(Config.address)
        var rm = RoomManager()
        var mdict = rm.MsgToJSON(msg)
        if (curRoom.isPrivate) {
            mdict.setObject(Config.address.description, forKey: "mac")
            for mem in curRoom.memberList {
                if (mem != Config.address.description) {
                    var dest: MacAddr = Util.convertDisplayNameToMacAddr(mem)
                    mp.send(dest, message: mdict)
                    Logger.log("send a private message to \(dest)")
                    break
                }
            }
        } else {
            for mem in curRoom.memberList {
                if (mem != Config.address.description) {
                    var dest: MacAddr = Util.convertDisplayNameToMacAddr(mem)
                    mp.send(dest, message: mdict)
                }
            }
        }
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarFactory.avatarWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = count(name)
        Logger.log("name length is \(nameLength)")
        //let initials = name
        let initials : String? = name.substringToIndex(advance(sender.startIndex, 1))
            //min(1, nameLength)))
        let userImage = JSQMessagesAvatarFactory.avatarWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        
        avatars[name] = userImage
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.setNavigationBarHidden(false, animated: true)
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        //navigationController?.navigationBar.topItem?.title = "Leave"
        //navigationController?.popToRootViewControllerAnimated(true)
        
        //sender = (sender != nil) ? sender : "Anonymous"
        sender = currentUserInfo.name as String
        /*let profileImageUrl = user?.providerData["cachedUserProfile"]?["profile_image_url_https"] as? NSString
        if let urlString = profileImageUrl {
            setupAvatarImage(sender, imageUrl: urlString as String, incoming: false)
            senderImageUrl = urlString as String
        } else {
            setupAvatarColor(sender, incoming: false)
            senderImageUrl = ""
        }*/
        setupAvatarColor(sender, incoming: false)
        senderImageUrl = ""
        
        
        //Util.roomvc = self
        curRoom = currentRoomInfo
        Logger.log("current room name is \(curRoom.name)")
        if(!isListening){
            setUpEventsListener()
            isListening = true
        }
        if(curRoom.isPrivate == true) {
            //one to one dialog
            for member in curRoom.memberList{
                if(member != currentUserInfo.macAddress){
                    let memberAddr = Util.convertDisplayNameToMacAddr(member)
                    if(one2oneMsg[memberAddr] != nil){
                        roomChatMessages = one2oneMsg[memberAddr]!
                    }
                }
            }
        }
        else{
            roomChatMessages = chatMessages
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        /*if ref != nil {
            ref.unauth()
        }*/
    }
    
    // ACTIONS
    
    func receivedMessagePressed(sender: UIBarButtonItem) {
        // Simulate reciving message
        showTypingIndicator = !showTypingIndicator
        scrollToBottomAnimated(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        sendMessage(text, sender: sender)
        Logger.log("before sending \(roomChatMessages.count) msgs")
        finishSendingMessage()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        println("Camera pressed!")
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return roomChatMessages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = roomChatMessages[indexPath.item]
        
        if message.sender() == sender {
            return UIImageView(image: outgoingBubbleImageView.image, highlightedImage: outgoingBubbleImageView.highlightedImage)
        }
        
        return UIImageView(image: incomingBubbleImageView.image, highlightedImage: incomingBubbleImageView.highlightedImage)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = roomChatMessages[indexPath.item]
        if let avatar = avatars[message.sender()] {
            return UIImageView(image: avatar)
        } else {
            setupAvatarImage(message.sender(), imageUrl: message.imageUrl(), incoming: true)
            return UIImageView(image:avatars[message.sender()])
        }
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return roomChatMessages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = roomChatMessages[indexPath.item]
        if message.sender() == sender {
            cell.textView.textColor = UIColor.blackColor()
        } else {
            cell.textView.textColor = UIColor.whiteColor()
        }
        
        let attributes : [NSObject:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
        //        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor,
        //            NSUnderlineStyleAttributeName: NSUnderlineStyle.StyleSingle]
        return cell
    }
    
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = roomChatMessages[indexPath.item];
        
        // Sent by me, skip
        if message.sender() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = roomChatMessages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.sender())
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = roomChatMessages[indexPath.item]
        
        // Sent by me, skip
        if message.sender() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = roomChatMessages[indexPath.item - 1];
            if previousMessage.sender() == message.sender() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
}
