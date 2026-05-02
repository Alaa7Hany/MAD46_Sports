//
//  AppRouter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//
import UIKit

protocol AppRouterProtocol: AnyObject {
    func start()
    func navigateToOnboarding()
    func navigateToMainApp()
    func navigateToLeagues(sportName: String)
    
    func navigateToLeagueDetails(sportName: String, leagueId: Int, leagueName: String)
    func navigateToTeamDetails(team: Team)
}

class AppRouter: AppRouterProtocol {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let splashVC = SplashViewController()
        
        splashVC.presenter = SplashPresenter(view: splashVC, router: self)
        
        navigationController.viewControllers = [splashVC]
        navigationController.isNavigationBarHidden = true
    }
    
    func navigateToOnboarding() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let onboardingVC = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.onBoardingVC) as? OnBoardingViewController else { return }
        
        onboardingVC.presenter = OnBoardingPresenter(view: onboardingVC, router: self)
        navigationController.pushViewController(onboardingVC, animated: true)
    }
    
    // MARK: - Programmatically
    func navigateToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.mainTabBarVC) as? UITabBarController else { return }
        
        if let tabs = tabBarController.viewControllers {
            for vc in tabs {
                if let sportsVC = vc as? SportsViewController {
                    sportsVC.presenter = SportsPresenter(view: sportsVC, router: self)
                }
                else if let favVC = vc as? FavViewController {
                    // favVC.presenter = FavoritesPresenter(view: favVC, router: self)
                }
            }
        }
        
        navigationController.setViewControllers([tabBarController], animated: true)
        
        navigationController.isNavigationBarHidden = true
    }
    
    // MARK: - In-App Navigation
    
    func navigateToLeagues(sportName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else { return }
        
        // Pass the router so the presenter can navigate further
        leaguesVC.presenter = LeaguePresenter(view: leaguesVC, sportName: sportName, router: self)
        
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(leaguesVC, animated: true)
    }
    
    func navigateToLeagueDetails(sportName: String, leagueId: Int, leagueName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailsVC = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.leagueDetailsVC) as? LeagueDetailsViewController else { return }
        
        detailsVC.presenter = LeagueDetailsPresenter(
            view: detailsVC,
            networkService: AlamofireManager.shared,
            router: self,
            sportName: sportName,
            leagueId: leagueId,
            leagueName: leagueName
        )
        
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(detailsVC, animated: true)
    }
    
    func navigateToTeamDetails(team: Team) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let teamVC = storyboard.instantiateViewController(withIdentifier: "TeamDetailsViewController") as? UIViewController else { return }
//        
//        navigationController.pushViewController(teamVC, animated: true)
    }
}
