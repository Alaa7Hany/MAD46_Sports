

import Foundation
protocol NetworkService{
    func getLeagues(sportName : String,completion: @escaping ([LeagueModel]) -> Void)
    
    func getEvents(sportName: String,from: String,to: String,leagueId: Int,completion: @escaping ([Event]) -> Void
    )
    
    func getTeam(sportName : String ,leagueId: Int, completion: @escaping ([Team]) -> Void)
}
