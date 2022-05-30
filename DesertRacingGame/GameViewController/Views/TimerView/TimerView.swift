//
//  TimerView.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 16.02.2022.
//

import UIKit


class TimerView: UIView {

    // MARK: - Properties
    
    var timer: Timer?
    
    var time: Double = 0.0
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = String(format: "%.2f", self.time)
        label.textColor = .white
        label.font = UIFont(name: "Salsa-Regular", size: 25)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Initializers
    
    init() {
        super.init(frame: .zero)
        self.backgroundColor = .darkGray
        self.layer.opacity = 0.4
        self.layer.cornerRadius = 10
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Timer View killed")
    }
    
    // MARK: - Public Methods
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        self.timer?.invalidate()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func timerFired() {
        self.time += 0.01
        self.timeLabel.text = String(format: "%.2f", self.time)
    }
    
    private func setupLabel() {
        self.addSubview(self.timeLabel)
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            timeLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            timeLabel.heightAnchor.constraint(equalTo: self.heightAnchor, constant: -10)
        ])
    }
}
