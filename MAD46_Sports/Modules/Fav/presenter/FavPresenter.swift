//
//  FavPresenter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 02/05/2026.
//

import Foundation



protocol FavView: AnyObject {
    func showFavorites()
    func showEmptyState()
}

class FavPresenter {
    weak var view: FavView?
    var sport : String
    private weak var router: AppRouterProtocol?
    var favoriteLeagues: [League] = []
    
    init(view: FavView, router: AppRouterProtocol,sportName: String) {
        self.view = view
        self.router = router
        self.sport = sportName
    }
    
    func fetchFavorites() {
            favoriteLeagues = CoreDataManager.shared.fetchLeague()
            DispatchQueue.main.async { [weak self] in
                if self?.favoriteLeagues.isEmpty == true {
                    self?.view?.showEmptyState()
                } else {
                    self?.view?.showFavorites()
                }
            }
        }
    
    func getCount() -> Int {
        return favoriteLeagues.count
    }
    
    func getLeague(at index: Int) -> League {
        return favoriteLeagues[index]
    }
    
    func removeFavorite(at index: Int) {
        let league = favoriteLeagues[index]
        CoreDataManager.shared.deleteLeague(league: league)
        
        fetchFavorites()
    }
    
    func didSelectLeague(at index: Int) {
        let league = favoriteLeagues[index]
        guard let name = league.leagueName else { return }
        
      
        router?.navigateToLeagueDetails(sportName:self.sport, leagueId: Int(league.leagueId), leagueName: name)
    }
}
