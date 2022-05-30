//
//  GameViewController.swift
//  DesertRacingGame
//
//  Created by Michael Shustov on 20.01.2022.
//

import UIKit
import CoreMotion

class GameViewController: UIViewController {
    
    // MARK:  - Properties
    
    private var isGameRunning = true
    
    private let fps: Double = 60
    
    private var speed: CGFloat = 300 // 300...1000
    
    private var displayLink: CADisplayLink?
    
    private var motionManager = CMMotionManager()
    
    private lazy var animatableBackgroundVerticalConstraints = {
        return (leadingVerticalConstraint: leadingBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.minY),
                trailingVerticalConstraint: trailingBackgroundView.topAnchor.constraint(equalTo: view.topAnchor, constant: -view.bounds.maxY))
    }()
    
    private lazy var animatableObstaclesVerticalConstraints: [NSLayoutConstraint] = {
        
        var constraints = [NSLayoutConstraint]()
        
        for index in 0..<obstacles.count {
            let constraint = obstacles[index].topAnchor.constraint(equalTo: view.topAnchor, constant: obstacles[index].frame.maxX * CGFloat(index)) // check if height not 0
            constraints.append(constraint)
        }
        
        return constraints
    }()
    
    private lazy var animatableObstaclesHorizontalConstraints: [NSLayoutConstraint] = {
        
        var constraints = [NSLayoutConstraint]()
        
        for index in 0..<obstacles.count {
            let constraint = obstacles[index].leftAnchor.constraint(equalTo: view.leftAnchor, constant: view.bounds.maxX / 2)
            constraints.append(constraint)
        }
        
        return constraints
    }()
    
    private lazy var animatableCarHorizontalConstraint = carView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: carHorizontalConstant)
    private var carHorizontalConstant: CGFloat = 0
    
    private lazy var leadingBackgroundView = BackgroundView()
    
    private lazy var trailingBackgroundView = BackgroundView()
    
    private lazy var carView = CarView()
    
    private lazy var obstacles: [ObstacleView] = {
        
        var obstacleViews = [ObstacleView]()
        (1...3).forEach { _ in
            
            let view = ObstacleView()
            obstacleViews.append(view)
        }
        return obstacleViews
    }()
    
    private lazy var dustView = DustView()
    
    private lazy var gameEndView: GameEndView = {
        let view = GameEndView()
        view.restartButton.addTarget(self, action: #selector(self.restart), for: .touchUpInside)
        view.backButton.addTarget(self, action: #selector(self.backAction), for: .touchUpInside)
        return view
    }()
    
    private lazy var gameEndViewAnimatableConstraint: NSLayoutConstraint = {
        let constraint = self.gameEndView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: -150 - self.view.bounds.width / 2)
        return constraint
    }()
    
    private lazy var timerView = TimerView()
    
    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        self.startGame()
        addPanRecognizer()
    }
    
    deinit {
        print("GameVC killed")
    }
    
    // MARK: - Public Methods
    
    func startGame() {
        self.isGameRunning = true
        // CADisplayLink start
        self.displayLink = CADisplayLink(target: self, selector: #selector(timerFired))
        self.displayLink?.add(to: .current, forMode: .common)
        // Game layout setup
        self.setupBackgroundLayout()
        self.setupObstaclesLayout()
        self.setupCarLayout()
        self.setupDustLayout()
        // End Menu setup
        self.gameEndView.alpha = 0
        self.setupGameEndViewConstraints()
        // TimerView setup
        self.setupTimerView()
        self.timerView.startTimer()
        // Start playing background
        SoundManager.playBackgroundSound()
        // Start updating phone position
        self.trackPhonePosition()
        // Start updating phone acceleration
        self.trackPhoneAcceleration()
        
        self.view.layoutIfNeeded()
        self.animateEndMenu()
    }
    
    // MARK: - Private Methods
    
    @objc
    private func timerFired() {
        
        moveBackground()
        moveObstacle()
        dustView.animate(fps: fps)
        checkCrash()
        if speed < 999 {
            speed = pow(speed, 1.0002)
        }
        view.layoutIfNeeded()
    }
    
    private func moveBackground() {
        
        let verticalOffset = speed/fps
        
        let nextLeadingBackgroundOriginY = leadingBackgroundView.frame.origin.y + verticalOffset
        let nextTrailingBackgroundOriginY = trailingBackgroundView.frame.origin.y + verticalOffset
        
        if nextLeadingBackgroundOriginY > view.bounds.maxY {
            animatableBackgroundVerticalConstraints.leadingVerticalConstraint.constant = -view.bounds.maxY
        }
        
        if nextTrailingBackgroundOriginY > view.bounds.maxY {
            animatableBackgroundVerticalConstraints.trailingVerticalConstraint.constant = -view.bounds.maxY
        }
        
        animatableBackgroundVerticalConstraints.leadingVerticalConstraint.constant += verticalOffset
        animatableBackgroundVerticalConstraints.trailingVerticalConstraint.constant += verticalOffset
    }
    
    private func moveObstacle() {
        
        let verticalOffset = speed/fps
        
        for index in 0..<obstacles.count {
            
            let nextObstacleOriginY = obstacles[index].frame.origin.y + verticalOffset
            
            if nextObstacleOriginY > view.bounds.maxY {
                animatableObstaclesVerticalConstraints[index].constant = -view.bounds.maxY + obstacles[index].frame.maxX * CGFloat(index)
                animatableObstaclesHorizontalConstraints[index].constant = obstacles[index].frame.width * CGFloat(Int.random(in: 0...3))  // Tmp solution
            }
            
            animatableObstaclesVerticalConstraints[index].constant += verticalOffset
        }
    }
    
    private func checkCrash() {
        
        guard self.carView.isFlying == false else { return }
        
        obstacles.forEach{
            if carView.frame.intersects($0.frame) {
                
                self.displayLink?.invalidate()
                self.displayLink = nil
                self.timerView.stopTimer()
                self.isGameRunning = false
                self.carView.image = UIImage(named: "explosion")
                self.dustView.alpha = 0
                
                // Animate explosion
                let explosion = ExplosionView()
                explosion.center = carView.center
                explosion.frame.origin.y += carView.bounds.height / 2
                self.view.addSubview(explosion)
                
                // Play crash sound
                SoundManager.playCrashSound()
                
                // Stop updating position
                motionManager.stopAccelerometerUpdates()
                
                // Stop updating acceleration
                motionManager.stopGyroUpdates()

                // Save results
                if let menuVC = self.navigationController?.viewControllers.first as? MenuViewController {
                    if menuVC.currentUser.results != nil {
                        menuVC.currentUser.results!.append(self.timerView.time)
                        
                        // Play video if it's the best result
                        if menuVC.currentUser.results!.max() == self.timerView.time {
                            
                            self.gameEndView.showRecordLabel()
                            
                            if let videoVC = VideoManager.playNewRecordVideo() {
                                self.present(videoVC, animated: true, completion: nil)
                            }
                        }
                    }
                    else {
                        menuVC.currentUser.results = [self.timerView.time]
                    }
                }
                
                self.animateEndMenu()
            }
        }
    }
    
    private func setupBackgroundLayout() {

        [self.leadingBackgroundView, self.trailingBackgroundView].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            self.leadingBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.leadingBackgroundView.heightAnchor.constraint(equalToConstant: view.bounds.maxY + 20), // Why is there space between backgrounds (without +20)?
            self.leadingBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.animatableBackgroundVerticalConstraints.leadingVerticalConstraint,
            
            self.trailingBackgroundView.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.trailingBackgroundView.heightAnchor.constraint(equalToConstant: view.bounds.maxY + 20), // Why is there space between backgrounds (without +20)?
            self.trailingBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.animatableBackgroundVerticalConstraints.trailingVerticalConstraint
        ])
    }
    
    private func setupObstaclesLayout() {
        
        obstacles.forEach{ view.addSubview($0)}
        
        for index in 0..<obstacles.count {
            NSLayoutConstraint.activate([
                obstacles[index].widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/4),
                animatableObstaclesVerticalConstraints[index],
                animatableObstaclesHorizontalConstraints[index],
                obstacles[index].heightAnchor.constraint(equalTo: obstacles[index].widthAnchor)
            ])
        }
    }
    
    
    private func setupCarLayout() {
        
        view.addSubview(carView)
        
        NSLayoutConstraint.activate([
            carView.widthAnchor.constraint(equalToConstant: view.bounds.maxX / 5),
            carView.heightAnchor.constraint(equalToConstant: view.bounds.maxY / 6.5),
            animatableCarHorizontalConstraint,
            carView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.bounds.maxY * 0.05)
        ])
    }
    
    private func setupDustLayout() {
        
        view.addSubview(dustView)
        
        NSLayoutConstraint.activate([
            dustView.widthAnchor.constraint(equalTo: carView.widthAnchor),
            dustView.heightAnchor.constraint(equalTo: dustView.widthAnchor, multiplier: 4),
            dustView.topAnchor.constraint(equalTo: carView.bottomAnchor),
            dustView.centerXAnchor.constraint(equalTo: carView.centerXAnchor)
        ])
    }
    
    private func setupGameEndViewConstraints() {
        self.view.addSubview(self.gameEndView)
        
        NSLayoutConstraint.activate([
            gameEndView.widthAnchor.constraint(equalToConstant: 300),
            gameEndView.heightAnchor.constraint(equalToConstant: 300),
            gameEndView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.gameEndViewAnimatableConstraint
        ])
    }
    
    private func animateEndMenu() {
        self.gameEndViewAnimatableConstraint.constant = isGameRunning ? -150 - self.view.bounds.width/2 : 0
        self.gameEndView.alpha = isGameRunning ? 0 : 1
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: .curveEaseOut,
                       animations: {
            self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
    
    @objc
    private func restart() {
        self.navigationController?.popViewController(animated: false)
    }
    
    @objc
    private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupTimerView() {
        self.view.addSubview(self.timerView)
        
        NSLayoutConstraint.activate([
            self.timerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.timerView.widthAnchor.constraint(equalToConstant: 100),
            self.timerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 40),
            self.timerView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func addPanRecognizer() {
        
        let recongnizer = UIPanGestureRecognizer(target: self, action: #selector(handleRecognizer(recognizer:)))
        view.addGestureRecognizer(recongnizer)
    }
    
    @objc
    private func handleRecognizer(recognizer: UIPanGestureRecognizer) {
        
        guard isGameRunning else { return }
        
        let location = recognizer.location(in: view)
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .began:
            
            let tappedView = self.view.hitTest(location, with: nil)
            
            if tappedView != carView {
                recognizer.cancelRecognition()
                return
            }
            
            view.bringSubviewToFront(carView) // What for?
            
        case .changed:
            
            guard isGameRunning else { return }
            
            if carView.frame.maxX >= view.bounds.maxX {
                if carHorizontalConstant + translation.x < carHorizontalConstant{
                    self.animatableCarHorizontalConstraint.constant = carHorizontalConstant + translation.x
                }
            }
            else if carView.frame.minX <= view.bounds.minX {
                if carHorizontalConstant + translation.x > carHorizontalConstant{
                    self.animatableCarHorizontalConstraint.constant = carHorizontalConstant + translation.x
                }
            }
            else {
                self.animatableCarHorizontalConstraint.constant = carHorizontalConstant + translation.x
            }

        case .ended:
            carHorizontalConstant = animatableCarHorizontalConstraint.constant
            return
            
        default:
            return
        }
    }
    
    private func trackPhonePosition() {
        if motionManager.isAccelerometerAvailable {

            motionManager.accelerometerUpdateInterval = 1 / fps
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                
                guard self.isGameRunning else { return }

                if var positionChange = data?.acceleration.x {
                    
                    positionChange *= 100
                    
                    if self.carView.frame.maxX >= self.view.bounds.maxX {
                        if self.carHorizontalConstant + positionChange < self.carHorizontalConstant{
                            DispatchQueue.main.async {
                                self.animatableCarHorizontalConstraint.constant += positionChange
                            }
                        }
                    }
                    else if self.carView.frame.minX <= self.view.bounds.minX {
                        if self.carHorizontalConstant + positionChange > self.carHorizontalConstant{
                            DispatchQueue.main.async {
                                self.animatableCarHorizontalConstraint.constant += positionChange
                            }
                        }
                    }
                    else {
                        DispatchQueue.main.async {
                            self.animatableCarHorizontalConstraint.constant += positionChange
                        }
                    }
                }
            }
        }
    }
    
    private func trackPhoneAcceleration() {
        if motionManager.isGyroAvailable {
            
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { data, error in
                
                guard self.isGameRunning else { return }

                if let acceleration = data?.rotationRate.x, acceleration > 2 {
                    self.carView.animateJump()
                }
            }
        }
    }
}


