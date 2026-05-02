import Foundation

class SplashPresenter {
    private weak var view: SplashView?
    private weak var router: AppRouterProtocol?
    
    init(view: SplashView, router: AppRouterProtocol) {
        self.view = view
        self.router = router
    }
    
    func start() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.timerDidFinish()
        }
    }
    
    func timerDidFinish() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "Onboarding")
        
        if hasSeenOnboarding {
            router?.navigateToMainApp()
        } else {
            router?.navigateToOnboarding()
        }
    }
}
