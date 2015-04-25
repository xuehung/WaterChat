//
//  TypeTableViewCell.swift
//  WaterChat
//
//  Created by Ding ZHAO on 4/23/15.
//  Copyright (c) 2015 Hsueh-Hung Cheng. All rights reserved.
//

import UIKit

class TypeTableViewCell: UITableViewCell {
    
    var typeMsg = UITextField()
    var sendBtn = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addSubview(typeMsg)
        self.addSubview(sendBtn)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
