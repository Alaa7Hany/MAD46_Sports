

import Foundation

protocol NetworkService {
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], Error>) -> Void)
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], Error>) -> Void)
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], Error>) -> Void)
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], Error>) -> Void)
}
