//
//  league_presenter.swift
//  MAD46_Sports
//
//  Created by TaqieAllah on 30/04/2026.
//
import  Foundation
protocol LeaguesView:AnyObject{
    func showLeagues()
}
class LeaguePresenter {

    weak var view: LeaguesView?
    var leagues: [LeagueModel] = []
    var sport: String

    init(view: LeaguesView, sportName: String) {
        self.view = view
        self.sport = sportName
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
    func getCount()-> Int{
        return leagues.count
    }
    func getLeague(at index : Int)-> LeagueModel{
        return leagues[index]
    }
}

