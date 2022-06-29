import Foundation
import SpriteKit
import UIKit
import WWDC23ResourcesSwiftPackage
//import Ship_Destroyer_Sources

public class GameViewController: UIViewController {
    public var game: GameScene!
    //MARK: - Variables
    var isFireReady = false
    let timeLeftShapeLayer = CAShapeLayer()
    var timeLeft: TimeInterval = 3
    var endTime: Date?
    var timer = Timer()
    var timer1 = Timer()
    var pressedNextLvl2 = false
    var finishButton: UIButton!
    var healthNum = 120.0
    var isStar1 = false
    var isStar2 = false
    var isStar3 = false
    var isStar4 = false
    var isStar5 = false
    var levelOn = 1
    let LevelPositions = levelLocations()
    let strokeIt = CABasicAnimation(keyPath: "strokeEnd")
    var updateTimeOne = 0
    //MARK: - IBOutlets
    var star1: UIImageView!
    var star2: UIImageView!
    var star3: UIImageView!
    var star4: UIImageView!
    var star5: UIImageView!
    var shipDestroyedLabel: UILabel!
    var shipDestroyed:UIImageView!
    var healthBar: UIProgressView!
    var armourBar: UIProgressView!
    var gameTimeLabel: UILabel!
    var endView: UIVisualEffectView!
    var mainStackView: UIStackView!
    var passOrFail: UILabel!
    //MARK: - IBOutlets EndView
    var endStar1: UIImageView!
    var endStar2: UIImageView!
    var endStar3: UIImageView!
    var endStar4: UIImageView!
    var endStar5: UIImageView!
    var timeImage: UIImageView!
    var endShipsDestroyedImage: UIImageView!
    var timeLabel: UILabel!
    var endShipDestroyedLabel: UILabel!
    var nextLevel: UIButton!
    //MARK: - making buttons
    
    func setUpView() {
        view.frame = CGRect(x: 0.0, y: 0.0, width: 900, height: 600)
        setUpEndViewLayout()
        setUpMainStackLayout()
    }
    
    func setUpEndViewLayout() {
        let effect1 = UIBlurEffect(style: .regular)
        let newFrame = view.bounds
        endView = UIVisualEffectView(frame: newFrame)
        endView.effect = effect1
        let frame1 = CGRect(x: view.center.x/2, y: 0, width: 900, height: 500)
        let endMainStackView = UIStackView(frame: frame1)
        endMainStackView.axis = .vertical
        endMainStackView.spacing = 10
        endMainStackView.alignment = .top
        endMainStackView.distribution = .equalCentering
        endView.contentView.addSubview(endMainStackView)
        view.addSubview(endView)
        view.bringSubviewToFront(endView)
        endView.bringSubviewToFront(endMainStackView)
        passOrFail = UILabel()
        passOrFail.font = UIFont(name: "ChalkboardSE-Regular", size: 25.0)
        endMainStackView.addArrangedSubview(passOrFail)
        
        let starStackView = UIStackView()
        starStackView.axis = .horizontal
        endStar1 = UIImageView()
        endStar2 = UIImageView()
        endStar3 = UIImageView()
        endStar4 = UIImageView()
        endStar5 = UIImageView()
        starStackView.spacing = 10
        starStackView.addArrangedSubview(endStar1)
        starStackView.addArrangedSubview(endStar2)
        starStackView.addArrangedSubview(endStar3)
        starStackView.addArrangedSubview(endStar4)
        starStackView.addArrangedSubview(endStar5)
        endMainStackView.addArrangedSubview(starStackView)
        
        let infoStackView = UIStackView()
        infoStackView.axis = .horizontal
        infoStackView.alignment = .center
        infoStackView.spacing = 30
        
        
        let gameTimeStackView = UIStackView()
        gameTimeStackView.spacing = 5
        gameTimeStackView.axis = .vertical
        
        timeLabel = UILabel()
        timeLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35.0)
        timeImage = UIImageView()
        gameTimeStackView.addArrangedSubview(timeImage)
        gameTimeStackView.addArrangedSubview(timeLabel)
        
