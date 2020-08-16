//
//  CustomTF.swift
//  Pajlot MGRS Pro
//
//  Created by Adam on 29.01.2019.
//  Copyright © 2019 Adam Olechno. All rights reserved.
//

import UIKit

class CustomTF: UITextField {
    
    override func becomeFirstResponder() -> Bool {
        layer.customBorderColor = UIColor(named: "mainColor")!
        layer.cornerRadius = 10.0
        layer.masksToBounds = true
        layer.borderWidth = 1
        super.becomeFirstResponder()
        
        return true
    }
    
    override func resignFirstResponder() -> Bool {
        layer.customBorderColor = UIColor.clear
        super.resignFirstResponder()
        
        return true
    }
}

extension CALayer {
    var customBorderColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        get {
            return UIColor(named: "mainColor")!
        }
    }
}
