import SceneKit

class VehicleNode: SCNNode {

    var sceneName : String
    var nodeName : String
    
    init(sceneName: String, nodeName: String) {
        self.sceneName = sceneName
        self.nodeName = nodeName
        super.init()
        setupVehicle()
    }
    
    override init() {
        self.sceneName = ""
        self.nodeName = ""
        super.init()
        setupVehicle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVehicle() {
        guard let scene = SCNScene(named: sceneName), let vehicleNode = scene.rootNode.childNode(withName: nodeName, recursively: true) else { return }
        addChildNode(vehicleNode)
    }
    
}
