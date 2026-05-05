
import Foundation
import UIKit

protocol OnBoardingView: AnyObject {
}

class OnBoardingPresenter {
    private weak var onBoardingView: OnBoardingView?
    private weak var router: AppRouterProtocol?
    
    var pages: [OnBoardingModel] = []
    
    init(view: OnBoardingView, router: AppRouterProtocol) {
        self.onBoardingView = view
        self.router = router
        setUpPages()
    }
    
    func setUpPages() {
            pages = [
                OnBoardingModel( desc: "Follow the latest sports news and tournaments all in one place.", image: "onboarding1"),
                OnBoardingModel( desc: "Get detailed statistics and info about your favorite teams and players.", image: "onboarding2"),
                OnBoardingModel( desc: "Stay up to date with upcoming match schedules and sporting events.", image: "onboarding3")
            ]
        }
    
    func getCountPages() -> Int { return pages.count }
    func getPage(at index: Int) -> OnBoardingModel { return pages[index] }
    
    func finishOnBoarding() {
        UserDefaults.standard.set(true, forKey: Constants.Defaults.onboarding)
        
        router?.navigateToMainApp()
    }
}
