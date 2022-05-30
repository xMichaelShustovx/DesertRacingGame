//
//  UIPanGestureRecognizer+CancelRecognition.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 14.02.2022.
//

import UIKit

extension UIPanGestureRecognizer {
    
    func cancelRecognition() {
        self.isEnabled = false
        self.isEnabled = true
    }
}
