//
//  MessageTableViewCell.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/23/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

enum UIUserInterfaceIdiom : Int {
    case Unspecified
    
    case Phone // iPhone and iPod touch style UI
    case Pad // iPad style UI
}

var textMarginHorizontal = CGFloat(15.0)
var textMarginVertical = CGFloat(7.5)
var messageTextSize = CGFloat(14.0)

class MessageTableViewCell: UITableViewCell {
    
    var sentByMe = false
    var avatarImageView = UIImageView()
    var timeLabel = UILabel()
    var messageLabel = UILabel()
    var messageView = UIView()
    var bubbleView = UIImageView()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func maxTextWidth() -> CGFloat{
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return 220.0;
        } else {
            return 400.0;
        }
    }
    
    func messageSize(message : NSString) -> CGSize{
        /*var textRect = CGRect(
            [text boundingRectWithSize:size
            options:NSStringDrawingUsesLineFragmentOrigin
            attributes:@{NSFontAttributeName:FONT}
        context:nil];*/

        return message.sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(messageTextSize)])
        
            /*return message.sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake([PTSMessagingCell maxTextWidth], CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];*/
    }
    
    func bubbleImage(sentByMe : Bool)-> UIImage {
        if (sentByMe == true) {
            var bubbleImage = UIImage(named:"balloon_read_right")!.stretchableImageWithLeftCapWidth(24, topCapHeight: 15)
            return bubbleImage
        }else {
            var bubbleImage = UIImage(named:"balloon_read_left")!.stretchableImageWithLeftCapWidth(24, topCapHeight:15)
            return bubbleImage
        }
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!){
        super.init(style: style,reuseIdentifier: reuseIdentifier)
        
        //{
            /*Selection-Style of the TableViewCell will be 'None' as it implements its own selection-style.*/
            self.selectionStyle = UITableViewCellSelectionStyle.None
    
            /*Now the basic view-lements are initialized...*/
            messageView = UIView(frame: CGRectZero)
            //messageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
            bubbleView = UIImageView(frame: CGRectZero)
    
            messageLabel = UILabel(frame: CGRectZero)
            timeLabel = UILabel(frame: CGRectZero)

            //avatarImageView = UIImageView(frame: nil)
            avatarImageView = UIImageView()
            /*Message-Label*/
            self.messageLabel.backgroundColor = UIColor(clearColor)
            self.messageLabel.font = UIFont(name: "messageLabelFont", size: messageTextSize)
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.numberOfLines = 0;
    
            /*Time-Label*/
            self.timeLabel.font = UIFont(name: "timeLabelFont", size: 12.0)
            self.timeLabel.textColor = UIColor(darkGrayColor)
            self.timeLabel.backgroundColor = UIColor(clearColor)
    
            /*...and adds them to the view.*/
            self.messageView.addSubview(self.bubbleView)
            self.messageView.addSubview(self.messageLabel)
    
            self.contentView.addSubview(self.timeLabel)
            self.contentView.addSubview(self.messageView)
            self.contentView.addSubview(self.avatarImageView)
    
            /*...and a gesture-recognizer, for LongPressure is added to the view.
            recognizer = UILongPressGestureRecognizer(target: self, action: handleLongPress)
            recognizer.setMinimumPressDuration
            [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
            [recognizer setMinimumPressDuration:1.0f];
            [self addGestureRecognizer:recognizer];*/
            
        
        //}
        //return self
    }
    
    override func layoutSubviews() {
        /*This method layouts the TableViewCell. It calculates the frame for the different subviews, to set the layout according to size and orientation.*/
        
        /*Calculates the size of the message. */
        var textSize = messageSize(self.messageLabel.text!)
        /*Calculates the size of the timestamp.*/
        var dateSize = CGSize(width: maxTextWidth(), height: self.timeLabel.text.height)
        
        //CGSize dateSize = [self.timeLabel.text sizeWithFont:self.timeLabel.font forWidth:[PTSMessagingCell maxTextWidth] lineBreakMode:NSLineBreakByClipping];
        
        
        /*Initializes the different frames , that need to be calculated.*/
        //bubbleViewFrame = CGRectZero;
        //CGRect messageLabelFrame = CGRectZero;
        var timeLabelFrame = CGRect()
        var avatarImageFrame = CGRect()
        
        self.bubbleView.image = bubbleImage(self.sentByMe)
        if (self.sentByMe) {
            timeLabelFrame = CGRectMake(self.frame.size.width - dateSize.width - textMarginHorizontal, 0.0, dateSize.width, dateSize.height)
            
            self.bubbleView.frame = CGRectMake(self.frame.size.width - (textSize.width + 2*textMarginHorizontal), timeLabelFrame.size.height, textSize.width + 2*textMarginHorizontal, textSize.height + 2*textMarginVertical)
            
            self.messageLabel.frame = CGRectMake(self.frame.size.width - (textSize.width + textMarginHorizontal),  bubbleView.frame.origin.y + textMarginVertical, textSize.width, textSize.height)
            
            avatarImageFrame = CGRectMake(5.0, timeLabelFrame.size.height, 50.0, 50.0)
            
        } else {
            timeLabelFrame = CGRectMake(textMarginHorizontal, 0.0, dateSize.width, dateSize.height)
            
            self.bubbleView.frame = CGRectMake(0.0, timeLabelFrame.size.height, textSize.width + 2*textMarginHorizontal, textSize.height + 2*textMarginVertical)
            
            self.messageLabel.frame = CGRectMake(textMarginHorizontal, bubbleView.frame.origin.y + textMarginVertical, textSize.width, textSize.height)
            
            
            avatarImageFrame = CGRectMake(self.frame.size.width - 55.0, timeLabelFrame.size.height, 50.0, 50.0)
        }
        
        /*If shown (and loaded), sets the frame for the avatarImageView*/
        if (self.avatarImageView.image != nil) {
            self.avatarImageView.frame = avatarImageFrame
        }
        
        /*If there is next for the timeLabel, sets the frame of the timeLabel.*/
        
        if (self.timeLabel.text != nil) {
            self.timeLabel.frame = timeLabelFrame
        }
        
        /*
        //super.layoutSubviews()
        if(self.sentByMe){
            
            self.textLabel!.frame = CGRectMake(self.frame.size.width-self.textLabel!.frame.size.width-10, self.textLabel!.frame.origin.y, self.textLabel!.frame.size.width, self.textLabel!.frame.size.height)
            self.detailTextLabel!.frame = CGRectMake(self.frame.size.width-self.detailTextLabel!.frame.size.width-10, self.detailTextLabel!.frame.origin.y, self.detailTextLabel!.frame.size.width, self.detailTextLabel!.frame.size.height)
        }
        else{
            self.textLabel!.frame = CGRectMake(10, self.textLabel!.frame.origin.y, self.textLabel!.frame.size.width, self.textLabel!.frame.size.height)
            self.detailTextLabel!.frame = CGRectMake(10, self.detailTextLabel!.frame.origin.y, self.detailTextLabel!.frame.size.width, self.detailTextLabel!.frame.size.height)
        }*/
    }

}
