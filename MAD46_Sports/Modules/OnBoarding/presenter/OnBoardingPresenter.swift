
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
            OnBoardingModel(title: "Welcome to Sports", desc: "Follow the latest sports news and tournaments all in one place.", image: UIImage(named: "ball") ?? UIImage()),
            OnBoardingModel(title: "Accurate Statistics", desc: "Get detailed statistics and info about your favorite teams and players.", image: UIImage(named: "ball") ?? UIImage()),
            OnBoardingModel(title: "Never Miss a Match", desc: "Stay up to date with upcoming match schedules and sporting events.", image: UIImage(named: "ball") ?? UIImage())
        ]
    }
    
    func getCountPages() -> Int { return pages.count }
    func getPage(at index: Int) -> OnBoardingModel { return pages[index] }
    
    func finishOnBoarding() {
        UserDefaults.standard.set(true, forKey: Constants.Defaults.onboarding)
        
        router?.navigateToMainApp()
    }
}
