//
//  UIColor+CustomColors.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

import UIKit

// MARK: - Custom Color
extension UIColor {
    static var backgroundColor: UIColor {
        return UIColor(hex: "#121212")
    }
    
    static var secondaryBackgroundColor: UIColor {
        return UIColor(hex: "#333333")
    }
    
    static var primaryTextColor: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var secondaryTextColor: UIColor {
        return UIColor(hex: "#B3B3B3")
    }
    
    static var tabBarUnselectedTextColor: UIColor {
        return UIColor(hex: "#E5E5E5")
    }
    
    static var tabBarSelectedTextColor: UIColor {
        return UIColor(hex: "#FFFFFF")
    }
    
    static var confirmButtonColor: UIColor {
        return UIColor(hex: "#1ED760")
    }
    
    static var topGradientColor: UIColor {
        return UIColor(hex: "#5628F8")
    }
    
    static var playlistBorderColor: UIColor {
        return UIColor(hex: "#7F7F7F")
    }
    
}


// MARK: - Hex converter
extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

