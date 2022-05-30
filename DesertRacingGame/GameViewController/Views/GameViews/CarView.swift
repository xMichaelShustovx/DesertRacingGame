//
//  CarView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 20.01.2022.
//

import UIKit

class CarView: UIImageView {

    private let carImage = UIImage(named: "carImage")
    private (set) var isFlying = false
    
    init() {
        super.init(image: carImage)
        
        carImage?.withRenderingMode(.alwaysTemplate)
        
        isUserInteractionEnabled = true
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        contentMode = .scaleToFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animateJump() {
        self.isFlying.toggle()
        UIView.animate(withDuration: 1) {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        } completion: { _ in
            UIView.animate(withDuration: 1) {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
            } completion: { _ in
                self.isFlying.toggle()
            }
        }
    }
}
