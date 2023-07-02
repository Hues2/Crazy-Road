import SceneKit

class MapNode: SCNNode {
    let gameVC : GameViewController
    var floor : FloorNode
    var lanes : [LaneNode] = []
    var laneCount = 0
    
    init(_ gameVC : GameViewController) {
        self.gameVC = gameVC
        floor = FloorNode()
        super.init()
        setupMap()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupMap() {
        // Set up floor
        setupFloor()
        
        // Set up initial lanes
        setupInitialLanes()
    }
    
    //MARK: - Set Up Floor
    private func setupFloor() {
        floor = FloorNode()
        addChildNode(floor)
    }
    
    //MARK: - Set Up Initial Lanes
    private func setupInitialLanes() {
        for index in 0...19 {
            if index < 5 {
                createLane(true)
            } else {
                createLane(false)
            }
        }
    }
    
    //MARK: - Add Lanes
    func addLanes() {
        for _ in 0...1 {
            createLane(false)
            removeUnsusedLanes()
        }
    }
    
    //MARK: - Remove Unused Lanes
    private func removeUnsusedLanes() {
        for child in childNodes {
            if !self.gameVC.sceneView.isNode(child, insideFrustumOf: self.gameVC.cameraNode) &&
                child.worldPosition.z > self.gameVC.playerNode.position.z {
                child.removeFromParentNode()
                lanes.removeFirst()
            }
        }
    }
    
    //MARK: - Create Lane
    private func createLane(_ isInitial : Bool) {
        let laneType = (Utils.shared.randomBool(odds: 3) || isInitial) ? LaneType.grass : LaneType.road
        let laneNode = LaneNode(type: laneType, laneLength: 20, isInitial: isInitial)
        laneNode.position = SCNVector3(x: 0, y: 0, z: 3 - Float(laneCount))
        
        lanes.append(laneNode)
        laneCount += 1
        addChildNode(laneNode)
    }
}
