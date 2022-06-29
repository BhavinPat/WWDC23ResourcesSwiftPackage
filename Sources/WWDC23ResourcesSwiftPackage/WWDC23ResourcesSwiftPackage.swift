import AVFoundation
import SpriteKit
public struct WWDC23ResourcesSwiftPackage {
    public private(set) var text = "Hello, World!"
    public var music: AVAudioPlayer!
    public var fire: SKEmitterNode!
    public var continiousSmoke: SKEmitterNode!
    public var FireParticles: SKEmitterNode!
    public var PlayerExplosion: SKEmitterNode!
    public var smoke: SKEmitterNode!
    public var spark: SKEmitterNode!
    public var bouyShip: SKAction!
    public var collectCoin: SKAction!
    public var collectStar: SKAction!
    public var shipFireBullet: SKAction!
    public init() {
        if let path = Bundle.module.path(forResource: "bensound-theduel", ofType: "mp3") {
            let url = NSURL(fileURLWithPath: path)
            do {
                music = try AVAudioPlayer(contentsOf: url as URL)
            } catch {
                print(error)
            }
        }
        
        continiousSmoke = SKEmitterNode(fileNamed: "continiousSmoke")
        FireParticles = SKEmitterNode(fileNamed: "FireParticles")
        PlayerExplosion = SKEmitterNode(fileNamed: "PlayerExplosion")
        smoke = SKEmitterNode(fileNamed: "smoke")
        spark = SKEmitterNode(fileNamed: "spark")
        fire = SKEmitterNode(fileNamed: "fire")
        
        bouyShip = SKAction.playSoundFileNamed("bouyShip.wav", waitForCompletion: false)
        collectCoin = SKAction.playSoundFileNamed("collectCoin.wav", waitForCompletion: false)
        collectStar = SKAction.playSoundFileNamed("collectStar.wav", waitForCompletion: false)
        shipFireBullet = SKAction.playSoundFileNamed("shipFireBullet.wav", waitForCompletion: false)
        
        
    }

}
