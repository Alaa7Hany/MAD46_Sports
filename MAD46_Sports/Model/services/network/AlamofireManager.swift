import Foundation
import Alamofire

class AlamofireManager: NetworkService {

    static let shared = AlamofireManager()
    private init() {}
    
    private let apiKey = "3d09c674e733e4b354da276ca0b78cef806ec1d665b06e7924739b017f6c22a5"
    
    func getLeagues(sportName: String, completion: @escaping ([LeagueModel]) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Leagues&APIkey=\(apiKey)"
        
        AF.request(url).responseDecodable(of: LeagueResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("getLeagues error: \(error)")
               completion([])
            }
        }
    }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping ([Event]) -> Void) {
        var url = "\(Constants.API.baseURL)/\(sportName)?met=Fixtures&APIkey=\(apiKey)&from=\(from)&to=\(to)&timezone=Africa/Cairo"
        
        // Safely append leagueId only if it exists
        if let id = leagueId {
            url += "&leagueId=\(id)"
        }
        
        AF.request(url).responseDecodable(of: EventResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("getEvents error: \(error)")
               completion([])
            }
        }
    }
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping ([Participant]) -> Void) {
        var url = "\(Constants.API.baseURL)/\(sportName)?met=\(method)&APIkey=\(apiKey)"
        
        if let id = leagueId {
            url += "&leagueId=\(id)"
        }
        
        AF.request(url).responseDecodable(of: ParticipantResponse.self) { response in
           switch response.result {
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("getParticipants error: \(error)")
               completion([])
            }
        }
    }
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping ([Player]) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Players&APIkey=\(apiKey)&teamId=\(teamId)"
        
        AF.request(url).responseDecodable(of: PlayerResponse.self) { response in
            switch response.result {
            case .success(let data):
                completion(data.result ?? [])
            case .failure(let error):
                print("getRoster error: \(error)")
                completion([])
            }
        }
    }
}
