//
//  UILable + Extension.swift
//  WorkOut
//
//  Created by d vasylenko on 13.04.2022.
//

import UIKit

extension UILabel {
    convenience init(text: String = "") {
        self.init()
        self.text = text
        self.font = .systemFont(ofSize: 16)
        self.textColor = .systemGray6
        self.adjustsFontSizeToFitWidth = true
      
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    convenience init(text: String = "", font: UIFont!, fontColor: UIColor, lines: Int ) {
        self.init()
        self.text = text
        self.textColor = fontColor
        self.font = font
        self.numberOfLines = lines
        self.adjustsFontSizeToFitWidth = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
