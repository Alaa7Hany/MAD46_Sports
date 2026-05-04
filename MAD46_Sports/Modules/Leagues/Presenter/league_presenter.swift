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
    private weak var router: AppRouterProtocol?

    
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
    
  
    func didSelectLeague(at index: Int) {
        let selectedLeague = leagues[index]
        
       
        guard let id = selectedLeague.leagueKey,
              let name = selectedLeague.leagueName else { return }
        
        router?.navigateToLeagueDetails(sportName: self.sport, leagueId: id, leagueName: name)
    }
    func isFavorite(at index: Int) -> Bool {
        let league = leagues[index]
        let id = Int16(league.leagueKey ?? 0)
        return CoreDataManager.shared.isFavorite(id: id) != nil
    }

    func toggleFavorite(at index: Int) -> Bool {
        let league = leagues[index]
        
        let id = Int16(league.leagueKey ?? 0)
        let name = league.leagueName ?? ""
        
        let result = CoreDataManager.shared.toggleFavorite(
            id: id,
            name: name,
            logo: nil
        )
        
        return result
    }
}
