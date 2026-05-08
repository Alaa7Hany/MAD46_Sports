//
//  MockNetworkService.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini11 on 08/05/2026.
//
import XCTest
@testable import MAD46_Sports
final class MockNetworkService : NetworkService {
    let shouldReturnWithError : Bool
    init(shouldReturnWithError: Bool) {
        self.shouldReturnWithError = shouldReturnWithError
    }
    func getLeagues(sportName: String, completion: @escaping (Result<[LeagueModel], any Error>) -> Void) {
        if shouldReturnWithError {
            let error = NSError(domain: "MockError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Mock Failure"])
            completion(.failure(error))
        }else{
            completion(.success([]))

        }
    }
    
    func getEvents(sportName: String, from: String, to: String, leagueId: Int?, completion: @escaping (Result<[Event], any Error>) -> Void) {
        if shouldReturnWithError{
        let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
              
            } else {
                    completion(.success([]))
      }
    }
    
    func getParticipants(sportName: String, method: String, leagueId: Int?, completion: @escaping (Result<[Participant], any Error>) -> Void) {
        if shouldReturnWithError {
                    let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
                } else {
                    completion(.success([]))
                }
    }
    
    func getRoster(sportName: String, teamId: Int, completion: @escaping (Result<[PlayerModel], any Error>) -> Void) {
        if shouldReturnWithError {
                    let error = NSError(domain: "MockError", code: 404, userInfo: nil)
                    completion(.failure(error))
                } else {
                    completion(.success([]))
                }
            } 
}
