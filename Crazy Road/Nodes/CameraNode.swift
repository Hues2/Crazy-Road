import SceneKit

class CameraNode: SCNNode {

    override init() {
        super.init()
        setupCamera()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCamera() {
        camera = SCNCamera()
        position = SCNVector3(x: 0, y: 10, z: 0)
        eulerAngles = SCNVector3(x: -(Utils.shared.toRadians(angle: 60)), y: Utils.shared.toRadians(angle: 20), z: 0)
    }
}
