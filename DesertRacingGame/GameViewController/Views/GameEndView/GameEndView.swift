//
//  GameEndView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 16.02.2022.
//

import UIKit

class GameEndView: UIView {

    // MARK: - Properties
    
    lazy var restartButton: UIButton = {
        let button = UIButton()
        button.setTitle("Restart", for: .normal)
        setupButtonUI(button: button)
        return button
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle("Back", for: .normal)
        self.setupButtonUI(button: button)
        return button
    }()
    
    lazy var newRecordLabel: UILabel = {
        let label = UILabel()
        label.text = "⭐️NEW RECORD⭐️"
        label.font = UIFont(name: "Salsa-Regular", size: 30)
        label.textColor = .white
        label.textAlignment = .center
        label.layer.opacity = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        
        self.setupUI()
        self.setupButtonsLayout()
        self.setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Game End View killed")
    }
    
    // MARK: - Public Methods
    
    func showRecordLabel() {
        self.newRecordLabel.layer.opacity = 1
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        self.backgroundColor = .orange
        self.layer.cornerRadius = 15
        self.isUserInteractionEnabled = true
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtonUI(button: UIButton) {
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "Salsa-Regular", size: 25)
        button.backgroundColor = .green
        button.layer.cornerRadius = 10
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupButtonsLayout() {
        [self.restartButton, self.backButton].forEach { self.addSubview($0) }
        
        NSLayoutConstraint.activate([
            restartButton.widthAnchor.constraint(equalToConstant: 200),
            restartButton.heightAnchor.constraint(equalToConstant: 50),
            restartButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            restartButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50),
            
            backButton.widthAnchor.constraint(equalToConstant: 200),
            backButton.heightAnchor.constraint(equalToConstant: 50),
            backButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            backButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 50)
        ])
    }
    
    private func setupLabel() {
        self.addSubview(self.newRecordLabel)
        
        NSLayoutConstraint.activate([
            newRecordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            newRecordLabel.heightAnchor.constraint(equalToConstant: 60),
            newRecordLabel.widthAnchor.constraint(equalTo: self.widthAnchor, constant: -10),
            newRecordLabel.bottomAnchor.constraint(equalTo: self.restartButton.topAnchor, constant: -10)
        ])
    }
}
