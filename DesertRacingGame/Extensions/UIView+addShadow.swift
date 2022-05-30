//
//  UIView+addShadow.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 22.02.2022.
//

import UIKit


extension UIView {
    func setShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 2
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 3, height: 3)
        self.layer.masksToBounds = false
    }
}
