import SceneKit

class FloorNode: SCNNode {

    override init() {
        super.init()
        setupFloor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupFloor() {
        let floorGeometry = SCNFloor()
        floorGeometry.firstMaterial?.diffuse.contents = UIImage(named: Utils.shared.assestsLocation("floor.png"))
        floorGeometry.firstMaterial?.diffuse.wrapS = .repeat
        floorGeometry.firstMaterial?.diffuse.wrapT = .repeat
        floorGeometry.reflectivity = 0.01
        floorGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(12.5, 12.5, 12.5)
        addChildNode(SCNNode(geometry: floorGeometry))
    }
    
}
