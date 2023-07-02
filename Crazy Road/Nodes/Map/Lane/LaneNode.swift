import SceneKit

enum LaneType {
    case grass, road
}

class LaneNode: SCNNode {

    let type : LaneType
    let laneLength : CGFloat
    let isInitial : Bool
    
    // Vegetation
    let treeNode = VegetationNode(sceneName: Utils.shared.assestsLocation("Tree.scn"), nodeName: "tree")
    let hedgeNode = VegetationNode(sceneName: Utils.shared.assestsLocation("Hedge.scn"), nodeName: "hedge")
    
    // Vehicles
    let truckNode = VegetationNode(sceneName: Utils.shared.assestsLocation("BlueTruck.scn"), nodeName: "truck")
    let fireTruckNode = VegetationNode(sceneName: Utils.shared.assestsLocation("Firetruck.scn"), nodeName: "truck")
    let carNode = VegetationNode(sceneName: Utils.shared.assestsLocation("PurpleCar.scn"), nodeName: "car")
    
    // Coin
    let coinNode = CoinNode(sceneName: Utils.shared.assestsLocation("coin_5.scn"), nodeName: "coin")
    
    var trafficNode : TrafficNode?
    
    init(type: LaneType, laneLength : CGFloat, isInitial : Bool) {
        self.type = type
        self.laneLength = laneLength
        self.isInitial = isInitial
        super.init()
        
        switch type {
        case .grass:
            guard let texture = UIImage(named: Utils.shared.assestsLocation("grass.png")) else { return }
            setupLane(texture)
        case .road:
            guard let texture = UIImage(named: Utils.shared.assestsLocation("asphalt.png")) else { return }
            trafficNode = TrafficNode(trafficDirectionIsRight: Utils.shared.randomBool(odds: 2))
            setupLane(texture)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Up Lane
    private func setupLane(_ texture : UIImage) {
        let laneGeometry = SCNBox(width: laneLength, height: type == .grass ? 0.3 : 0.1, length: 1, chamferRadius: 0)
        laneGeometry.firstMaterial?.diffuse.contents = texture
        laneGeometry.firstMaterial?.diffuse.wrapS = .repeat
        laneGeometry.firstMaterial?.diffuse.wrapT = .repeat
        laneGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(laneLength), 1, 1)
        let laneNode = SCNNode(geometry: laneGeometry)
        
        if !isInitial {
            // Add elements to the lane
            addElementsToLane(laneNode)
        }
        
        // If the lane is a road, then there will be a traffic node.
        // Add the traffic node to the lane node
        if let trafficNode {
            laneNode.addChildNode(trafficNode)
        }
        
        // Add the lane node to the class
        addChildNode(laneNode)
    }
    
    private func addElementsToLane(_ laneNode : SCNNode) {
        // Set random speed for the lane
        let tilesPerSecond = Utils.shared.randomBool(odds: 3) ? 2 : Utils.shared.randomBool(odds: 2) ? 1 : 3
        var carGap = 0
        var coinIsAdded : Bool = false
        for index in 0..<Int(laneLength) {
            switch type {
            case .grass:
                if Utils.shared.randomBool(odds: 5) {
                    self.addVegetation(laneNode, index)
                }
            case .road:
                guard let trafficNode else { continue }
                // Add or don't add the coin at this tile
                if Utils.shared.randomBool(odds: 4) && !coinIsAdded {
                    coinIsAdded = true
                    addCoin(index)
                }
                // Set the traffic speed
                trafficNode.setTrafficSpeed(tilesPerSecond)
                carGap += 1
                if Utils.shared.randomBool(odds: 4) && carGap > 3 {
                    self.addVehicle(trafficNode, index)
                    carGap = 0
                }
            }
        }
    }
    
    private func addVegetation(_ laneNode : SCNNode, _ index : Int) {
        let vegetationNode = Utils.shared.randomBool(odds: 2) ? treeNode.clone() : hedgeNode.clone()
        vegetationNode.position = SCNVector3(x: 10 - Float(index), y: 0, z: 0)
        laneNode.addChildNode(vegetationNode)
    }
    
    private func addVehicle(_ trafficNode : TrafficNode, _ index : Int) {
        let vehicleNode = Utils.shared.randomBool(odds: 3) ? carNode.clone() : (Utils.shared.randomBool(odds: 2) ? truckNode.clone() : fireTruckNode.clone())
        vehicleNode.position = SCNVector3(x: 10 - (Float(index)), y: 0, z: 0)
        vehicleNode.eulerAngles =  trafficNode.trafficDirectionIsRight ? SCNVector3Zero : SCNVector3(x: 0, y: Utils.shared.toRadians(angle: 180), z: 0)
        vehicleNode.runAction(trafficNode.trafficDirectionIsRight ? trafficNode.moveRightAction : trafficNode.moveLeftAction)
        trafficNode.addChildNode(vehicleNode)
    }
    
    private func addCoin(_ index : Int) {
        // Don't clone the coin because we only ever add one per road lane
        coinNode.position = SCNVector3(x: 10 - Float(index), y: 0, z: 0)
        coinNode.eulerAngles = SCNVector3(x: 0, y: Utils.shared.toRadians(angle: 0), z: 0)
        let turn1 = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 90), z: 0, duration: 1, usesShortestUnitArc: false)
        let turn2 = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 180), z: 0, duration: 1, usesShortestUnitArc: false)
        let turn3 = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 270), z: 0, duration: 1, usesShortestUnitArc: true)
        let turn4 = SCNAction.rotateTo(x: 0, y: Utils.shared.toRadians(angle: 360), z: 0, duration: 1, usesShortestUnitArc: true)
        let rotate = SCNAction.sequence([turn1, turn2, turn3, turn4])
        coinNode.runAction(SCNAction.repeatForever(rotate))
        addChildNode(coinNode)
    }
}
