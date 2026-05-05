
import Foundation

protocol LeaguesView: AnyObject {
    func showLeagues()
}

class LeaguePresenter {

    weak var view: LeaguesView?
    var leagues: [LeagueModel] = []
    
    var filteredLeagues: [LeagueModel] = []
    var isSearching: Bool = false
    
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
    
   
    func filterLeagues(searchText: String) {
        if searchText.isEmpty {
            isSearching = false
            filteredLeagues.removeAll()
        } else {
            isSearching = true
            filteredLeagues = leagues.filter { league in
                league.leagueName?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        view?.showLeagues()
    }
    
    func getCount() -> Int {
        return isSearching ? filteredLeagues.count : leagues.count
    }
    
    func getLeague(at index: Int) -> LeagueModel {
        return isSearching ? filteredLeagues[index] : leagues[index]
    }
    
    func didSelectLeague(at index: Int) {
        let selectedLeague = getLeague(at: index)
        
        guard let id = selectedLeague.leagueKey,
              let name = selectedLeague.leagueName else { return }
        
        router?.navigateToLeagueDetails(sportName: self.sport, leagueId: id, leagueName: name)
    }
    
    func isFavorite(at index: Int) -> Bool {
        let league = getLeague(at: index)
        let id = Int16(league.leagueKey ?? 0)
        return CoreDataManager.shared.isFavorite(id: id) != nil
    }

    func toggleFavorite(at index: Int) -> Bool {
        let league = getLeague(at: index)
        
        let id = Int16(league.leagueKey ?? 0)
        let name = league.leagueName ?? ""
        
        return CoreDataManager.shared.toggleFavorite(id: id, name: name, logo: nil)
    }
}
