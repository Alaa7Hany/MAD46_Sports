//
//  league_presenter.swift
//  MAD46_Sports
//
//  Created by TaqieAllah on 30/04/2026.
//
import Foundation

protocol LeaguesView: AnyObject {
    func showLeagues()
}

class LeaguePresenter {

    weak var view: LeaguesView?
    var leagues: [LeagueModel] = []
    var sport: String
    private weak var router: AppRouterProtocol? // 👉 Add the router

    // 👉 Update the init to accept the router
    init(view: LeaguesView, sportName: String, router: AppRouterProtocol) {
        self.view = view
        self.sport = sportName
        self.router = router
    }
    
    func fetchLeague() {
        AlamofireManager.shared.getLeagues(sportName: sport) { [weak self] leagues in
            guard let self = self else { return }

            self.leagues = leagues

            DispatchQueue.main.async {
                self.view?.showLeagues()
            }
        }
    }
    
    func getCount() -> Int {
        return leagues.count
    }
    
    func getLeague(at index: Int) -> LeagueModel {
        return leagues[index]
    }
    
    // 👉 ADD THIS: Handle the click and route to details
    func didSelectLeague(at index: Int) {
        let selectedLeague = leagues[index]
        
        // Ensure you use the exact variable names from your LeagueModel here
        guard let id = selectedLeague.leagueKey,
              let name = selectedLeague.leagueName else { return }
        
        router?.navigateToLeagueDetails(sportName: self.sport, leagueId: id, leagueName: name)
    }
}
