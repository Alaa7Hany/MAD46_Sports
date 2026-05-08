//
//  AppRouter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//
import UIKit
import Alamofire

protocol AppRouterProtocol: AnyObject {
    func start()
    func navigateToOnboarding()
    func navigateToMainApp()
    func navigateToLeagues(sportName: String)
    func navigateToLeagueDetails(sportName: String, league: LeagueModel)
    func navigateToTeamDetails(sportName: String, teamId: Int, teamName: String, teamLogo: String?)
}


class AppRouter: AppRouterProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Reachability Wrapper
    private func performIfConnected(action: @escaping () -> Void) {
        if NetworkMonitor.shared.isConnected {
            action()
        } else {
            // Use the extension on the top-most view controller
            navigationController.topViewController?.showNoInternetAlert()
        }
    }
    
    // MARK: - Navigation Methods
    
    func start() {
        let splashVC = SplashViewController()
        splashVC.presenter = SplashPresenter(view: splashVC, router: self)
        navigationController.viewControllers = [splashVC]
        navigationController.isNavigationBarHidden = true
    }
    
    func navigateToOnboarding() {
        let onboardingVC = OnBoardingViewController()
        onboardingVC.presenter = OnBoardingPresenter(view: onboardingVC, router: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    func navigateToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.mainTabBarVC) as? UITabBarController else { return }
        
        if let tabs = tabBarController.viewControllers {
            for vc in tabs {
                if let sportsVC = vc as? SportsViewController {
                    sportsVC.presenter = SportsPresenter(view: sportsVC, router: self)
                } else if let favVC = vc as? FavViewController {
                    favVC.presenter = FavPresenter(view: favVC, router: self, sportName: "All")
                }
            }
        }
        
        navigationController.setViewControllers([tabBarController], animated: true)
        navigationController.isNavigationBarHidden = true
    }
    
    func navigateToLeagues(sportName: String) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else { return }
            
            leaguesVC.presenter = LeaguePresenter(view: leaguesVC, sportName: sportName, router: self)
            
            self.navigationController.isNavigationBarHidden = false
            self.navigationController.pushViewController(leaguesVC, animated: true)
        }
    }
    
    func navigateToLeagueDetails(sportName: String, league: LeagueModel) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailsVC = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.leagueDetailsVC) as? LeagueDetailsViewController else { return }
            
            detailsVC.presenter = LeagueDetailsPresenter(
                view: detailsVC,
                networkService: AlamofireManager.shared,
                router: self,
                sportName: sportName,
                league: league
            )
            
            self.navigationController.isNavigationBarHidden = false
            self.navigationController.pushViewController(detailsVC, animated: true)
        }
    }
    
    func navigateToTeamDetails(sportName: String, teamId: Int, teamName: String, teamLogo: String?) {
        performIfConnected { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let teamVC = storyboard.instantiateViewController(withIdentifier: "TeamTableViewController") as? TeamTableViewController else { return }

            teamVC.presenter = TeamPresenter(
                view: teamVC,
                networkService: AlamofireManager.shared,
                sportName: sportName,
                teamId: teamId,
                teamName: teamName,
                teamLogo: teamLogo
            )
            
            self.navigationController.isNavigationBarHidden = false
            self.navigationController.pushViewController(teamVC, animated: true)
        }
    }
}
