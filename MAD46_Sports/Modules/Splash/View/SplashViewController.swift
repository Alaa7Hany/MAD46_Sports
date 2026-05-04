import UIKit
import Lottie

protocol SplashView: AnyObject {
}

class SplashViewController: UIViewController, SplashView {
    
    var presenter: SplashPresenter!
    
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Splash loaded 👀")
        setupUI()
        
        presenter.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Splash Appeared")
    }
    
    private func setupUI() {
        view.backgroundColor = .appBackground
        setupLottie()
       // setupBallsBackground()
    }

    private func setupLottie() {
        animationView = LottieAnimationView(name: "sports")
        guard let animationView = animationView else { return }

        animationView.frame = view.bounds
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        view.addSubview(animationView)
    }

    
//       private func setupBallsBackground() {
//           let emitter = CAEmitterLayer()
//           emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: view.bounds.height )
//           emitter.emitterShape = .line
//           emitter.emitterSize = CGSize(width: view.bounds.width, height: view.bounds.height / 2)
//
//           let cell = CAEmitterCell()
//           cell.birthRate = 5
//           cell.lifetime = 10
//           cell.velocity = 60
//           cell.scale = 0.07
//           cell.scaleRange = 0.02
//           cell.contents = UIImage(named: "ball")?.cgImage
//
//           emitter.emitterCells = [cell]
//           view.layer.insertSublayer(emitter, at: 0)
//       }
    func goToHome() {
        let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SportsViewController") as! SportsViewController
        
        home.modalPresentationStyle = .fullScreen
        
        self.present(home, animated: true, completion: nil)
    }
    
    
    func goToOnboarding() {
        let onBoarding = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "OnBoardingViewController") as! OnBoardingViewController
        
        onBoarding.modalPresentationStyle = .fullScreen
        
        self.present(onBoarding, animated: true, completion: nil)
    }


}
