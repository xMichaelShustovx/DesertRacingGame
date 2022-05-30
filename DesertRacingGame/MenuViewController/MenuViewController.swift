//
//  MenuViewController.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 21.01.2022.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK: - Properties
    
    var gameVC: GameViewController?
    var resultsVC: ResultsViewController?
    
    var currentUser: User = {
        var user = User(name: "Rob")
        var savedResults = DataManager.fetchData(user: user)
        user.results = savedResults
        return user
    }()
    
    let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "Salsa-Regular", size: 25)
        button.layer.cornerRadius = 10
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let resultsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Results", for: .normal)
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.red, for: .highlighted)
        button.titleLabel?.font = UIFont(name: "Salsa-Regular", size: 25)
        button.layer.cornerRadius = 10
        button.setShadow()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupButton()
        
        let button = UIButton(type: .roundedRect)
              button.frame = CGRect(x: 20, y: 200, width: 100, height: 30)
              button.setTitle("Test Crash", for: [])
              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
              view.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.gameVC = nil
    }
    
    // MARK: - Private Methods
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]
          let _ = numbers[1]
      }
    
    private func setupView() {
        Gradients.setMenuBackgroundGradient(self.view)
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "gameOrangeLight")
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupButton() {
        
        [startButton, resultsButton].forEach{ self.view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            resultsButton.widthAnchor.constraint(equalToConstant: 200),
            resultsButton.heightAnchor.constraint(equalToConstant: 50),
            resultsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            resultsButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50)
        ])
        
        startButton.addTarget(self, action: #selector(startGame), for: .touchUpInside)
        resultsButton.addTarget(self, action: #selector(showResults), for: .touchUpInside)
    }
    
    @objc
    private func startGame() {
        
        self.gameVC = GameViewController()
        guard self.gameVC != nil else {return}
        navigationController?.pushViewController(gameVC!, animated: true)
    }
    
    @objc
    private func showResults() {
        let resultsVC = ResultsViewController(user: self.currentUser)
        navigationController?.pushViewController(resultsVC, animated: true)
    }
}
