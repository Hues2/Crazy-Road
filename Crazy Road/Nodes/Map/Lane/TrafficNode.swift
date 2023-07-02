import SceneKit

class TrafficNode: SCNNode {
    let trafficDirectionIsRight : Bool
    var moveRightAction : SCNAction = SCNAction.repeatForever(SCNAction.moveBy(x: 2, y: 0, z: 0, duration: 1))
    var moveLeftAction : SCNAction = SCNAction.repeatForever(SCNAction.moveBy(x: -2, y: 0, z: 0, duration: 1))
    
    init(trafficDirectionIsRight: Bool) {
        self.trafficDirectionIsRight = trafficDirectionIsRight
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTrafficSpeed(_ tilesPerSecond : Int) {
        moveRightAction = SCNAction.repeatForever(SCNAction.moveBy(x: CGFloat(tilesPerSecond), y: 0, z: 0, duration: 1))
        moveLeftAction = SCNAction.repeatForever(SCNAction.moveBy(x: CGFloat(-(tilesPerSecond)), y: 0, z: 0, duration: 1))
    }
}
