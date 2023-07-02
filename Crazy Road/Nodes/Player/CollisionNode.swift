import SceneKit

class CollisionNode: SCNNode {
    
    var frontNode : SCNNode
    var rightNode : SCNNode
    var leftNode : SCNNode

    override init() {
        frontNode = SCNNode()
        rightNode = SCNNode()
        leftNode = SCNNode()
        super.init()
        setupCollision()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollision() {
        let geometry = SCNBox(width: 0.25, height: 0.25, length: 0.25, chamferRadius: 0)
        geometry.firstMaterial?.diffuse.contents = UIColor.clear
        let shape = SCNPhysicsShape(geometry: geometry, options: [SCNPhysicsShape.Option.type: SCNPhysicsShape.ShapeType.boundingBox])
        setupFrontColission(geometry, shape)
        setupRightColission(geometry, shape)
        setupLeftColission(geometry, shape)
    }
    
    private func setupFrontColission(_ geometry : SCNGeometry, _ shape : SCNPhysicsShape) {
        frontNode = SCNNode(geometry: geometry)
        frontNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        frontNode.physicsBody?.categoryBitMask = Utils.frontTestBitMask
        frontNode.physicsBody?.contactTestBitMask = Utils.vegetationBitMask
        frontNode.position = SCNVector3Make(0, 0, -1)
        addChildNode(frontNode)
    }
    
    private func setupRightColission(_ geometry : SCNGeometry, _ shape : SCNPhysicsShape) {
        rightNode = SCNNode(geometry: geometry)
        rightNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        rightNode.physicsBody?.categoryBitMask = Utils.rightTestBitMask
        rightNode.physicsBody?.contactTestBitMask = Utils.vegetationBitMask
        rightNode.position = SCNVector3Make(1, 0, 0)
        addChildNode(rightNode)
    }
    
    private func setupLeftColission(_ geometry : SCNGeometry, _ shape : SCNPhysicsShape) {
        leftNode = SCNNode(geometry: geometry)
        leftNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: shape)
        leftNode.physicsBody?.categoryBitMask = Utils.leftTestBitMask
        leftNode.physicsBody?.contactTestBitMask = Utils.vegetationBitMask
        leftNode.position = SCNVector3Make(-1, 0, 0)
        addChildNode(leftNode)
    }
}
