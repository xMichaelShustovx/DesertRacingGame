//
//  BackgroundView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 20.01.2022.
//

import UIKit

class BackgroundView: UIImageView {

    // MARK: - Properties
    
    private let backgroundImage = UIImage(named: "desertBackground")
    
    // MARK: - Initializers
    
    init() {
        super.init(image: backgroundImage)
        
        translatesAutoresizingMaskIntoConstraints = false
        contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
