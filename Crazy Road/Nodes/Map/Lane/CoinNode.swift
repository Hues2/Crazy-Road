import SceneKit

class CoinNode: SCNNode {
    var sceneName : String
    var nodeName : String
    
    init(sceneName: String, nodeName: String) {
        self.sceneName = sceneName
        self.nodeName = nodeName
        super.init()
        setupCoin()
    }
    
    override init() {
        self.sceneName = ""
        self.nodeName = ""
        super.init()
        setupCoin()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCoin() {
        guard let scene = SCNScene(named: sceneName), let node = scene.rootNode.childNode(withName: nodeName, recursively: true) else { return }
        addChildNode(node)
    }
}
