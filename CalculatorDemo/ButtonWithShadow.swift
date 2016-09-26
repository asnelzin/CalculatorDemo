//
//  PaddingLabel.swift
//  CalculatorDemo
//
//  Created by Нельзин Александр on 20/09/16.
//  Copyright © 2016 Alexander Nelzin. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonWithShadow: UIButton {
    
    @IBInspectable var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        didSet {
            layer.shadowColor = shadowColor?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.5 {
        didSet {
            layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 0, height: 0) {
        didSet {
            layer.shadowOffset = shadowOffset
        }
    }
}

