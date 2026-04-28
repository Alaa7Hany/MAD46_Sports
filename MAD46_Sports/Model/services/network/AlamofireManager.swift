import Foundation
import Alamofire
class AlamofireManager : NetworkService
{

    static let shared = AlamofireManager()
    private init() {}
    private let apiKey = "3d09c674e733e4b354da276ca0b78cef806ec1d665b06e7924739b017f6c22a5"
    func getLeagues(sportName: String, completion: @escaping ([LeagueModel]) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Leagues&APIkey=\(apiKey)"
        AF.request(url).responseDecodable(of: LeagueResponse.self) { response in
           switch response.result{
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("error \(error)")
               completion([])
            }
            
        }
            
        }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int, completion: @escaping ([Event]) -> Void) {
         let url = "\(Constants.API.baseURL)/\(sportName)?met=Fixtures&APIkey=\(apiKey)&from=\(from)&to=\(to)&leagueId=\(leagueId)&timezone=Africa/Cairo"
        AF.request(url).responseDecodable(of: EventResponse.self) { response in
           switch response.result{
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("error \(error)")
               completion([])
            }
            
        }

    }
    func getTeam(sportName: String, leagueId: Int, completion: @escaping ([Team]) -> Void) {
        let url = "\(Constants.API.baseURL)/\(sportName)?met=Teams&leagueId=\(leagueId)&APIkey=\(apiKey)"
        AF.request(url).responseDecodable(of: TeamResponse.self) { response in
           switch response.result{
           case .success(let data):
               completion(data.result ?? [])
           case .failure(let error):
               print("error \(error)")
               completion([])
            }
            
        }
    }
    
    }
    
    

