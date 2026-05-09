import UIKit

class BasketballGameViewController: UIViewController {

    // MARK: - UI Elements
    private let ball = UILabel()
    private let hoop = UILabel()
    private let scoreLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    // MARK: - Physics & Game State
    private var animator: UIDynamicAnimator!
    private var gravity: UIGravityBehavior!
    private var push: UIPushBehavior!
    private var collision: UICollisionBehavior!
    private var bounce: UIDynamicItemBehavior!
    
    private var score = 0
    private var originalBallPosition: CGPoint = .zero
    private var isBallThrown = false
    private var displayLink: CADisplayLink?
    
    private var touchStartPoint: CGPoint = .zero

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.1, alpha: 1.0)
        
        setupUI()
        setupPhysics()
        setupGesture()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if originalBallPosition == .zero {
            originalBallPosition = ball.center
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        displayLink = CADisplayLink(target: self, selector: #selector(gameLoop))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displayLink?.invalidate()
    }

    // MARK: - Setup
    private func setupUI() {
        closeButton.setTitle(NSLocalizedString("GAME_CLOSE", comment: ""), for: .normal)
        closeButton.tintColor = .white
        closeButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        closeButton.frame = CGRect(x: 20, y: 50, width: 80, height: 40)
        closeButton.addTarget(self, action: #selector(closeGame), for: .touchUpInside)
        view.addSubview(closeButton)
        
        scoreLabel.text = NSLocalizedString("GAME_SCORE_ZERO", comment: "")
        scoreLabel.textColor = .white
        scoreLabel.font = .boldSystemFont(ofSize: 24)
        scoreLabel.frame = CGRect(x: view.bounds.width - 120, y: 50, width: 100, height: 40)
        view.addSubview(scoreLabel)
        
        hoop.text = "🗑️"
        hoop.font = .systemFont(ofSize: 80)
        hoop.sizeToFit()
        hoop.center = CGPoint(x: view.bounds.midX, y: 150)
        view.addSubview(hoop)
        
        ball.text = "🏀"
        ball.font = .systemFont(ofSize: 60)
        ball.sizeToFit()
        ball.center = CGPoint(x: view.bounds.midX, y: view.bounds.height - 120)
        view.addSubview(ball)
    }

    private func setupPhysics() {
        animator = UIDynamicAnimator(referenceView: view)
        
        gravity = UIGravityBehavior(items: [ball])
        gravity.magnitude = 2.5 // Slightly heavier gravity for a snappier arc
        
        collision = UICollisionBehavior(items: [ball])
        
        // THE OPEN CEILING: Custom walls that extend 2000 points into the sky
        let height = view.bounds.height
        let width = view.bounds.width
        
        collision.addBoundary(withIdentifier: "leftWall" as NSCopying,
                              from: CGPoint(x: 0, y: height),
                              to: CGPoint(x: 0, y: -2000))
        
        collision.addBoundary(withIdentifier: "rightWall" as NSCopying,
                              from: CGPoint(x: width, y: height),
                              to: CGPoint(x: width, y: -2000))
        
        bounce = UIDynamicItemBehavior(items: [ball])
        bounce.elasticity = 0.65
        bounce.friction = 0.4
        bounce.density = 2.0
        bounce.angularResistance = 0.2
        bounce.allowsRotation = true
    }

    private func setupGesture() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handleFlick(_:)))
        view.addGestureRecognizer(pan)
    }

    // MARK: - The Core Mechanic
        @objc private func handleFlick(_ gesture: UIPanGestureRecognizer) {
            guard !isBallThrown else { return }
            
            switch gesture.state {
            case .began:
                touchStartPoint = gesture.location(in: view)
                
            case .ended:
                let touchEndPoint = gesture.location(in: view)
                
                let dx = touchEndPoint.x - touchStartPoint.x
                let dy = touchEndPoint.y - touchStartPoint.y
                
                guard dy < 0 else { return }
                
                isBallThrown = true
                
                animator.addBehavior(gravity)
                animator.addBehavior(collision)
                animator.addBehavior(bounce)
                
                var pushX = dx / 25
                var pushY = dy / 25
                
                let maxForce: CGFloat = 16.0
                pushX = max(min(pushX, maxForce), -maxForce)
                pushY = max(min(pushY, maxForce), -maxForce)
                
                push = UIPushBehavior(items: [ball], mode: .instantaneous)
                push.pushDirection = CGVector(dx: pushX, dy: pushY)
                animator.addBehavior(push)
                
                let spinAmount = dx / 25.0
                bounce.addAngularVelocity(spinAmount, for: ball)
                
            default:
                break
            }
        }

    // MARK: - Hit Detection & Game Loop
    @objc private func gameLoop() {
        guard isBallThrown else { return }
        
        let dx = ball.center.x - hoop.center.x
        let dy = ball.center.y - hoop.center.y
        let distance = sqrt(dx*dx + dy*dy)
        
        if distance < 40 {
            scored()
            return
        }
        
        let screen = view.bounds
        if ball.center.y > screen.height + 80 ||
           ball.center.x < -100 ||
           ball.center.x > screen.width + 100 {
            
            resetBall()
        }
    }

    // MARK: - Game State Handlers
    private func scored() {
        isBallThrown = false
        score += 1
        scoreLabel.text = String(format: NSLocalizedString("GAME_SCORE_VALUE", comment: ""), "\(score)")
        
        UIView.animate(withDuration: 0.1, animations: {
            self.hoop.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.hoop.transform = .identity
            }
        }
        resetBall()
    }

    private func resetBall() {
        isBallThrown = false
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.3) {
            self.ball.center = self.originalBallPosition
            self.ball.transform = .identity
        }
    }

    @objc private func closeGame() {
        dismiss(animated: true)
    }
}
