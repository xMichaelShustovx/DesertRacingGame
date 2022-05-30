//
//  ObstacleView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 21.01.2022.
//

import UIKit

class ObstacleView: UIImageView {

    private let obstacleImage = UIImage(named: "rock")
    
    init() {
        super.init(image: obstacleImage)
        
        backgroundColor = .clear
        contentMode = .scaleToFill
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
