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
    func navigateToLeagueDetails(sportName: String, league: LeagueModel)
    
    func navigateToTeamDetails(sportName: String, teamId: Int, teamName: String)
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
    
    func navigateToMainApp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.mainTabBarVC) as? UITabBarController else { return }
        
        if let tabs = tabBarController.viewControllers {
            for vc in tabs {
                if let sportsVC = vc as? SportsViewController {
                    sportsVC.presenter = SportsPresenter(view: sportsVC, router: self)
                }
                else if let favVC = vc as? FavViewController {
                    favVC.presenter = FavPresenter(view: favVC, router: self, sportName: "All")                }
            }
        }
        
        navigationController.setViewControllers([tabBarController], animated: true)
        
        navigationController.isNavigationBarHidden = true
    }
    
    
    func navigateToLeagues(sportName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let leaguesVC = storyboard.instantiateViewController(withIdentifier: "LeaguesViewController") as? LeaguesViewController else { return }
        
        leaguesVC.presenter = LeaguePresenter(view: leaguesVC, sportName: sportName, router: self)
        
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(leaguesVC, animated: true)
    }
    
    func navigateToLeagueDetails(sportName: String, league: LeagueModel) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let detailsVC = storyboard.instantiateViewController(withIdentifier: Constants.ViewControllers.leagueDetailsVC) as? LeagueDetailsViewController else { return }
            
            detailsVC.presenter = LeagueDetailsPresenter(
                view: detailsVC,
                networkService: AlamofireManager.shared,
                router: self,
                sportName: sportName,
                league: league
            )
            
            navigationController.isNavigationBarHidden = false
            navigationController.pushViewController(detailsVC, animated: true)
        }
    func navigateToTeamDetails(sportName: String, teamId: Int, teamName: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        guard let teamVC = storyboard.instantiateViewController(withIdentifier: "TeamTableViewController") as? TeamTableViewController else { return }

        teamVC.presenter = TeamPresenter(
            view: teamVC,
            networkService: AlamofireManager.shared, 
            sportName: sportName,
            teamId: teamId,
            teamName: teamName
        )
        
        navigationController.isNavigationBarHidden = false
        navigationController.pushViewController(teamVC, animated: true)
    }
}
