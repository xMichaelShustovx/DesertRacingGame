//
//  DustView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 21.01.2022.
//

import UIKit

class DustView: UIView {

    private var counter = 0
    
    private lazy var leftDustVConstraint = leftDust.heightAnchor.constraint(equalTo: leftDust.widthAnchor, multiplier: 4)
    private lazy var rightDustVConstraint = rightDust.heightAnchor.constraint(equalTo: rightDust.widthAnchor, multiplier: 4)
    
    let leftDust: UIImageView = {
        let image = UIImage(named: "Dust")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let rightDust:UIImageView = {
        let image = UIImage(named: "Dust")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    init() {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        setupImagesLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImagesLayout() {
        
        [leftDust, rightDust].forEach { addSubview($0) }
        
        NSLayoutConstraint.activate([
            leftDust.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/5),
            leftDustVConstraint,
            leftDust.topAnchor.constraint(equalTo: topAnchor),
            leftDust.leftAnchor.constraint(equalTo: leftAnchor),
            
            rightDust.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/5),
            rightDustVConstraint,
            rightDust.topAnchor.constraint(equalTo: topAnchor),
            rightDust.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    
    func animate(fps: Double) {
        
        switch counter {
            
        case 0:
            leftDustVConstraint.constant = -leftDust.frame.maxY * 0.85
            rightDustVConstraint.constant = -rightDust.frame.maxY * 0.85
            counter += 1
        case Int(fps/4):
            leftDustVConstraint.constant = -leftDust.frame.maxY * 0.65
            rightDustVConstraint.constant = -rightDust.frame.maxY * 0.65
            counter += 1
        case Int(fps/2):
            leftDustVConstraint.constant = -leftDust.frame.maxY * 0.45
            rightDustVConstraint.constant = -rightDust.frame.maxY * 0.45
            counter += 1
        case Int(fps * 3/4):
            leftDustVConstraint.constant = -leftDust.frame.maxY * 0.25
            rightDustVConstraint.constant = -rightDust.frame.maxY * 0.25
            counter += 1
        case Int(fps):
            leftDustVConstraint.constant = -leftDust.frame.maxY * 0
            rightDustVConstraint.constant = -rightDust.frame.maxY * 0
            counter = 0
        default:
            counter += 1
        }
    }
}
