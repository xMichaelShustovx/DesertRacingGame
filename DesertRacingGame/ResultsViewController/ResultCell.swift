//
//  ResultCell.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 16.02.2022.
//

import UIKit

class ResultCell: UITableViewCell {
    
    static let identifier = "ResultCell"
    
    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont(name: "Salsa-Regular", size: 22)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.opacity = 0.9
        self.contentView.backgroundColor = .gray
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: super.topAnchor, constant: 5),
            contentView.leftAnchor.constraint(equalTo: super.leftAnchor, constant: 20),
            contentView.rightAnchor.constraint(equalTo: super.rightAnchor, constant: -20),
            contentView.bottomAnchor.constraint(equalTo: super.bottomAnchor, constant: -5)
        ])
        
        self.setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLabel() {
        self.contentView.addSubview(self.resultLabel)
        
        NSLayoutConstraint.activate([
            resultLabel.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 20),
            resultLabel.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -20),
            resultLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 5),
            resultLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5)
        ])
    }
}
