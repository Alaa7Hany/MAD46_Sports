

import Foundation

protocol NetworkService {
    func getLeagues(sportName: String, completion: @escaping ([LeagueModel]) -> Void)
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping ([Event]) -> Void)
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping ([Participant]) -> Void)
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping ([Player]) -> Void)
}
