import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    // Scene View
    var sceneView : SCNView!
    // Scene
    var scene : SCNScene!
    // Game
    var game : Game!
    // Map
    var mapNode : MapNode!
    // Camera
    var cameraNode : CameraNode!
    // Light
    var lightNode : LightNode!
    // Player
    var playerNode : PlayerNode!
    // Game Controller
    var gameController : GameController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialise()
    }
    
    func initialise() {
        // Set up scene
        setupScene()
        // Set up game
        setupGame()
        // Set up map
        setupMap()
        // Set up camera
        setupCamera()
        // Set up light
        setupLight()
        // Set up player
        setupPlayer()
    }
     
    
    //MARK: - Scene Setup
    private func setupScene() {
        sceneView = self.view as? SCNView
        sceneView.delegate = self
        scene = SCNScene()
        scene.physicsWorld.contactDelegate = self
        sceneView.scene = scene
    }
    
    //MARK: - Game Setup
    private func setupGame() {
        self.game = Game(gameState: .menu, gameScore: 0, gameHUD: GameHUD(size: self.sceneView.bounds.size, isMenu: true))
        setupHUD(isMenu: true)
    }
    
    //MARK: - HUD Setup
    private func setupHUD(isMenu : Bool) {
        self.game.gameHUD = GameHUD(size: self.sceneView.bounds.size, isMenu: isMenu)
        self.sceneView.overlaySKScene = self.game.gameHUD
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
        self.game.gameState = isMenu ? .menu : .playing
    }
    
    //MARK: - Map Setup
    private func setupMap() {
        mapNode = MapNode(self)
        addNodeToScene(mapNode)
    }
    
    //MARK: - Camera Setup
    private func setupCamera() {
        cameraNode = CameraNode()
        addNodeToScene(cameraNode)
    }
    
    //MARK: - Light Setup
    private func setupLight() {
        lightNode = LightNode()
        addNodeToScene(lightNode)
    }
    
    //MARK: - Player Setup
    private func setupPlayer() {
        playerNode = PlayerNode()
        addNodeToScene(playerNode)
    }
    
    private func setupGameController() {
        gameController = GameController(self)
    }
    
    //MARK: - Add Node To Scene
    private func addNodeToScene(_ node : SCNNode) {
        self.scene.rootNode.addChildNode(node)
    }
}

extension GameViewController : SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didApplyAnimationsAtTime time: TimeInterval) {
        updateCameraPosition()
        updateVehiclePositions()
    }
    
    //MARK: - Update Camera Position
    private func updateCameraPosition() {
        let diffX = ((playerNode.position.x + 1) - cameraNode.position.x)
        let diffZ = ((playerNode.position.z + 2) - cameraNode.position.z)
        cameraNode.position.x += diffX
        cameraNode.position.z += diffZ
    }
    
    private func updateVehiclePositions() {
        for lane in self.mapNode.lanes {
            guard let trafficNode = lane.trafficNode else { continue }
            for vehicle in trafficNode.childNodes {
                if vehicle.position.x > 10 {
                    vehicle.position.x = -10
                } else if vehicle.position.x < -10 {
                    vehicle.position.x = 10
                }
            }
        }
    }
}

extension GameViewController : SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        guard let categoryA = contact.nodeA.physicsBody?.categoryBitMask,
        let categoryB = contact.nodeB.physicsBody?.categoryBitMask else { return }
        
        let bitMask = categoryA | categoryB
        
        switch bitMask {
        case Utils.chickenBitMask | Utils.vehicleBitMask:
            // Restart Game
            DispatchQueue.main.async {
                self.initialise()
            }
        case Utils.frontTestBitMask | Utils.vegetationBitMask:
            self.gameController.isFrontBlocked = true
        case Utils.rightTestBitMask | Utils.vegetationBitMask:
            self.gameController.isRightBlocked = true
        case Utils.leftTestBitMask | Utils.vegetationBitMask:
            self.gameController.isLeftBlocked = true
        case Utils.coinBitMask | Utils.chickenBitMask:
            print("GOT COIN")
            for lane in self.mapNode.lanes {
                // Get the lane that the user is on
                if Int(lane.position.z) == Int(self.playerNode.position.z) {
                    // If the lane contains
                    if lane.childNodes.contains(lane.coinNode) {
                        // Remove coin from lane
                        print("REMOVING COIN")
                        lane.coinNode.removeFromParentNode()
                        // Update Score
                        self.game.updateScore(5)
                    }
                }
            }
        default:
            break
        }
    }
}

extension GameViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switch game.gameState {
        case .menu:
            // Set up the game controller
            self.setupGameController()
            // Change the game HUD
            self.setupHUD(isMenu: false)
        case .playing:
            break
        }
    }
}


