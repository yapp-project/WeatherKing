//
//  UIKit+Extensions.swift
//  RealWeather
//
//  Created by SangDon Kim on 30/03/2019.
//  Copyright © 2019 yapp. All rights reserved.
//

import UIKit

extension CALayer {
    func applySketchShadow(color: UIColor = .black, alpha: Float = 0.5, x: CGFloat = 0, y: CGFloat = 2, blur: CGFloat = 4, spread: CGFloat = 0) {
        masksToBounds = false
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
}

extension UIView {
    @objc var borderColor: UIColor? {
        get {
            if let borderColor = layer.borderColor {
                return UIColor(cgColor: borderColor)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
}

extension UIColor {
    
    class var charcoalGrey: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 58.0 / 255.0, blue: 64.0 / 255.0, alpha: 1.0)
    }
    
    class var lightBlueGrey: UIColor {
        return UIColor(red: 206.0 / 255.0, green: 212.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    }
    
    class var lightishBlue: UIColor {
        return UIColor(red: 80.0 / 255.0, green: 97.0 / 255.0, blue: 236.0 / 255.0, alpha: 1.0)
    }
    
    class var aquaMarine: UIColor {
        return UIColor(red: 56.0 / 255.0, green: 217.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0)
    }
    
    class var shadowColor80: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 0.8)
    }
    
    class var shadowColor30: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 0.3)
    }
}

extension Int {
    var tempFormat: String {
        return "\(self)°"
    }
}
