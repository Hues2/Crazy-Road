import SceneKit

class PlayerNode: SCNNode {
    var chickenNode : SCNNode
    var collisionNode : CollisionNode
    
    override init() {
        chickenNode = SCNNode()
        collisionNode = CollisionNode()
        super.init()
        setupPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayer() {
        let chickenScene = SCNScene(named: Utils.shared.assestsLocation("Chicken.scn"))
        guard let chickenScene, let chickenNode = chickenScene.rootNode.childNode(withName: "player", recursively: true) else { return }
        setupChicken(chickenNode)
        
        // Add collision node to player node
        addChildNode(collisionNode)
        position = SCNVector3(x: 0, y: 0.0, z: 0)
    }
    
    private func setupChicken(_ chicken : SCNNode) {
        self.chickenNode = chicken
        // Add chicken node to player node
        addChildNode(self.chickenNode)
    }
}
