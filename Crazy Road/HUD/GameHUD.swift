import SpriteKit

class GameHUD: SKScene {

    var logoLabel : SKLabelNode?
    var tapToPlay : SKLabelNode?
    var pointsLabel : SKLabelNode?
    var gameOverLabel : SKLabelNode?
    
    init(size : CGSize, state : GameState) {
        super.init(size: size)
        switch state {
        case .menu:
            addMenuLabels()
        case .playing:
            addPointsLabel()
        case .over:
            addGameoverLabels()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addMenuLabels() {
        logoLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        tapToPlay = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        setupLogoLabel()
        setupTapToPlay(logoLabel)
    }
    
    private func setupLogoLabel() {
        guard let logoLabel else { return }
        logoLabel.text = "Road Ross"
        logoLabel.fontSize = 35.0
        logoLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(logoLabel)
    }
    
    private func setupTapToPlay(_ label : SKLabelNode?) {
        guard let tapToPlay, let label else { return }
        tapToPlay.text = "Tap to play"
        tapToPlay.fontSize = 25.0
        tapToPlay.position = CGPoint(x: frame.midX, y: (frame.midY - label.frame.size.height))
        addChild(tapToPlay)
    }
    
    private func addPointsLabel() {
        pointsLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        guard let pointsLabel else { return }
        pointsLabel.text = "0"
        pointsLabel.fontSize = 40.0
        pointsLabel.position = CGPoint(x: frame.minX + pointsLabel.frame.size.width, y: frame.maxY - (pointsLabel.frame.height * 2))
        addChild(pointsLabel)
    }
    
    private func addGameoverLabels() {
        gameOverLabel = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        tapToPlay = SKLabelNode(fontNamed: "8BIT WONDER Nominal")
        setupGameOverLabel()
        setupTapToPlay(gameOverLabel)
    }
    
    private func setupGameOverLabel() {
        guard let gameOverLabel else { return }
        gameOverLabel.text = "Game Over"
        gameOverLabel.fontSize = 35.0
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(gameOverLabel)
    }
}
