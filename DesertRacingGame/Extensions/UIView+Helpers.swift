//
//  Extensions.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 21.01.2022.
//

import Foundation
import UIKit


extension UIView {
    @objc
    func reportNoninteractiveSuperview() {
        if let sup = self.superview {
            if !sup.isUserInteractionEnabled {
                print(sup, "is disabled")
            } else {
                sup.reportNoninteractiveSuperview()
            }
        } else {
            print("no disabled superviews found")
        }
    }
}

extension UIView {
    func pinToSuperview(_ insets:NSDirectionalEdgeInsets = .zero) {
        guard let sup = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: sup.topAnchor, constant: insets.top).isActive = true
        self.trailingAnchor.constraint(equalTo: sup.trailingAnchor, constant: -insets.trailing).isActive = true
        self.leadingAnchor.constraint(equalTo: sup.leadingAnchor, constant: insets.leading).isActive = true
        self.bottomAnchor.constraint(equalTo: sup.bottomAnchor, constant: -insets.bottom).isActive = true
    }
}

extension UIView {
    @objc func reportSuperviews(filtering:Bool = true) {
        var currentSuper : UIView? = self.superview
        print("reporting on \(self)\n")
        while let ancestor = currentSuper {
            let ok = ancestor.bounds.contains(ancestor.convert(self.frame, from: self.superview))
            let report = "it is \(ok ? "inside" : "OUTSIDE") \(ancestor)\n"
            if !filtering || !ok { print(report) }
            currentSuper = ancestor.superview
        }
    }
}
