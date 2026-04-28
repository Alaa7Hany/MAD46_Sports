//
//  SplashViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini11 on 28/04/2026.
//

import UIKit
import Lottie
class SplashViewController: UIViewController ,SplashView{
    var presenter : SplashPresenter!
    private var animationView: LottieAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = SplashPresenter(view: self)
        print("Splash loaded 👀") 
        setupUI()
        presenter.start()
 
      
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("Splash Appeared")
    }
    private func setupUI() {
           view.backgroundColor = .white
           setupLottie()
           setupBallsBackground()
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

    
       private func setupBallsBackground() {
           let emitter = CAEmitterLayer()
           emitter.emitterPosition = CGPoint(x: view.bounds.width / 2, y: view.bounds.height)
           emitter.emitterShape = .line
           emitter.emitterSize = CGSize(width: view.bounds.width, height: 1)

           let cell = CAEmitterCell()
           cell.birthRate = 5
           cell.lifetime = 10
           cell.velocity = 60
           cell.scale = 0.05
           cell.scaleRange = 0.02
           cell.contents = UIImage(named: "ball")?.cgImage

           emitter.emitterCells = [cell]
           view.layer.insertSublayer(emitter, at: 0)
       }
    func goToHome() {
        
    }
    
    func goToOnboarding() {
     
        
    }
    
   

}
