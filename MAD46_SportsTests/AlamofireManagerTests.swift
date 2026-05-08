//
//  AlamofireManagerTests.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini11 on 08/05/2026.
//
import XCTest
@testable import MAD46_Sports

final class AlamofireManagerTests: XCTestCase {
    var almoFireObj : AlamofireManager!
    
    override func setUpWithError() throws {
        almoFireObj = AlamofireManager.shared
        }
    override func tearDownWithError() throws {
        almoFireObj = nil
    }
    // MARK: - Success Tests

    func testGetLeaguesFromApi(){
        let ex = expectation(description: "load leagues from api")
        almoFireObj.getLeagues(sportName: "football") { leagues in
            XCTAssertNotNil(leagues)
            XCTAssertGreaterThanOrEqual(leagues.count, 0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)
        
    }
    func testGetEventsFromApi(){
        let ex = expectation(description: "load Events from api")
        almoFireObj.getEvents(sportName: "football", from: "2024-01-01", to: "2024-12-31", leagueId: 205) { events in
            XCTAssertNotNil(events)
            XCTAssertGreaterThanOrEqual(events.count, 0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 8)


    }
    func testGetParticipantsFromApi(){
        let ex = expectation(description: "load Participants from api")
        almoFireObj.getParticipants(sportName: "football", method: "Teams", leagueId: 205) { participants in
            XCTAssertNotNil(participants)
            XCTAssertGreaterThanOrEqual(participants.count, 0)
            ex.fulfill()

        }
        waitForExpectations(timeout: 10)

    }
    func testGetRostersFromApi(){
        let ex = expectation(description: "load Rosters from api")
        almoFireObj.getRoster(sportName: "football", teamId: 2611) { players in
            XCTAssertNotNil(players)
            XCTAssertGreaterThanOrEqual(players.count, 0)
            ex.fulfill()
        }
        waitForExpectations(timeout: 5)

    }
    // MARK: - Failure Tests
            
        func testGetLeaguesFromApi_Failure() {
            let ex = expectation(description: "load leagues failure from api")
            almoFireObj.getLeagues(sportName: "invalid sport") { leagues in
                XCTAssertNotNil(leagues)
                XCTAssertTrue(leagues.isEmpty, "Should return empty array on failure")
                ex.fulfill()
            }
            waitForExpectations(timeout: 5)
        }
        
        func testGetEventsFromApi_Failure() {
            let ex = expectation(description: "load Events failure from api")
            almoFireObj.getEvents(sportName: "invalid sport", from: "2024-01-01", to: "2024-12-31", leagueId: 205) { events in
                XCTAssertNotNil(events)
                XCTAssertTrue(events.isEmpty, "Should return empty array on failure")
                ex.fulfill()
            }
            waitForExpectations(timeout: 5)
        }
        
        func testGetParticipantsFromApi_Failure() {
            let ex = expectation(description: "load Participants failure from api")
            almoFireObj.getParticipants(sportName: "invalid sport", method: "Teams", leagueId: 205) { participants in
                XCTAssertNotNil(participants)
                XCTAssertTrue(participants.isEmpty, "Should return empty array on failure")
                ex.fulfill()
            }
            waitForExpectations(timeout: 5)
        }
        
        func testGetRostersFromApi_Failure() {
            let ex = expectation(description: "load Rosters failure from api")
            almoFireObj.getRoster(sportName: "invalid sport", teamId: 2611) { players in
                XCTAssertNotNil(players)
                XCTAssertTrue(players.isEmpty, "Should return empty array on failure")
                ex.fulfill()
            }
            waitForExpectations(timeout: 5)
        }
    // MARK: - Nil Parameter Tests
        
        func testGetEventsFromApi_NilLeagueId() {
            let ex = expectation(description: "load Events with nil league ID")
            almoFireObj.getEvents(sportName: "football", from: "2024-01-01", to: "2024-12-31", leagueId: nil) { events in
                XCTAssertNotNil(events)
                ex.fulfill()
            }
            waitForExpectations(timeout: 8)
        }
        
        func testGetParticipantsFromApi_NilLeagueId() {
            let ex = expectation(description: "load Participants with nil league ID")
            almoFireObj.getParticipants(sportName: "football", method: "Teams", leagueId: nil) { participants in
                XCTAssertNotNil(participants)
                ex.fulfill()
            }
            waitForExpectations(timeout: 8)
        }
}
