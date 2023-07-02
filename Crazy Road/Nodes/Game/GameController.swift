import SceneKit

class GameController {
    
    let gameVC : GameViewController
    
    // Actions
    var jumpForward : SCNAction?
    var rotateForward : SCNAction?
    var jumpRight : SCNAction?
    var rotateRight : SCNAction?
    var jumpLeft : SCNAction?
    var rotateLeft : SCNAction?
    
    var isFrontBlocked : Bool = false
    var isRightBlocked : Bool = false
    var isLeftBlocked : Bool = false
    
    init(_ gameVC : GameViewController) {
        self.gameVC = gameVC
        setupGestures()
        setupActions()
    }
    
    private func setupGestures() {
        // Swipe up
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeUpGesture.direction = .up
        self.gameVC.sceneView.addGestureRecognizer(swipeUpGesture)
        
        // Swipe right
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeRightGesture.direction = .right
        self.gameVC.sceneView.addGestureRecognizer(swipeRightGesture)
        
        // Swipe left
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe))
        swipeLeftGesture.direction = .left
        self.gameVC.sceneView.addGestureRecognizer(swipeLeftGesture)
    }
    
    private func setupActions() {
        setupJumpForward()
        setupJumpRight()
        setupJumpLeft()
    }
    
    //MARK: - Jump Forward Action
    private func setupJumpForward() {
        let jumpUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0.1)
        let jumpDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 0.1)
        let jump = SCNAction.sequence([jumpUp, jumpDown])
        let moveForward = SCNAction.moveBy(x: 0, y: 0, z: -1, duration: 0.2)
        rotateForward = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 180), z: 0, duration: 0.2, usesShortestUnitArc: true)
        jumpForward = SCNAction.group([jump, moveForward])
    }
    
    //MARK: - Jump Right Action
    private func setupJumpRight() {
        let jumpUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0.1)
        let jumpDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 0.1)
        let jump = SCNAction.sequence([jumpUp, jumpDown])
        let moveRight = SCNAction.moveBy(x: 1, y: 0, z: 0, duration: 0.2)
        rotateRight = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 90), z: 0, duration: 0.2, usesShortestUnitArc: true)
        jumpRight = SCNAction.group([jump, moveRight])
    }
    
    //MARK: - Jump Forward Action
    private func setupJumpLeft() {
        let jumpUp = SCNAction.moveBy(x: 0, y: 1, z: 0, duration: 0.1)
        let jumpDown = SCNAction.moveBy(x: 0, y: -1, z: 0, duration: 0.1)
        let jump = SCNAction.sequence([jumpUp, jumpDown])
        let moveLeft = SCNAction.moveBy(x: -1, y: 0, z: 0, duration: 0.2)
        rotateLeft = SCNAction.rotateTo(x: 0, y: -Utils.shared.toRadians(angle: 90), z: 0, duration: 0.2, usesShortestUnitArc: true)
        jumpLeft = SCNAction.group([jump, moveLeft])
    }
    
    //MARK: - Handle Swipe
    @objc
    private func handleSwipe(_ sender : UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            if let jumpForward, let rotateForward, !isFrontBlocked {
                self.gameVC.mapNode.addLanes()
                self.gameVC.playerNode.chickenNode.runAction(rotateForward)
                self.gameVC.playerNode.runAction(jumpForward) {
                    self.gameVC.game.updateScore()
                    self.checkBlocked()
                }
            }
        case .right:
            if let jumpRight, let rotateRight, self.gameVC.playerNode.position.x < 9, !isRightBlocked {
                self.gameVC.playerNode.chickenNode.runAction(rotateRight)
                self.gameVC.playerNode.runAction(jumpRight) {
                    self.checkBlocked()
                }
            }
        case .left:
            if let jumpLeft, let rotateLeft, self.gameVC.playerNode.position.x > -9, !isLeftBlocked {
                self.gameVC.playerNode.chickenNode.runAction(rotateLeft)
                self.gameVC.playerNode.runAction(jumpLeft) {
                    self.checkBlocked()
                }
            }
        default:
            break
        }
    }
    
    private func checkBlocked() {
        if gameVC.scene.physicsWorld.contactTest(with: self.gameVC.playerNode.collisionNode.frontNode.physicsBody!).isEmpty {
            self.isFrontBlocked = false
        }
        if gameVC.scene.physicsWorld.contactTest(with: self.gameVC.playerNode.collisionNode.rightNode.physicsBody!).isEmpty {
            self.isRightBlocked = false
        }
        if gameVC.scene.physicsWorld.contactTest(with: self.gameVC.playerNode.collisionNode.leftNode.physicsBody!).isEmpty {
            self.isLeftBlocked = false
        }
    }
    
}
