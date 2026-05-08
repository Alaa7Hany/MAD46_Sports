
import Foundation

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
                OnBoardingModel(title: NSLocalizedString("ONBOARDING_TITLE_1", comment: ""), desc: NSLocalizedString("ONBOARDING_DESC_1", comment: ""), image: "onboarding1"),
                OnBoardingModel(title: NSLocalizedString("ONBOARDING_TITLE_2", comment: ""), desc: NSLocalizedString("ONBOARDING_DESC_2", comment: ""), image: "onboarding2"),
                OnBoardingModel(title: NSLocalizedString("ONBOARDING_TITLE_3", comment: ""), desc: NSLocalizedString("ONBOARDING_DESC_3", comment: ""), image: "onboarding3")
            ]
        }
    
    func getCountPages() -> Int { return pages.count }
    func getPage(at index: Int) -> OnBoardingModel { return pages[index] }
    
    func finishOnBoarding() {
        UserDefaults.standard.set(true, forKey: Constants.Defaults.onboarding)
        
        router?.navigateToMainApp()
    }
}
