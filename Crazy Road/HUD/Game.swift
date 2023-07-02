import Foundation

enum GameState {
    case menu, playing, over
}

class Game {
    var gameState : GameState = .menu
    var gameScore : Int = 0
    var gameHUD : GameHUD
    
    init(gameState: GameState, gameScore: Int, gameHUD: GameHUD) {
        self.gameState = gameState
        self.gameScore = gameScore
        self.gameHUD = gameHUD
    }
    
    func updateScore(_ points : Int = 1) {
        self.gameScore += points
        self.gameHUD.pointsLabel?.text = "\(gameScore)"
    }
}
