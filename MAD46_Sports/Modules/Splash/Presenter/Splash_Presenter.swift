

import Foundation

class SplashPresenter {
    weak var view : SplashView?
    private let OnboardingKey = "Onboarding"
    init(view: SplashView) {
        self.view = view
    }
    
    func start() {
        let isFirst = !UserDefaults.standard.bool(forKey: OnboardingKey)

               DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {

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
