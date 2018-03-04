//
//  Util.swift
//  DesafioConcrete
//
//  Created by Haroldo Gondim on 27/01/18.
//  Copyright © 2018 Haroldo Gondim. All rights reserved.
//

import UIKit

class Util: NSObject {

    class func createMessageLabel(message :String, width: Int, height: Int) -> UILabel {
        let messageLabel = UILabel(frame: CGRect(x: 0,
                                                 y: 0,
                                                 width: width,
                                                 height: height))
        
        messageLabel.text = message
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()
        
        return messageLabel
    }

}