        let shipDestroyedStackView = UIStackView()
        shipDestroyedStackView.spacing = 10
        shipDestroyedStackView.axis = .vertical
        
        endShipsDestroyedImage = UIImageView()
        endShipDestroyedLabel = UILabel()
        endShipDestroyedLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35.0)
        shipDestroyedStackView.addArrangedSubview(endShipsDestroyedImage)
        shipDestroyedStackView.addArrangedSubview(endShipDestroyedLabel)
        
        infoStackView.addArrangedSubview(gameTimeStackView)
        infoStackView.addArrangedSubview(shipDestroyedStackView)
        
        endMainStackView.addArrangedSubview(infoStackView)
        
        nextLevel = UIButton()
        nextLevel.setTitle("Next", for: .normal)
        nextLevel.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 40.0)
        nextLevel.setTitleColor(.blue, for: .normal)
        
        finishButton = UIButton()
        finishButton.setTitle("Finish", for: .normal)
        finishButton.titleLabel?.font = UIFont(name: "ChalkboardSE-Bold", size: 40.0)
        finishButton.setTitleColor(.blue, for: .normal)
        finishButton.addTarget(self, action: #selector(finishEarly), for: .touchUpInside)
        
        nextLevel.addTarget(self, action: #selector(nextLevelAct), for: .touchUpInside)
        
        let buttonStackView = UIStackView()
        buttonStackView.spacing = 20
        buttonStackView.axis = .horizontal
        buttonStackView.addArrangedSubview(nextLevel)
        buttonStackView.addArrangedSubview(finishButton)
        
        endMainStackView.addArrangedSubview(buttonStackView)
        endStar1.translatesAutoresizingMaskIntoConstraints = false
        endStar2.translatesAutoresizingMaskIntoConstraints = false
        endStar3.translatesAutoresizingMaskIntoConstraints = false
        endStar4.translatesAutoresizingMaskIntoConstraints = false
        endStar5.translatesAutoresizingMaskIntoConstraints = false
        endStar1.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endStar2.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endStar3.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endStar4.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endStar5.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endStar1.widthAnchor.constraint(equalToConstant: 60).isActive = true
        endStar2.widthAnchor.constraint(equalToConstant: 60).isActive = true
        endStar3.widthAnchor.constraint(equalToConstant: 60).isActive = true
        endStar4.widthAnchor.constraint(equalToConstant: 60).isActive = true
        endStar5.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        timeImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        endShipsDestroyedImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endShipsDestroyedImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        timeLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        timeLabel.lineBreakMode = .byClipping
        timeLabel.numberOfLines = 2
        timeLabel.textAlignment = .center
        timeLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        endShipDestroyedLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        endShipDestroyedLabel.textAlignment = .center
        passOrFail.font = UIFont(name: "ChalkboardSE-Bold", size: 25.0)
        passOrFail.numberOfLines = 0
        passOrFail.preferredMaxLayoutWidth = 600
        passOrFail.heightAnchor.constraint(equalToConstant: 260).isActive = true
        
        
    }
    
    func setUpMainStackLayout() {
        mainStackView = UIStackView()
        gameTimeLabel = UILabel()
        gameTimeLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35.0)
        
        mainStackView.spacing = 10
        
        star1 = UIImageView()
        star2 = UIImageView()
        star3 = UIImageView()
        star4 = UIImageView()
        star5 = UIImageView()
    
        shipDestroyedLabel = UILabel()
        shipDestroyedLabel.font = UIFont(name: "ChalkboardSE-Bold", size: 35.0)
        
        shipDestroyed = UIImageView()
        healthBar = UIProgressView()
        armourBar = UIProgressView()
        healthBar.progress = 100.0
        healthBar.progressTintColor = .green
        armourBar.progress = 100.0
        armourBar.progressTintColor = .systemGray
        
        
        mainStackView.axis = .horizontal
        mainStackView.alignment = .center
        mainStackView.addArrangedSubview(gameTimeLabel)
        mainStackView.addArrangedSubview(star1)
        mainStackView.addArrangedSubview(star2)
        mainStackView.addArrangedSubview(star3)
        mainStackView.addArrangedSubview(star4)
        mainStackView.addArrangedSubview(star5)

        let shipStackView = UIStackView()
        shipStackView.axis = .horizontal
        shipStackView.spacing = 10
        shipStackView.addArrangedSubview(shipDestroyed)
        shipStackView.addArrangedSubview(shipDestroyedLabel)
        mainStackView.addArrangedSubview(shipStackView)
        let progressBarStackView = UIStackView()
        progressBarStackView.alignment = .center
        progressBarStackView.axis = .vertical
        progressBarStackView.spacing = 25
        progressBarStackView.addArrangedSubview(healthBar)
        progressBarStackView.addArrangedSubview(armourBar)
        mainStackView.addArrangedSubview(progressBarStackView)
        view.addSubview(mainStackView)
        view.bringSubviewToFront(mainStackView)
        
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        star1.translatesAutoresizingMaskIntoConstraints = false
        star2.translatesAutoresizingMaskIntoConstraints = false
        star3.translatesAutoresizingMaskIntoConstraints = false
        star4.translatesAutoresizingMaskIntoConstraints = false
        star5.translatesAutoresizingMaskIntoConstraints = false
        star1.heightAnchor.constraint(equalToConstant: 45).isActive = true
        star1.widthAnchor.constraint(equalToConstant: 45).isActive = true
        star2.heightAnchor.constraint(equalToConstant: 45).isActive = true
        star2.widthAnchor.constraint(equalToConstant: 45).isActive = true
        star3.heightAnchor.constraint(equalToConstant: 45).isActive = true
        star3.widthAnchor.constraint(equalToConstant: 45).isActive = true
        star4.heightAnchor.constraint(equalToConstant: 45).isActive = true
        star4.widthAnchor.constraint(equalToConstant: 45).isActive = true
        star5.heightAnchor.constraint(equalToConstant: 45).isActive = true
        star5.widthAnchor.constraint(equalToConstant: 45).isActive = true
        shipDestroyed.translatesAutoresizingMaskIntoConstraints = false
        shipDestroyed.heightAnchor.constraint(equalToConstant: 45).isActive = true
        shipDestroyed.widthAnchor.constraint(equalToConstant: 45).isActive = true
        healthBar.translatesAutoresizingMaskIntoConstraints = false
        healthBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        healthBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        armourBar.widthAnchor.constraint(equalToConstant: 150).isActive = true
        armourBar.translatesAutoresizingMaskIntoConstraints = false
        armourBar.heightAnchor.constraint(equalToConstant: 10).isActive = true
        startGame()
        
    }
    //MARK: - @objc buttons
    @objc func fireButtonAct() {
        if isFireReady {
            game?.fireButton()
            resumeAnimation()
            timeLeft = loadingTime()
            endTime = Date().addingTimeInterval(timeLeft)
        }
    }
    //MARK: - IBActions EndView
    @objc func finishEarly() {
        endView.isHidden = false
        nextLevel.isHidden = true
        finishButton.isHidden = true
        endShipDestroyedLabel.isHidden = true
        endShipsDestroyedImage.isHidden = true
        timeImage.isHidden = true
        timeLabel.isHidden = true
        endStar1.isHidden = true
        endStar2.isHidden = true
        endStar3.isHidden = true
        endStar4.isHidden = true
        endStar5.isHidden = true
        passOrFail.text = "Thanks captain for playing\nShip Destroyer! I hope you \nhad fun. Have a great rest \nof your day!\n-Bhavin Patel"
        mainStackView.isHidden = true
    }
    @objc func nextLevelAct() {
        if pressedNextLvl2 {
            endView.isHidden = false
            nextLevel.isHidden = true
            finishButton.isHidden = true
            endShipDestroyedLabel.isHidden = true
            endShipsDestroyedImage.isHidden = true
            timeImage.isHidden = true
            timeLabel.isHidden = true
            endStar1.isHidden = true
            endStar2.isHidden = true
            endStar3.isHidden = true
            endStar4.isHidden = true
            endStar5.isHidden = true
            passOrFail.text = "Thanks captain for playing\nShip Destroyer! I hope you \nhad fun. Have a great rest \nof your day!\n-Bhavin Patel"
            mainStackView.isHidden = true
        } else {
            game?.removeAllChildren()
            game?.removeAllActions()
            game?.removeFromParent()
            levelOn += 1
            goToGameScene()
            star1.image = UIImage(named: "emptyStar")
            star2.image = UIImage(named: "emptyStar")
            star3.image = UIImage(named: "emptyStar")
            star4.image = UIImage(named: "emptyStar")
            star5.image = UIImage(named: "emptyStar")
            endView.isHidden = true
            mainStackView.isHidden = false
            gameTimeLabel.text = "0s"
            resumeAnimation()
            updateTimeOne = 0
            isStar1 = false
            isStar2 = false
            isStar3 = false
            isStar4 = false
            isStar5 = false
            isFireReady = false
            isEndHoleAdded = false
            resumeAnimation()
        }
    }
    //MARK: - @objc
    
    @objc func updateCounting() {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        let formattedString = formatter.string(from: TimeInterval(game!.gameTime))!
        gameTimeLabel.text = formattedString
        let current = (Double)((game?.getShipHealth())!)/healthNum
        let current1 = (Double)(game!.totalArmour)/50.0
        healthBar.setProgress(Float(current), animated: true)
        armourBar.setProgress(Float(current1), animated: true)
        checkHowManyStarsNeedFill()
        shipDestroyedLabel.text = "=\(game?.totalShipsDestroyed ?? 0)"
        if game.getisGameOver() {
            endGame1()
        }
        
    }
    @objc func updateTime() {
        if timeLeft > 0 {
            game.fireLabel.text = "Reloading..."
            timeLeft = endTime?.timeIntervalSinceNow ?? 0
            isFireReady = false
            updateTimeOne = 0
        } else {
            isFireReady = true
            game.fireLabel.text = "Fire!!"
            if updateTimeOne == 0 {
                pauseAnimation()
            }
            updateTimeOne = 1
        }
        
    }
    
    //MARK: - Ending game
    func endGame1() {
        timer.invalidate()
        timer1.invalidate()
        pauseAnimation()
        mainStackView.isHidden = true
        game?.isPaused = true
        game?.view1.removeFromParent()
        setUpEndView()
        endView.isHidden = false
    }
    func setUpEndView() {
        view.bringSubviewToFront(endView)
        passOrFail.isHidden = false
        let shipsDestroyed = game?.totalShipsDestroyed
        let time = game.gameTime
        let totalStarsCollected = game?.howManyStarsCollected
        let whatHappen = game?.howGameOver
        if whatHappen == "health" {
            if !pressedNextLvl2 {
                passOrFail.text = "Mission Failed: \nWell Captain, it was not the outcome \nwe wanted but that is alright I have \nanother mission for you! \nPress Next to start"
            } else {
                passOrFail.text = "Mission Failed: \nWell that is it for today:( \nPress Next"
            }
            passOrFail.textColor = .red
            
        } else {
            if !pressedNextLvl2 {
                passOrFail.text = "Nice job Captain! \nGet ready for round 2!\nPress Next to start"
            } else {
                passOrFail.text = "Nice job Captain! \nYou completed this mission! \nPress Next"
            }
            passOrFail.textColor = .blue
        }
        
        
        
        if time > 90 && !pressedNextLvl2 {
            finishButton.isHidden = false
            if whatHappen == "health" {
                passOrFail.text = "Mission Failed: \nWell Captain if you have time\npress \"Next\", or if you have to go\npress \"Finish\""
                passOrFail.textColor = .red
                
            } else {
                passOrFail.text = "Nice Job: \nWell Captain if you have time\npress\"Next\", or if you have to go\npress \"Finish\""
                passOrFail.textColor = .blue
            }
        } else {
            finishButton.isHidden = true
        }
        
        
        //passOrFail.numberOfLines = 0
        nextLevel.isHidden = false
        endStar1.image = UIImage(named: "emptyStar")
        endStar2.image = UIImage(named: "emptyStar")
        endStar3.image = UIImage(named: "emptyStar")
        endStar4.image = UIImage(named: "emptyStar")
        endStar5.image = UIImage(named: "emptyStar")
        if totalStarsCollected! >= 1 {
            endStar1.image = UIImage(named: "star")
        }
        if totalStarsCollected! >= 2 {
            endStar2.image = UIImage(named: "star")
        }
        if totalStarsCollected! >= 3 {
            endStar3.image = UIImage(named: "star")
        }
        if totalStarsCollected! >= 4 {
            endStar4.image = UIImage(named: "star")
        }
        if totalStarsCollected == 5 {
            endStar5.image = UIImage(named: "star")
        }
        timeImage.image = UIImage(named: "stopwatch")
        endShipsDestroyedImage.contentMode = .scaleAspectFit
        endShipsDestroyedImage.image = UIImage(named: "destroyedBoat")
        timeLabel.text = gameTimeLabel.text
        endShipDestroyedLabel.text = "\(shipsDestroyed ?? 0)"
        isStar1 = false
        isStar2 = false
        isStar3 = false
        isStar4 = false
        isStar5 = false
    }
    //MARK: - override
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MusicPlayer.shared.startBackgroundMusic()
    }
    public override func viewWillDisappear(_ animated: Bool) {
        MusicPlayer.shared.stopBackgroundMusic()
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        view.isUserInteractionEnabled = true
    }
    //MARK: - Checking Stars
    var isEndHoleAdded = false
    func checkHowManyStarsNeedFill() {
        
        let totalStars = game?.howManyStarsCollected
        if totalStars! >= 1 && !isEndHoleAdded {
            game.addEndHole()
            isEndHoleAdded = true
        }
        if totalStars == 1 && !isStar1 {
            star1.image = UIImage(named: "star")
            isStar1 = true
        } else if totalStars == 2 && !isStar2 {
            star1.image = UIImage(named: "star")
            star2.image = UIImage(named: "star")
            isStar2 = true
        } else if totalStars == 3 && !isStar3 {
            star1.image = UIImage(named: "star")
            star2.image = UIImage(named: "star")
            star3.image = UIImage(named: "star")
            isStar3 = true
        } else if totalStars == 4 && !isStar4 {
            star1.image = UIImage(named: "star")
            star2.image = UIImage(named: "star")
            star3.image = UIImage(named: "star")
            star4.image = UIImage(named: "star")
            isStar4 = true
        } else if totalStars == 5 && !isStar5 {
            star1.image = UIImage(named: "star")
            star2.image = UIImage(named: "star")
            star3.image = UIImage(named: "star")
            star4.image = UIImage(named: "star")
            star5.image = UIImage(named: "star")
            isStar5 = true
        }
    }
    func resetStars() {
        star1.image = UIImage(named: "emptyStar")
        star2.image = UIImage(named: "emptyStar")
        star3.image = UIImage(named: "emptyStar")
        star4.image = UIImage(named: "emptyStar")
        star5.image = UIImage(named: "emptyStar")
        isStar1 = false
        isStar2 = false
        isStar3 = false
        isStar4 = false
        isStar5 = false
        isEndHoleAdded = false
    }
    //MARK: - Animations
    func pauseAnimation(){
        let pausedTime = timeLeftShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timeLeftShapeLayer.speed = 0.0
        timeLeftShapeLayer.isHidden = true
        timeLeftShapeLayer.timeOffset = pausedTime
    }
    func resumeAnimation() {
        timeLeftShapeLayer.removeAnimation(forKey: "stroke")
        strokeIt.fromValue = 0
        strokeIt.toValue = 1
        strokeIt.repeatCount = .infinity
        timeLeft = loadingTime()
        strokeIt.duration = timeLeft
        timeLeftShapeLayer.add(strokeIt, forKey: "stroke")
        endTime = Date().addingTimeInterval(timeLeft)
        timeLeftShapeLayer.speed = 1.0
        timeLeftShapeLayer.timeOffset = 0.0
        timeLeftShapeLayer.isHidden = false
        timeLeftShapeLayer.beginTime = 0.0
    }
    func drawTimeLeftShape() {
        timeLeftShapeLayer.path = UIBezierPath(arcCenter: view.frame.origin, radius: 100, startAngle: -90.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true).cgPath
        timeLeftShapeLayer.lineWidth = 10
        timeLeftShapeLayer.strokeColor = UIColor.red.cgColor
        timeLeftShapeLayer.fillColor = UIColor.clear.cgColor
        view.layer.addSublayer(timeLeftShapeLayer)
        timeLeftShapeLayer.zPosition = 1000000000
    }
    //MARK: - Override functions
    func startGame() {
        mainStackView.isHidden = false
        passOrFail.isHidden = true
        goToGameScene()
        star1.image = UIImage(named: "emptyStar")
        star2.image = UIImage(named: "emptyStar")
        star3.image = UIImage(named: "emptyStar")
        star4.image = UIImage(named: "emptyStar")
        star5.image = UIImage(named: "emptyStar")
        endView.isHidden = true
        shipDestroyed.isHidden = false
        shipDestroyed.contentMode = .scaleAspectFit
        shipDestroyed.image = UIImage(named: "destroyedBoat")
        gameTimeLabel.text = "0s"
        shipDestroyedLabel.textColor = .black
    }
    
    //MARK: - Loading Time
    func loadingTime() -> Double {
        return 2.5
    }
    
    //MARK: - health
    func health() {
        healthNum = 120
    }
    //MARK: - Loading scene
    
    func goToGameScene() {
        let sceneView = SKView(frame: view.frame)
        let scene = GameScene(size: CGSize(width: 20000, height: 20000))
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill
            game = scene
            sceneView.isHidden = false
            sceneView.presentScene(nil)
            let levelArray = levelLocations().returningLevels(level: levelOn)
            game?.shipPositions = levelArray[0]
            game?.starPositions = levelArray[1]
            game?.healthBouyPositions = levelArray[2]
            health()
            resetStars()
            if levelOn == 2 {
                pressedNextLvl2 = true
            }
            game?.levelOn = levelOn
            game?.bouyIndustructablePositions = levelArray[3]
            game?.shipStartPos = levelArray[4]
            scene.scaleMode = .resizeFill
            sceneView.presentScene(scene, transition: .crossFade(withDuration: 0.2))
            timer1 = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
            timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            pauseAnimation()
            resumeAnimation()
            mainStackView.isHidden = false
            view.addSubview(sceneView)
            view.bringSubviewToFront(sceneView)
            view.bringSubviewToFront(mainStackView)
        
        
    }
    //MARK: - Touch/press
    public override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        var didHandleEvent = false
        for press in presses {
            guard let key = press.key else { continue }
            if game != nil {
                if !game!.isGameOver {
                    if (key.keyCode == .keyboardSpacebar) {
                        didHandleEvent = true
                        if isFireReady {
                            game?.fireButton()
                            resumeAnimation()
                            timeLeft = loadingTime()
                            endTime = Date().addingTimeInterval(timeLeft)
                        }
                        
                    }
                }
            }
        }
        if didHandleEvent == false {
            super.pressesBegan(presses, with: event)
        }
    }
    
}

extension TimeInterval {
    var time: String {
        return String(format:"%02d:%02d", Int(self/60),  Int(ceil(truncatingRemainder(dividingBy: 60))) )
    }
}
extension Int {
    var degreesToRadians : CGFloat {
        return CGFloat(self) * .pi / 180
    }
}

