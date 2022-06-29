//
//  GameScene.swift
//  UIKit Sample
//
//  Created by Bhavin Patel on 4/9/22.
//

import Foundation
import SpriteKit
import WWDC23ResourcesSwiftPackage
//only reason "#if os(iOS)" is here is because importing UIKit returns an error.
//Bug Report: FB9841120
import UIKit
struct Collision {
    static let hero: UInt32 = 0x1 << 0
    static let bouy: UInt32 = 0x1 << 1
    static let rect: UInt32 = 0x1 << 2
    static let missile: UInt32 = 0x1 << 4
    static let star: UInt32 = 0x1 << 8
    static let ship: UInt32 = 0x1 << 16
    static let heart: UInt32 = 0x1 << 32
}

public class GameScene: SKScene, SKPhysicsContactDelegate {
    //MARK: - Enum
    enum NodesZPosition: CGFloat {
        case background, tracks, allGameObjects, joystick, AboveAll
    }
    //MARK: - Varaibles
    var isShipActive: [Bool] = []
    var EShipHealth: [Int] = []
    var EShip: [SKSpriteNode] = []
    var isEShipDead: [Bool] = []
    var isTimerActive: [Bool] = []
    var shipSelected = 0
    var healthNum = 120
    var EShipSmoke: [SKEmitterNode] = []
    var addedSmoke = false
    var shipNum = 0
    public var hero = SKSpriteNode()
    public var levelOn = 0
    var damageAmount = 0
    let shipSmoke = SKEmitterNode(fileNamed: "continiousSmoke")
    //let shipSmoke = B
    var isDamagedE: [Bool]  = []
    var shipLaser = SKShapeNode()
    var shipZRotation: [CGFloat] = []
    var turretNum = 0
    var velocityMultiplier: CGFloat = 0.09
    var bouyNum = 0
    public var gameTime = 0
    var cam = SKCameraNode()
    public var totalArmour = 0
    var background = SKSpriteNode()
    var bouyList: [SKSpriteNode] = []
    var bouyHealth: [Int] = []
    var bouyIndustNum = 0
    var timer1 = Timer()
    var timer2 = Timer()
    var starNum = 0
    var starName: [String] = []
    public var howGameOver = ""
    public var shipStartPos: [CGPoint] = []
    public var shipHealth = 0
    public var totalShipsDestroyed = 0
    public var isGameOver = false
    var bouyNames: [String] = []
    var enemyTimers: [Timer] = []
    public var howManyStarsCollected = 0
    let healthlabel = SKLabelNode(text: "")
    var heroPosition = CGPoint()
    var contactQueue = [SKPhysicsContact]()
    var fireDeadShip:[SKEmitterNode] = []
    var isFirstLoad = true
    public var location = CGPoint()
    var newLocation = CGPoint()
    public var view1 = SKSpriteNode()
    public var isMouseContered = false
    var fgre: WWDC23ResourcesSwiftPackage!
    //MARK: - adding ships/hero
    func addEmemyShip() {
        let enemyShip = SKSpriteNode(imageNamed: "enemyBoat")
        enemyShip.name = "q\(shipNum)"
        let x = shipPositions[shipNum].x
        let y = shipPositions[shipNum].y
        let newX = (x * 60) + 30
        let newY = (y * 60)
        enemyShip.position = CGPoint(x: newX, y: newY)
        enemyShip.zPosition = NodesZPosition.allGameObjects.rawValue
        enemyShip.setScale(0.45)
        enemyShip.physicsBody = SKPhysicsBody(rectangleOf: enemyShip.size)
        enemyShip.physicsBody!.isDynamic = true
        enemyShip.physicsBody!.affectedByGravity = false
        enemyShip.physicsBody!.categoryBitMask = enemyShip.physicsBody!.categoryBitMask
        enemyShip.physicsBody!.contactTestBitMask = 0x1 << 2
        enemyShip.physicsBody!.collisionBitMask = Collision.ship
        addChild(enemyShip)
        EShipSmoke.append(SKEmitterNode(fileNamed: "continiousSmoke.sks")!)
        let timer123 = Timer()
        isDamagedE.append(false)
        enemyTimers.append(timer123)
        isShipActive.append(true)
        isEShipDead.append(false)
        EShipHealth.append(50)
        shipZRotation.append(0)
        fgre = WWDC23ResourcesSwiftPackage()        //fireDeadShip.append(fgre.fire!)
        fireDeadShip.append(SKEmitterNode(fileNamed: "fire.sks")!)
        isTimerActive.append(false)
        EShip.append(enemyShip)
        shipNum += 1
    }
    public func hero1() {
        hero = SKSpriteNode(imageNamed: "boat")
        hero.name = "hero"
        let x = shipStartPos[0].x
        let y = shipStartPos[0].y
        let newX = (x * 60) + 30
        let newY = (y * 60)
        hero.position = CGPoint(x: newX, y: newY)
        hero.zPosition = NodesZPosition.allGameObjects.rawValue
        hero.setScale(0.45)
        hero.physicsBody = SKPhysicsBody(rectangleOf: hero.frame.size)
        hero.physicsBody!.isDynamic = true
        hero.physicsBody!.affectedByGravity = false
        hero.physicsBody!.restitution = 0.0
        hero.physicsBody!.categoryBitMask = hero.physicsBody!.categoryBitMask
        hero.physicsBody!.contactTestBitMask = 0x1 << 2
        hero.physicsBody!.collisionBitMask = Collision.hero
        
    }
    //MARK: - Moving enemy Ships
    func isEachShipMovable() {
        for x in 0..<EShip.count {
            if !isEShipDead[x] {
                if isShipActive[x] {
                    if !isTimerActive[x] {
                        shipIsMovable(ship: EShip[x], timer: x)
                    }
                }
            }
        }
    }
    func shipIsMovable(ship: SKSpriteNode, timer: Int) {
        let randomTimer = Double.random(in: 4.0..<8.5)
        enemyTimers[timer] = Timer.scheduledTimer(timeInterval: randomTimer, target: self, selector: #selector(fireenemyBullet(sender: )), userInfo: timer, repeats: false)
        isTimerActive[timer] = true
    }
    func fireShipFirst(ship: SKSpriteNode, x: Int) {
        let Pi = CGFloat(Double.pi)
        let DegreesToRadians = Pi / 180
        let shipPos = ship.position
        let deltaX = self.hero.position.x - shipPos.x
        let deltaY = self.hero.position.y - shipPos.y
        let angle1 = atan2(deltaY, deltaX)
        let fAngle = (angle1 + 90 * DegreesToRadians) - .pi
        let randomNum = CGFloat.random(in: (-.pi/9)..<(.pi/9))
        ship.zRotation = fAngle + randomNum
        let sound = SKAction.playSoundFileNamed("shipFireBullet.wav", waitForCompletion: false)
        sound.speed = 1.2
        run(sound)
        
        let missile = SKSpriteNode(imageNamed: "friendlyShipMissile")
        missile.name = "tm"
        missile.zRotation = ship.zRotation
        missile.setScale(0.35)
        missile.zPosition = NodesZPosition.allGameObjects.rawValue
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.size)
        missile.physicsBody!.isDynamic = true
        missile.physicsBody!.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = missile.physicsBody!.categoryBitMask
        missile.physicsBody!.contactTestBitMask = 0x1 << 4
        missile.physicsBody!.collisionBitMask = Collision.missile
        addChild(missile)
        let angle = ship.zRotation + CGFloat(Double.pi/2)
        let vector = CGVector(dx: cos(angle)*100, dy: sin(angle)*100)
        let xPos = ship.position.x + vector.dx
        let yPos = ship.position.y + vector.dy
        let position1 = CGPoint(x: xPos, y: yPos)
        missile.position = position1
        let action = SKAction.moveBy(x: vector.dx, y: vector.dy, duration: 0.27)
        let repeat1 = SKAction.repeatForever(action)
        missile.run(repeat1)
        if let explosion = SKEmitterNode(fileNamed: "FireParticles") {
            explosion.position = ship.position
            explosion.setScale(0.30)
            explosion.zPosition = NodesZPosition.joystick.rawValue
            explosion.zRotation = ship.zRotation
            addChild(explosion)
        }
        ship.removeAllActions()
        let random = Int.random(in: 0..<8)
        var vector1 = CGVector()
        let squareDivTwo = (sqrt(2)/2) * 100
        if random == 0 {
            vector1 = CGVector(dx: 0, dy: 100)
            EShip[x].zRotation = 0
        } else if random == 1 {
            vector1 = CGVector(dx: -squareDivTwo, dy: squareDivTwo)
            EShip[x].zRotation = .pi/4
        } else if random == 2 {
            vector1 = CGVector(dx: -100, dy: 0)
            EShip[x].zRotation = .pi/2
        } else if random == 3 {
            vector1 = CGVector(dx: -squareDivTwo, dy: -squareDivTwo)
            EShip[x].zRotation = (.pi/4)*3
        } else if random == 4 {
            vector1 = CGVector(dx: 0, dy: -100)
            EShip[x].zRotation = .pi
        } else if random == 5 {
            vector1 = CGVector(dx: squareDivTwo, dy: -squareDivTwo)
            EShip[x].zRotation = -(.pi/4)*3
        } else if random == 6 {
            vector1 = CGVector(dx: 100, dy: 0)
            EShip[x].zRotation = -.pi/2
        } else if random == 7 {
            vector1 = CGVector(dx: squareDivTwo, dy: squareDivTwo)
            EShip[x].zRotation = -.pi/4
        }
        isTimerActive[x] = false
        let move1 = SKAction.move(by: vector1, duration: 1.0)
        let runMoveForever = SKAction.repeatForever(move1)
        ship.run(runMoveForever)
        shipZRotation[x] = ship.zRotation
    }
    
