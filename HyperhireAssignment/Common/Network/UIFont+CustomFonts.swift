//
//  UIFont+CustomFonts.swift
//  HyperhireAssignment
//
//  Created by ricky wirawan on 07/12/24.
//

import UIKit

extension UIFont{
    
    public enum AvenirNextType: String {
        case regular = "-Regular"
        case bold = "-Bold"
    }
    
    static func AvenirNext(type: AvenirNextType, size: CGFloat) -> UIFont?{
        return UIFont(name: "AvenirNextLTPro\(type.rawValue)", size: size)
    }
    
}
