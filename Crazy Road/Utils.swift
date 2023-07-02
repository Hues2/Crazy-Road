import Foundation

class Utils {
    static let shared = Utils()
    
    private init() {}
    
    private let degreesPerRadians = Float(Double.pi / 180)
    private let radiansPerDegrees = Float(180 / Double.pi)
    
    func toRadians(angle : Float) -> Float {
        return angle * degreesPerRadians
    }

    func toRadians(angle : CGFloat) -> CGFloat {
        return angle * CGFloat(degreesPerRadians)
    }
    
    func randomBool(odds : Int) -> Bool {
        let random = arc4random_uniform(UInt32(odds))
        return random < 1 ? true : false
    }
    
    func assestsLocation(_ asset : String) -> String {
        "art.scnassets/\(asset)"
    }
    
    static let chickenBitMask = 1
    static let vehicleBitMask = 2
    static let vegetationBitMask = 4
    static let frontTestBitMask = 8
    static let rightTestBitMask = 16
    static let leftTestBitMask = 32
    static let coinBitMask = 64
}
