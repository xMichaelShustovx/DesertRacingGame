//
//  Constants.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 22.02.2022.
//

import QuartzCore
import UIKit


enum Gradients {
    static func setMenuBackgroundGradient(_ view: UIView) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "gameOrangeLight")?.cgColor, UIColor(named: "gameOrange")?.cgColor, UIColor(named: "gameOrange")?.cgColor ,UIColor(named: "gameGray")?.cgColor]
        gradient.locations = [0, 0.25, 0.75, 1]
        view.layer.insertSublayer(gradient, at: 0)
    }
}
