//
//  CheckBox.swift
//  fakeCall
//
//  Created by Amy Giver on 5/24/16.
//  Copyright © 2016 Amy Giver Squid. All rights reserved.
//

import UIKit
class CheckBox : UIButton {
    
    
    let checkedImage = UIImage(named: "check")! as UIImage
    let uncheckedImage = UIImage(named: "uncheck")! as UIImage
    
    var isChecked: Bool = false {
        didSet {
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }
    
}
