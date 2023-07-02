import SceneKit

class VegetationNode: SCNNode {
    var sceneName : String
    var nodeName : String
    
    init(sceneName: String, nodeName: String) {
        self.sceneName = sceneName
        self.nodeName = nodeName
        super.init()
        setupVegetation()
    }
    
    override init() {
        self.sceneName = ""
        self.nodeName = ""
        super.init()
        setupVegetation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupVegetation() {
        guard let scene = SCNScene(named: sceneName), let node = scene.rootNode.childNode(withName: nodeName, recursively: true) else { return }
        addChildNode(node)
    }
}