    func fireShipFirstMove(ship: SKSpriteNode, x: Int) {
        ship.removeAllActions()
        let random = Int.random(in: 0..<8)
        var vector1 = CGVector()
        let squareDivTwo = (sqrt(2)/2) * 100
        if random == 0 {
            vector1 = CGVector(dx: 0, dy: 100)
            EShip[x].zRotation = 0
        } else if random == 1 {
            vector1 = CGVector(dx: -squareDivTwo, dy: squareDivTwo)
            EShip[x].zRotation = .pi/4
        } else if random == 2 {
            vector1 = CGVector(dx: -100, dy: 0)
            EShip[x].zRotation = .pi/2
        } else if random == 3 {
            vector1 = CGVector(dx: -squareDivTwo, dy: -squareDivTwo)
            EShip[x].zRotation = (.pi/4)*3
        } else if random == 4 {
            vector1 = CGVector(dx: 0, dy: -100)
            EShip[x].zRotation = .pi
        } else if random == 5 {
            vector1 = CGVector(dx: squareDivTwo, dy: -squareDivTwo)
            EShip[x].zRotation = -(.pi/4)*3
        } else if random == 6 {
            vector1 = CGVector(dx: 100, dy: 0)
            EShip[x].zRotation = -.pi/2
        } else if random == 7 {
            vector1 = CGVector(dx: squareDivTwo, dy: squareDivTwo)
            EShip[x].zRotation = -.pi/4
        }
        let move1 = SKAction.move(by: vector1, duration: 0.6)
        let runMoveForever = SKAction.repeatForever(move1)
        ship.run(runMoveForever)
        shipZRotation[x] = ship.zRotation
    }
    @objc func fireenemyBullet(sender: Timer) {
        let x = sender.userInfo as? Int
        let ship = EShip[x!]
        let Pi = CGFloat(Double.pi)
        let DegreesToRadians = Pi / 180
        let shipPos = ship.position
        let deltaX = self.hero.position.x - shipPos.x
        let deltaY = self.hero.position.y - shipPos.y
        let angle1 = atan2(deltaY, deltaX)
        let fAngle = (angle1 + 90 * DegreesToRadians) - .pi
        let randomNum = CGFloat.random(in: (-.pi/9)..<(.pi/9))
        self.EShip[x!].zRotation = fAngle + randomNum
        let sound = SKAction.playSoundFileNamed("shipFireBullet.wav", waitForCompletion: false)
        sound.speed = 1.2
        run(sound)
        let missile = SKSpriteNode(imageNamed: "friendlyShipMissile")
        missile.name = "tm"
        missile.zRotation = ship.zRotation
        missile.setScale(0.35)
        missile.zPosition = NodesZPosition.allGameObjects.rawValue
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.frame.size)
        missile.physicsBody!.isDynamic = true
        missile.physicsBody!.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = missile.physicsBody!.categoryBitMask
        missile.physicsBody!.contactTestBitMask = 0x1 << 4
        missile.physicsBody!.collisionBitMask = Collision.missile
        addChild(missile)
        let angle = ship.zRotation + CGFloat(Double.pi/2)
        let vector = CGVector(dx: cos(angle)*100, dy: sin(angle)*100)
        let xPos = ship.position.x + vector.dx
        let yPos = ship.position.y + vector.dy
        let position1 = CGPoint(x: xPos, y: yPos)
        missile.position = position1
        let action = SKAction.moveBy(x: vector.dx, y: vector.dy, duration: 0.27)
        let repeat1 = SKAction.repeatForever(action)
        missile.run(repeat1)
        if let explosion = SKEmitterNode(fileNamed: "FireParticles") {
            explosion.position = ship.position
            explosion.setScale(0.30)
            explosion.zPosition = NodesZPosition.joystick.rawValue
            explosion.zRotation = ship.zRotation
            addChild(explosion)
        }
        EShip[x!].removeAllActions()
        let random = Int.random(in: 0..<8)
        var vector1 = CGVector()
        let squareDivTwo = (sqrt(2)/2) * 100
        if random == 0 {
            vector1 = CGVector(dx: 0, dy: 100)
            EShip[x!].zRotation = 0
        } else if random == 1 {
            vector1 = CGVector(dx: -squareDivTwo, dy: squareDivTwo)
            EShip[x!].zRotation = .pi/4
        } else if random == 2 {
            vector1 = CGVector(dx: -100, dy: 0)
            EShip[x!].zRotation = .pi/2
        } else if random == 3 {
            vector1 = CGVector(dx: -squareDivTwo, dy: -squareDivTwo)
            EShip[x!].zRotation = (.pi/4)*3
        } else if random == 4 {
            vector1 = CGVector(dx: 0, dy: -100)
            EShip[x!].zRotation = .pi
        } else if random == 5 {
            vector1 = CGVector(dx: squareDivTwo, dy: -squareDivTwo)
            EShip[x!].zRotation = -(.pi/4)*3
        } else if random == 6 {
            vector1 = CGVector(dx: 100, dy: 0)
            EShip[x!].zRotation = -.pi/2
        } else if random == 7 {
            vector1 = CGVector(dx: squareDivTwo, dy: squareDivTwo)
            EShip[x!].zRotation = -.pi/4
        }
        let move1 = SKAction.move(by: vector1, duration: 0.6)
        let runMoveForever = SKAction.repeatForever(move1)
        EShip[x!].run(runMoveForever)
        shipZRotation[x!] = ship.zRotation
        isTimerActive[x!] = false
    }
    //MARK: - Adding other Nodes
    func addBackground() -> SKSpriteNode {
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint.zero
        background.setScale(2)
        background.zPosition = NodesZPosition.background.rawValue
        return background
    }
    func addNondustructionBouy() {
        let bouy = SKSpriteNode(imageNamed: "indestructibleBouy")
        
        bouy.physicsBody = SKPhysicsBody(rectangleOf: bouy.frame.size)
        bouy.physicsBody!.isDynamic = false
        bouy.physicsBody!.affectedByGravity = false
        bouy.physicsBody!.restitution = 0.0
        bouy.physicsBody!.categoryBitMask = bouy.physicsBody!.categoryBitMask
        bouy.physicsBody!.contactTestBitMask = 0x1 << 4
        bouy.physicsBody!.collisionBitMask = Collision.bouy
        bouy.zPosition = NodesZPosition.allGameObjects.rawValue
        bouy.name = "i\(bouyIndustNum)"
        if bouyIndustNum > 189 {
            let x = bouyIndustructablePositions[bouyIndustNum].x
            let y = bouyIndustructablePositions[bouyIndustNum].y
            let newX = (x * 60) + 30
            let newY = (y * 60)
            bouy.position = CGPoint(x: newX, y: newY)
        } else {
            let point = bouyIndustructablePositions[bouyIndustNum]
            let newPointX = point.x * 2
            let newPointY = point.y * 2
            bouy.position = CGPoint(x: newPointX, y: newPointY)
        }
        bouyIndustNum += 1
        bouy.setScale(0.45)
        addChild(bouy)
    }
    func addShipTracks(ship: SKSpriteNode) {
        let track = SKSpriteNode(imageNamed: "shipTrack")
        track.zPosition = NodesZPosition.tracks.rawValue
        track.position = ship.position
        track.zRotation = ship.zRotation
        track.setScale(0.30)
        addChild(track)
        let trackAction = SKAction.sequence([SKAction.wait(forDuration: 1.75),SKAction.removeFromParent()])
        track.run(SKAction.group([trackAction]))
    }
    func addBouy() {
        let bouy = SKSpriteNode(imageNamed: "threeLiveBouy")
        bouy.physicsBody = SKPhysicsBody(rectangleOf: bouy.frame.size)
        bouy.zPosition = NodesZPosition.allGameObjects.rawValue
        bouy.name = "c\(bouyNum)"
        let x = healthBouyPositions[bouyNum].x
        let y = healthBouyPositions[bouyNum].y
        let newX = (x * 60) + 30
        let newY = (y * 60)
        bouy.position = CGPoint(x: newX, y: newY)
        
        bouyNum += 1
        bouy.setScale(0.45)
        bouyNames.append(bouy.name ?? "no Name")
        bouy.physicsBody!.isDynamic = false
        bouy.physicsBody!.affectedByGravity = false
        bouy.physicsBody!.restitution = 0.0
        bouy.physicsBody!.categoryBitMask = bouy.physicsBody!.categoryBitMask
        bouy.physicsBody!.contactTestBitMask = 0x1 << 4
        bouy.physicsBody!.collisionBitMask = Collision.bouy
        addChild(bouy)
        bouyList.append(bouy)
        bouyHealth.append(3)
    }
    public let fireLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
    public func addFireLabel() {
        fireLabel.zPosition = 20
        fireLabel.fontSize = 20.0
        fireLabel.fontColor = .red
        fireLabel.position.y = 100
        fireLabel.text = "Reloading..."
        cam.addChild(fireLabel)
    }
    func addHeart(pos: CGPoint) {
        let heart = SKSpriteNode(imageNamed: "armour")
        heart.physicsBody = SKPhysicsBody(rectangleOf: heart.frame.size)
        heart.zPosition = NodesZPosition.AboveAll.rawValue
        heart.name = "z\(starNum)"
        heart.position = pos
        heart.setScale(0.28)
        heart.physicsBody!.isDynamic = false
        heart.physicsBody!.affectedByGravity = false
        heart.physicsBody!.categoryBitMask = heart.physicsBody!.categoryBitMask
        heart.physicsBody!.contactTestBitMask = 0x1 << 4
        heart.physicsBody!.collisionBitMask = Collision.heart
        addChild(heart)
    }
    func addStar() {
        let star = SKSpriteNode(imageNamed: "star")
        star.physicsBody = SKPhysicsBody(rectangleOf: star.frame.size)
        star.zPosition = NodesZPosition.allGameObjects.rawValue + 1
        star.name = "s\(starNum)"
        starName.append(star.name ?? "s")
        let x = starPositions[starNum].x
        let y = starPositions[starNum].y
        let newX = (x * 60) + 30
        let newY = (y * 60)
        star.position = CGPoint(x: newX, y: newY)
        star.isHidden = false
        starNum += 1
        star.setScale(0.30)
        let starOneRot = SKAction.rotate(byAngle: .pi , duration: 2.5)
        let starInfiniteRot = SKAction.repeatForever(starOneRot)
        star.run(starInfiniteRot)
        star.physicsBody!.isDynamic = false
        star.physicsBody!.affectedByGravity = false
        star.physicsBody!.categoryBitMask = star.physicsBody!.categoryBitMask
        star.physicsBody!.contactTestBitMask = 0x1 << 4
        star.physicsBody!.collisionBitMask = Collision.star
        addChild(star)
        
    }
    public func addEndHole() {
        let endHole = SKSpriteNode(imageNamed: "finishLevel")
        endHole.name = "endHole"
        endHole.position = shipStartPos[1]
        let x = shipStartPos[1].x
        let y = shipStartPos[1].y
        let newX = (x * 60) + 30
        let newY = (y * 60)
        endHole.position = CGPoint(x: newX, y: newY)
        
        endHole.physicsBody = SKPhysicsBody(rectangleOf: endHole.frame.size)
        endHole.zPosition = NodesZPosition.allGameObjects.rawValue
        endHole.setScale(0.30)
        endHole.physicsBody!.isDynamic = false
        endHole.physicsBody!.affectedByGravity = false
        endHole.physicsBody!.categoryBitMask = endHole.physicsBody!.categoryBitMask
        endHole.physicsBody!.contactTestBitMask = 0x1 << 4
        endHole.physicsBody!.collisionBitMask = Collision.star
        addChild(endHole)
        let rotate1 = SKAction.rotate(byAngle: .pi, duration: 0.5)
        let rotateForeverer = SKAction.repeatForever(rotate1)
        endHole.run(rotateForeverer)
    }
    func addLaserToHero() {
        self.shipLaser = SKShapeNode()
        shipLaser.lineWidth = 8
        shipLaser.glowWidth = 3
        shipLaser.alpha = 0.60
        shipLaser.strokeColor = .red
        shipLaser.zPosition = NodesZPosition.joystick.rawValue
        addChild(shipLaser)
        
        let _ = isTargetVisibleAtAngle(startPoint: hero.position, angle: hero.zRotation + (CGFloat.pi / 2), distance: frame.size.height)
        
    }
    func addESmoke(x1: Int) {
            if !isDamagedE[x1] {
                EShipSmoke[x1].position = EShip[x1].position
                EShipSmoke[x1].zPosition = NodesZPosition.joystick.rawValue
                EShipSmoke[x1].setScale(0.17)
                addChild(EShipSmoke[x1])
                isDamagedE[x1] = true
            }
            EShipSmoke[x1].zRotation = EShip[x1].zRotation
            EShipSmoke[x1].position = EShip[x1].position
    }
    func addSmoke() {
        if !addedSmoke {
            shipSmoke!.position = hero.position
            shipSmoke!.zPosition = NodesZPosition.joystick.rawValue
            shipSmoke!.setScale(0.17)
            addChild(shipSmoke!)
            addedSmoke = true
        }
        shipSmoke!.zRotation = hero.zRotation
        shipSmoke!.position = hero.position
    }
    func isShipDamaged() {
        if shipHealth <= 20 {
            addSmoke()
        }
    }
    func isTargetVisibleAtAngle(startPoint: CGPoint, angle: CGFloat, distance: CGFloat) -> Bool {
        let rayStart = startPoint
        let rayEnd = CGPoint(x: rayStart.x + distance * cos(angle),
                             y: rayStart.y + distance * sin(angle))
        
        let path = CGMutablePath()
        path.move(to: rayStart)
        path.addLine(to: rayEnd)
        shipLaser.path = path
        
        var foundOne = false
        let _ = physicsWorld.enumerateBodies(alongRayStart: rayStart, end: rayEnd) { (body, point, vector, stop) in
            if !foundOne {
                foundOne = true
                let p = CGMutablePath()
                p.move(to: rayStart)
                p.addLine(to: point)
                self.shipLaser.path = p
            }
        }
        return false
    }
    func addHealthLabel() {
        if isFirstLoad {
            shipHealth = 120
            healthlabel.text = "\(shipHealth)/\(healthNum)\n\(totalArmour)/50"
            isFirstLoad = false
        } else {
            healthlabel.text = "\(shipHealth)/\(healthNum)\n\(totalArmour)/50"
        }
        healthlabel.numberOfLines = 2
        healthlabel.zPosition = NodesZPosition.joystick.rawValue
        healthlabel.fontSize = 50.0
        healthlabel.fontName = "AvenirNext-Bold"
        healthlabel.fontColor = .darkGray
        addChild(healthlabel)
    }
    func addMacOSControls() {
        view1 = SKSpriteNode()
        view1.size = CGSize(width: 400, height: 400)
        view1.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        view1.zPosition = 20.0
        addChild(view1)
        let fireLabel = SKLabelNode(fontNamed: "ChalkboardSE-Bold")
        fireLabel.text = "Fire:"
        fireLabel.position = CGPoint(x: -200, y: 350)
        fireLabel.fontColor = .black
        fireLabel.fontSize = 120.0
        view1.addChild(fireLabel)
        let spacebar = SKSpriteNode(imageNamed: "spacebar")
        spacebar.anchorPoint = CGPoint(x: 1.0, y: 0.5)
        spacebar.position = CGPoint(x: 100, y: 225)
        spacebar.setScale(0.4)
        view1.addChild(spacebar)
        
        view1.setScale(0.4)
    }
    //MARK: - firing friendly Missile
    func fireFriendlyMissile() {
        let sound = SKAction.playSoundFileNamed("shipFireBullet.wav", waitForCompletion: false)
        sound.speed = 1.2
        run(sound)
        let missile = SKSpriteNode(imageNamed: "friendlyShipMissile")
        missile.name = "fm"
        missile.zRotation = hero.zRotation
        missile.setScale(0.35)
        missile.zPosition = NodesZPosition.allGameObjects.rawValue
        missile.physicsBody = SKPhysicsBody(rectangleOf: missile.frame.size)
        missile.physicsBody!.isDynamic = true
        missile.physicsBody!.affectedByGravity = false
        missile.physicsBody!.categoryBitMask = missile.physicsBody!.categoryBitMask
        missile.physicsBody!.contactTestBitMask = 0x1 << 4
        missile.physicsBody!.collisionBitMask = Collision.missile
        addChild(missile)
        let angle = hero.zRotation + CGFloat(Double.pi/2)
        let vector = CGVector(dx: cos(angle)*100, dy: sin(angle)*100)
        let xPos = hero.position.x + vector.dx
        let yPos = hero.position.y + vector.dy
        let position1 = CGPoint(x: xPos, y: yPos)
        missile.position = position1
        let action = SKAction.moveBy(x: vector.dx, y: vector.dy, duration: bulletSpeedAmount1())
        let repeat1 = SKAction.repeatForever(action)
        missile.run(repeat1)
    }
    public func fireButton() {
        if let explosion = SKEmitterNode(fileNamed: "FireParticles") {
            explosion.position = hero.position
            explosion.setScale(0.30)
            explosion.zPosition = NodesZPosition.joystick.rawValue
            explosion.zRotation = hero.zRotation
            addChild(explosion)
        }
        fireFriendlyMissile()
    }
    //MARK: - setting up Main start Scene
    public override func didMove(to view: SKView) {
        self.camera = cam
        addChild(cam)
        hero1()
        cam.position.x = hero.position.x
        cam.position.y = heroPosition.y - frame.height/7
        let initialZoom = SKAction.scale(by: 4, duration: 0)
        let zoomCam = SKAction.scale(by: 0.4, duration: 3)
        cam.run(initialZoom)
        cam.run(zoomCam)
        physicsWorld.contactDelegate = self
        setupNodes()
        addMacOSControls()
        timer1 = Timer.scheduledTimer(timeInterval: 0.08, target: self,   selector: (#selector(self.updateTrackTimer)), userInfo: nil, repeats: true)
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
        addFireLabel()
    }
    @objc func addTime() {
        gameTime += 1
    }
    func setupNodes() {
        heroPosition = shipStartPos[0]
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addChild(hero)
        addChild(addBackground())
        for _ in 0..<starPositions.count {
            addStar()
        }
        addHealthLabel()
        for _ in 0..<bouyIndustructablePositions.count {
            addNondustructionBouy()
        }
        for _ in 0..<healthBouyPositions.count {
            addBouy()
        }
        for _ in 0..<shipPositions.count {
            addEmemyShip()
        }
        addLaserToHero()
        damageAmount = damageAmount1()
    }
    func damageAmount1() -> Int {
        return 30
    }
    func speedTime() {
        velocityMultiplier = CGFloat(0.08)
    }
    func bulletSpeedAmount1() -> Double {
        return 0.2
    }
    //MARK: - Updating @objc Methods
    @objc func updateTrackTimer() {
        addShipTracks(ship: hero)
        for x in 0..<EShip.count {
            if !isEShipDead[x] {
                addShipTracks(ship: EShip[x])
            }
        }
    }
    //MARK: - Contacts
    public func didBegin(_ contact: SKPhysicsContact) {
        contactQueue.append(contact)
    }
    func processContacts(forUpdate currentTime: CFTimeInterval) {
        for contact in contactQueue {
            handle(contact)
            if let index = contactQueue.firstIndex(of: contact) {
                contactQueue.remove(at: index)
            }
        }
    }
    func handle(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.parent == nil || contact.bodyB.node?.parent == nil {
            return
        }
        let heroOrElseA = contact.bodyA.node?.name?.first
        let heroOrElseB = contact.bodyB.node?.name?.first
        if (heroOrElseA == "h" && heroOrElseB == "z") || (heroOrElseA == "z" && heroOrElseB == "h") {
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 0.4)
            let runBlock = SKAction.run {
                let sound = SKAction.playSoundFileNamed("collectCoin.wav", waitForCompletion: false)
                self.run(sound)
                if heroOrElseB == "z" {
                    contact.bodyB.node?.removeAllActions()
                    contact.bodyB.node?.removeFromParent()
                } else {
                    contact.bodyA.node?.removeAllActions()
                    contact.bodyA.node?.removeFromParent()
                }
            }
            let seq = SKAction.sequence([fade, runBlock])
            if heroOrElseB == "z" {
                contact.bodyB.node?.run(seq)
                contact.bodyB.node?.physicsBody = SKPhysicsBody(rectangleOf: .zero)
            } else {
                contact.bodyA.node?.run(seq)
                contact.bodyA.node?.physicsBody = SKPhysicsBody(rectangleOf: .zero)
            }
            if totalArmour <= 45 {
                totalArmour += 5
            } else {
                totalArmour = 50
            }
            healthlabel.text = "\(shipHealth)/\(healthNum)\n\(totalArmour)/50"
        } else if (heroOrElseA == "f" && heroOrElseB == "q") || (heroOrElseA == "q" && heroOrElseB == "f") {
            var name1 = ""
            var pos = CGPoint()
            if heroOrElseA == "f" {
                contact.bodyA.node?.removeAllChildren()
                contact.bodyA.node?.removeFromParent()
                contact.bodyA.node?.removeAllActions()
                name1 = contact.bodyB.node?.name ?? ""
                pos = contact.bodyB.node?.position ?? .zero
            } else {
                contact.bodyB.node?.removeAllChildren()
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.node?.removeAllActions()
                name1 = contact.bodyA.node?.name ?? ""
                pos = contact.bodyA.node?.position ?? .zero
            }
            if let explosion = SKEmitterNode(fileNamed: "spark") {
                explosion.position = pos
                explosion.setScale(0.26)
                addChild(explosion)
            }
            for shipName in 0..<EShip.count {
                if name1 == EShip[shipName].name {
                    EShipHealth[shipName] -= damageAmount
                    if EShipHealth[shipName] <= 0 {
                        if !isEShipDead[shipName] {
                            totalShipsDestroyed += 1
                            addHeart(pos: EShip[shipName].position)
                            EShip[shipName].texture = SKTexture(image: UIImage(named: "destroyedBoat")!)
                            EShip[shipName].physicsBody = SKPhysicsBody(rectangleOf: .zero)
                            EShip[shipName].physicsBody?.isDynamic = false
                            EShip[shipName].removeAllChildren()
                            EShip[shipName].removeAllActions()
                            EShip[shipName].isPaused = true
                            fireDeadShip[shipName].position = EShip[shipName].position
                            fireDeadShip[shipName].setScale(0.30)
                            fireDeadShip[shipName].particleAlpha = 0.6
                            fireDeadShip[shipName].zPosition = NodesZPosition.tracks.rawValue
                            addChild(fireDeadShip[shipName])
                            contact.bodyB.node?.removeAllChildren()
                            contact.bodyB.node?.removeAllActions()
                            contact.bodyA.node?.isPaused = true
                            enemyTimers[shipName].invalidate()
                            isEShipDead[shipName] = true
                        }
                    }
                }
            }
        } else if (heroOrElseA == "t" && heroOrElseB == "h") || (heroOrElseA == "h" && heroOrElseB == "t") {
            if heroOrElseA == "t" {
                contact.bodyA.node?.removeFromParent()
                contact.bodyA.node?.removeAllActions()
            } else {
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.node?.removeAllActions()
            }
            
            if totalArmour >= 15 {
                totalArmour -= 15
            } else if totalArmour < 15 {
                let remainder = totalArmour - 15
                totalArmour = 0
                shipHealth += remainder
            }
            
            healthlabel.text = "\(shipHealth)/\(healthNum)\n\(totalArmour)/50"
        } else if ((heroOrElseA == "c" || heroOrElseA == "i") && heroOrElseB == "t") || ((heroOrElseB == "c" || heroOrElseB == "i") && heroOrElseA == "t"){
            if heroOrElseA == "t" {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyB.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
            } else {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyA.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
            }
            var name1 = ""
            if heroOrElseA == "c" {
                name1 = contact.bodyA.node?.name ?? ""
            } else if heroOrElseB == "c" {
                name1 = contact.bodyB.node?.name ?? ""
            }
            if name1 != "" {
                for amount in 0..<(bouyNames.count) {
                    if bouyNames[amount] == name1 {
                        if bouyHealth[amount] == 3 {
                            bouyList[amount].texture = SKTexture(imageNamed: "twoLiveBouy")
                            bouyHealth[amount] = 2
                        } else if bouyHealth[amount] == 2 {
                            bouyList[amount].texture = SKTexture(imageNamed: "oneLiveBouy")
                            bouyHealth[amount] = 1
                        } else if bouyHealth[amount] == 1 {
                            let randomInt = Int.random(in: 0..<100)
                            if randomInt > 20 {
                                addHeart(pos: bouyList[amount].position)
                            }
                            bouyList[amount].removeFromParent()
                            bouyList.remove(at: amount)
                            bouyHealth.remove(at: amount)
                            bouyNames.remove(at: amount)
                        }
                        break
                    }
                }
            }
            if heroOrElseA == "t" {
                contact.bodyA.node?.removeAllChildren()
                contact.bodyA.node?.removeFromParent()
                contact.bodyA.node?.removeAllActions()
            } else {
                contact.bodyB.node?.removeAllChildren()
                contact.bodyB.node?.removeFromParent()
                contact.bodyB.node?.removeAllActions()
            }
        } else if (heroOrElseA == "h" && heroOrElseB == "e") || (heroOrElseA == "e" && heroOrElseB == "h") {
            isGameOver = true
        } else if heroOrElseA == "s" && heroOrElseB == "h" {
            for x in 0..<starName.count{
                if starName[x] == contact.bodyA.node?.name {
                    howManyStarsCollected += 1
                    starName.remove(at: x)
                    break
                }
            }
            contact.bodyA.node?.removeAllActions()
            let starOneRot = SKAction.rotate(byAngle: .pi , duration: 0.2)
            contact.bodyA.node?.run(starOneRot)
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 0.4)
            let runBlock = SKAction.run {
                let sound = SKAction.playSoundFileNamed("collectStar.wav", waitForCompletion: false)
                self.run(sound)
                
                contact.bodyA.node?.removeAllActions()
                contact.bodyA.node?.removeFromParent()
            }
            let seq = SKAction.sequence([fade, runBlock])
            contact.bodyA.node?.run(seq)
            
        } else if heroOrElseA == "h" && heroOrElseB == "s" {
            for x in 0..<starName.count{
                if starName[x] == contact.bodyB.node?.name {
                    howManyStarsCollected += 1
                    starName.remove(at: x)
                    break
                }
            }
            contact.bodyB.node?.removeAllActions()
            let starOneRot = SKAction.rotate(byAngle: .pi , duration: 0.2)
            contact.bodyB.node?.run(starOneRot)
            let fade = SKAction.fadeAlpha(to: 0.0, duration: 0.4)
            let runBlock = SKAction.run {
                let sound = SKAction.playSoundFileNamed("collectStar.wav", waitForCompletion: false)
                self.run(sound)
                
                contact.bodyB.node?.removeAllActions()
                contact.bodyB.node?.removeFromParent()
            }
            let seq = SKAction.sequence([fade, runBlock])
            contact.bodyB.node?.run(seq)
            
        } else if ((heroOrElseA == "c" || heroOrElseA == "i") && heroOrElseB == "f") || ((heroOrElseB == "c" || heroOrElseB == "i") && heroOrElseA == "f")  {
            var name1 = ""
            if heroOrElseA == "c" || heroOrElseA == "i"{
                name1 = contact.bodyA.node?.name ?? ""
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyA.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
            } else if heroOrElseB == "c" || heroOrElseB == "i" {
                name1 = contact.bodyB.node?.name ?? ""
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyB.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
            }
            if name1 != "" {
                for amount in 0..<(bouyNames.count) {
                    if bouyNames[amount] == name1 {
                        if bouyHealth[amount] == 3 {
                            bouyList[amount].texture = SKTexture(imageNamed: "twoLiveBouy")
                            bouyHealth[amount] = 2
                        } else if bouyHealth[amount] == 2 {
                            bouyList[amount].texture = SKTexture(imageNamed: "oneLiveBouy")
                            bouyHealth[amount] = 1
                        } else if bouyHealth[amount] == 1 {
                            let randomInt = Int.random(in: 0..<100)
                            if randomInt > 60 {
                                addHeart(pos: bouyList[amount].position)
                            }
                            bouyList[amount].removeFromParent()
                            bouyList.remove(at: amount)
                            bouyHealth.remove(at: amount)
                            bouyNames.remove(at: amount)
                        }
                        break
                    }
                }
            }
            if heroOrElseA == "f" {
                contact.bodyA.node?.removeAllActions()
                contact.bodyA.node?.removeFromParent()
            } else {
                contact.bodyB.node?.removeAllActions()
                contact.bodyB.node?.removeFromParent()
            }
        } else if (heroOrElseA == "c" && heroOrElseB == "h") || (heroOrElseA == "h" && heroOrElseB == "c") {
            let sound = SKAction.playSoundFileNamed("bouyShip.wav", waitForCompletion: false)
            sound.reversed()
            run(sound)
            
            var name1 = ""
            if heroOrElseB == "h" {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyA.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
                name1 = contact.bodyA.node?.name ?? ""
            } else {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyB.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
                name1 = contact.bodyB.node?.name ?? ""
            }
            for amount in 0..<(bouyNames.count) {
                if bouyNames[amount] == name1 {
                    if bouyHealth[amount] == 3 {
                        bouyList[amount].texture = SKTexture(imageNamed: "twoLiveBouy")
                        bouyHealth[amount] = 2
                    } else if bouyHealth[amount] == 2 {
                        bouyList[amount].texture = SKTexture(imageNamed: "oneLiveBouy")
                        bouyHealth[amount] = 1
                    } else if bouyHealth[amount] == 1 {
                        let randomInt = Int.random(in: 0..<100)
                        if randomInt > 60 {
                            addHeart(pos: bouyList[amount].position)
                        }
                        bouyList[amount].removeFromParent()
                        bouyList.remove(at: amount)
                        bouyHealth.remove(at: amount)
                        bouyNames.remove(at: amount)
                    }
                    break
                }
            }
        } else if (heroOrElseA == "t" && heroOrElseB == "z") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.removeAllActions()
        } else if (heroOrElseA == "z" && heroOrElseB == "t") {
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.removeAllActions()
        } else if (heroOrElseA == "t" && heroOrElseB == "f") || (heroOrElseA == "f" && heroOrElseB == "t") {
            contact.bodyA.node?.removeFromParent()
            contact.bodyA.node?.removeAllActions()
            contact.bodyB.node?.removeFromParent()
            contact.bodyB.node?.removeAllActions()
        } else if (heroOrElseA == "c" && heroOrElseB == "q") || (heroOrElseA == "q" && heroOrElseB == "c") {
            let sound = SKAction.playSoundFileNamed("bouyShip.wav", waitForCompletion: false)
            sound.reversed()
            run(sound)
            
            var name12 = ""
            if heroOrElseA == "q" {
                name12 = contact.bodyA.node?.name ?? ""
            } else {
                name12 = contact.bodyB.node?.name ?? ""
            }
            for x in 0..<isShipActive.count {
                if name12 == EShip[x].name {
                    fireShipFirstMove(ship: EShip[x], x: x)
                }
            }
            var name1 = ""
            if heroOrElseA == "c" {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyA.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
                name1 = contact.bodyA.node?.name ?? ""
            } else if heroOrElseB == "c" {
                if let explosion = SKEmitterNode(fileNamed: "spark") {
                    explosion.position = contact.bodyB.node!.position
                    explosion.setScale(0.26)
                    addChild(explosion)
                }
                name1 = contact.bodyB.node?.name ?? ""
            }
            if name1 != "" {
                for amount in 0..<(bouyNames.count) {
                    if bouyNames[amount] == name1 {
                        if bouyHealth[amount] == 3 {
                            bouyList[amount].texture = SKTexture(imageNamed: "twoLiveBouy")
                            bouyHealth[amount] = 2
                        } else if bouyHealth[amount] == 2 {
                            bouyList[amount].texture = SKTexture(imageNamed: "oneLiveBouy")
                            bouyHealth[amount] = 1
                        } else if bouyHealth[amount] == 1 {
                            let randomInt = Int.random(in: 0..<100)
                            if randomInt > 60 {
                                addHeart(pos: bouyList[amount].position)
                            }
                            bouyList[amount].removeFromParent()
                            bouyList.remove(at: amount)
                            bouyHealth.remove(at: amount)
                            bouyNames.remove(at: amount)
                        }
                        break
                    }
                }
            }
        } else if (heroOrElseA == "i" && heroOrElseB == "q") || (heroOrElseA == "q" && heroOrElseB == "i") {
            var name12 = ""
            if heroOrElseA == "q" {
                name12 = contact.bodyA.node?.name ?? ""
            } else {
                name12 = contact.bodyB.node?.name ?? ""
            }
            for x in 0..<isShipActive.count {
                if name12 == EShip[x].name {
                    fireShipFirstMove(ship: EShip[x], x: x)
                }
            }
        }
    }
    //MARK: - pauseresumeTimers
    public func pauseTimers() {
        for x in 0..<isTimerActive.count {
            if isShipActive[x]{
                enemyTimers[x].invalidate()
                isTimerActive[x] = false
            }
        }
        
        timer1.invalidate()
        timer2.invalidate()
    }
    public func resumeTimers() {
        timer2 = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(addTime), userInfo: nil, repeats: true)
        timer1 = Timer.scheduledTimer(timeInterval: 0.08, target: self,   selector: (#selector(self.updateTrackTimer)), userInfo: nil, repeats: true)
    }
    
    //MARK: - isGameOver
    func gameOver() {
        for x in 0..<enemyTimers.count {
            enemyTimers[x].invalidate()
            EShip[x].removeAllActions()
            isShipActive[x] = false
            isTimerActive[x] = false
            
        }
        timer1.invalidate()
        timer2.invalidate()
    }
    public func getisGameOver() -> Bool {
        return isGameOver
    }
    public func getShipHealth() -> Int {
        return shipHealth
    }
    //MARK: - Other Methods
    
    func updateEachZRoataion() {
        for x in 0..<EShip.count {
            EShip[x].zRotation = shipZRotation[x]
        }
    }
    
    //MARK: - UPdating Each Frame
    public override func willMove(from view: SKView) {
        self.removeAllChildren()
        self.removeAllActions()
        self.removeFromParent()
    }
    public override func update(_ currentTime: CFTimeInterval) {
        isEachShipMovable()
        if shipHealth <= 0 {
            isGameOver = true
            howGameOver = "health"
        }
        if isGameOver {
            gameOver()
            if howGameOver != "health" {
                howGameOver = "endHole"
            }
        }
        isShipDamaged()
        for x in 0..<isDamagedE.count {
            if EShipHealth[x] < 19 {
                addESmoke(x1: x)
            }
        }
        cam.position.x = hero.position.x
        cam.position.y = heroPosition.y - frame.height/7
        if !isMouseContered {
            newLocation = CGPoint(x: (location.x - frame.width/2 + hero.position.x), y: (location.y - frame.height/2 + hero.position.y))
            let dx = newLocation.x - hero.position.x
            let dy = newLocation.y - hero.position.y
            let radians = atan2(dx, dy)
            hero.zRotation = radians + .pi
            let angle = radians + .pi + .pi/2
            let value = 50*velocityMultiplier
            let vector = CGVector(dx: cos(angle)*value, dy: sin(angle)*value)
            let action = SKAction.move(by: vector, duration: 0.1)
            hero.run(action)
            let screenSizeW = frame.width
            let screenSizeH = frame.height
            let newW = (screenSizeW/2)
            let newH = ((screenSizeH/2) * 0.9)
            
            healthlabel.position.x = hero.position.x + newW - 50
            healthlabel.position.y = hero.position.y + newH - 125
            view1.position.x = hero.position.x + newW
            view1.position.y = hero.position.y - newH - 300
        }
        processContacts(forUpdate: currentTime)
        heroPosition = hero.position
        let _ = isTargetVisibleAtAngle(startPoint: hero.position, angle: hero.zRotation + (CGFloat.pi / 2), distance: frame.size.height)
        
        updateEachZRoataion()
    }
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        for touch in touches {
            if !isGameOver {
                location = touch.location(in: self.view)
                newLocation = CGPoint(x: (location.x - frame.width/2 + hero.position.x), y: (location.y - frame.height/2 + hero.position.y))
                if !hero.contains(newLocation) {
                    isMouseContered = false
                } else {
                    isMouseContered = true
                }
            }
        }
         
    }
    
    //MARK: - Each Position
    public var shipPositions: [CGPoint] = []
    public var starPositions: [CGPoint] = []
    public var healthBouyPositions: [CGPoint] = []
    public var bouyIndustructablePositions: [CGPoint] = []
}
