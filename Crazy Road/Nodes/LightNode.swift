import SceneKit

class LightNode: SCNNode {
    
    override init() {
        super.init()
        setupLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLight() {
        setupAmbientLight()
        setupDirectionalLight()
    }
    
    private func setupAmbientLight() {
        let ambientLight = SCNNode()
        ambientLight.light = SCNLight()
        ambientLight.light?.type = .ambient
        addChildNode(ambientLight)
    }
    
    private func setupDirectionalLight() {
        let directionalLight = SCNNode()
        directionalLight.light = SCNLight()
        directionalLight.light?.type = .directional
        directionalLight.light?.castsShadow = true
        directionalLight.light?.shadowColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        directionalLight.position = SCNVector3(x: -5, y: 5, z: 0)
        directionalLight.eulerAngles = SCNVector3(x: 0, y: -Utils.shared.toRadians(angle: 90), z: -Utils.shared.toRadians(angle: 45))
        addChildNode(directionalLight)
    }
}
