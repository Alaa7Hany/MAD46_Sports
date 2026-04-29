

import Foundation

class SplashPresenter {
    weak var view : SplashView?
    private let OnboardingKey = "Onboarding"
    init(view: SplashView) {
        self.view = view

    }
    
    func start() {
        print("Starttttt")
        let isFirst = !UserDefaults.standard.bool(forKey: OnboardingKey)
        print("Starttttt444444")
               DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                   print("44444Starttttt")
                   if isFirst {
                       UserDefaults.standard.set(true, forKey: self.OnboardingKey)
                       self.view?.goToOnboarding()
                   } else {
                       self.view?.goToHome()
                   }
               }
        
    }
    
    
}
protocol SplashView : AnyObject {
    func goToHome()
    func goToOnboarding()
}
