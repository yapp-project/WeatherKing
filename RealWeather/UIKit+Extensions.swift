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
            shadowPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
//            shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        }
    }
}

extension UIView {
    enum ViewBorder {
        case left
        case right
        case top
        case bottom
    }
    
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
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addBorder(side: ViewBorder, color: CGColor, thickness: CGFloat) {
        
        let border = CALayer()
        border.backgroundColor = color
        
        switch side {
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        }
        layer.addSublayer(border)
    }
}

extension UIColor {
    static let bgColor = UIColor(red: 170, green: 177, blue: 185)
    static let CellBgColor = UIColor(red: 226, green: 226, blue: 230)
    static let mainColor = UIColor(red: 80, green: 97, blue: 236)
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(hex: Int, a: CGFloat = 1.0) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF,
            a: a
        )
    }
    class var grayText: UIColor {
        return UIColor(red: 173, green: 181, blue: 189)
    }
    
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
    
    class var cardShadowColor: UIColor {
        return UIColor(red: 52.0 / 255.0, green: 58.0 / 255.0, blue: 64.0 / 255.0, alpha: 0.36)
    }
    
    class var shadowColor30: UIColor {
        return UIColor(red: 173.0 / 255.0, green: 181.0 / 255.0, blue: 189.0 / 255.0, alpha: 0.3)
    }
    
    class var white80: UIColor {
        return UIColor(white: 1.0, alpha: 0.8)
    }
    
    class var white30: UIColor {
        return UIColor(white: 1.0, alpha: 0.3)
    }
    
    class var white50: UIColor {
        return UIColor(white: 1.0, alpha: 0.5)
    }
    
    class var dodgerBlue: UIColor {
        return UIColor(red: 77.0 / 255.0, green: 171.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
    }
    
    class var boringGreen: UIColor {
        return UIColor(red: 81.0 / 255.0, green: 207.0 / 255.0, blue: 102.0 / 255.0, alpha: 1.0)
    }
    
    class var mango: UIColor {
        return UIColor(red: 1.0, green: 146.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
    }
    
    class var salmon: UIColor {
        return UIColor(red: 1.0, green: 107.0 / 255.0, blue: 107.0 / 255.0, alpha: 1.0)
    }
    
    class var gunmetal: UIColor {
        return UIColor(red: 73.0 / 255.0, green: 80.0 / 255.0, blue: 87.0 / 255.0, alpha: 1.0)
    }

}

extension Int {
    var tempFormat: String {
        return "\(self)°"
    }
}


