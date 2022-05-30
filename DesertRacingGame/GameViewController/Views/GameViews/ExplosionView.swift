//
//  ExplosionView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 21.03.2022.
//

import UIKit


class ExplosionView: UIView {
    
    private var pieces: [ExplosionPiece]?
    private var timer: Timer?
    private let fps: CGFloat = 60
    private var piecesFellDown: Set<ExplosionPiece> = []
    
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
        
        for i in 1...6 {
            let explosionPiece = ExplosionPiece()
            explosionPiece.image = i == 6 ? UIImage(named: "bolt1") : UIImage(named: "bolt\(Int.random(in: 2...3))")
            self.addSubview(explosionPiece)
            explosionPiece.animatedConstraintX = explosionPiece.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
            explosionPiece.animatedConstraintX?.isActive = true
            explosionPiece.animatedConstraintY = explosionPiece.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0)
            explosionPiece.animatedConstraintY?.isActive = true
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1 / fps, repeats: true, block: { _ in
            self.animateExplosion()
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ExplosionView was killed")
    }
    
    private func animateExplosion() {
        for explosionPiece in self.subviews {

            if let piece = explosionPiece as? ExplosionPiece {
                
                if let y = piece.animatedConstraintY?.constant, y <= 0 {
                    
                    piece.animatedConstraintX?.constant += piece.speed / fps * piece.direction
                    piece.animatedConstraintY?.constant = pow(piece.animatedConstraintX?.constant ?? 0, 2) - (piece.pathCoefficient)*(abs(piece.animatedConstraintX?.constant ?? 0))
                    
                    piece.rotationAngle += piece.direction * 10 / fps
                    piece.transform = CGAffineTransform(rotationAngle: piece.rotationAngle)
                }
                else {
                    piecesFellDown.insert(piece)
                }
            }
        }
        
        if piecesFellDown.count == subviews.count {
            timer?.invalidate()
            timer = nil
        }
    }
}

private class ExplosionPiece: UIImageView {
    
    var speed: CGFloat = CGFloat.random(in: 20...35)
    var animatedConstraintX: NSLayoutConstraint?
    var animatedConstraintY: NSLayoutConstraint?
    var pathCoefficient =  Double.random(in: 30...60) //Double.random(in: 10...40)
    var direction: CGFloat = {
        let rnd = Bool.random()
        return rnd ? 1 : -1
    }()
    lazy var rotationAngle: CGFloat = {
        self.direction
    }()
    
    init() {
        super.init(frame: .zero)
        
        contentMode = .scaleAspectFit
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 50),
            self.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
