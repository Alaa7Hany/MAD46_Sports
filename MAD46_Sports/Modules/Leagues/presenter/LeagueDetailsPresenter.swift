//
//  LeagueDetailsPresenter.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import Foundation

protocol LeagueDetailsPresenterProtocol {
    func viewDidLoad()
    
    func getUpcomingEventsCount() -> Int
    func getUpcomingEvent(at index: Int) -> Event
    
    func getLatestEventsCount() -> Int
    func getLatestEvent(at index: Int) -> Event
    
    func getTeamsCount() -> Int
    func getTeam(at index: Int) -> Team
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    private weak var view: LeagueDetailsViewProtocol?
    private let networkService: NetworkService
    
    private let sportName: String
    private let leagueId: Int
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    init(view: LeagueDetailsViewProtocol, networkService: NetworkService = AlamofireManager.shared, sportName: String, leagueId: Int) {
        self.view = view
        self.networkService = networkService
        self.sportName = sportName
        self.leagueId = leagueId
    }
    
    func viewDidLoad() {
        view?.startLoading()
        fetchLeagueDetails()
    }
    
    private func fetchLeagueDetails() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        let lastYear = Calendar.current.date(byAdding: .year, value: -1, to: today)!
        let nextYear = Calendar.current.date(byAdding: .year, value: 1, to: today)!
        
        let strToday = formatter.string(from: today)
        let strLastYear = formatter.string(from: lastYear)
        let strNextYear = formatter.string(from: nextYear)
        
        let group = DispatchGroup()
        
        group.enter()
        networkService.getTeam(sportName: sportName, leagueId: leagueId) { [weak self] fetchedTeams in
            self?.teams = fetchedTeams
            group.leave()
        }
        
        group.enter()
        networkService.getEvents(sportName: sportName, from: strLastYear, to: strToday, leagueId: leagueId) { [weak self] events in
            self?.latestEvents = events
            group.leave()
        }
        
        group.enter()
        networkService.getEvents(sportName: sportName, from: strToday, to: strNextYear, leagueId: leagueId) { [weak self] events in
            self?.upcomingEvents = events
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.stopLoading()
            self?.view?.displayData()
        }
    }
    
    
    func getUpcomingEventsCount() -> Int {
        return upcomingEvents.count
    }
    
    func getUpcomingEvent(at index: Int) -> Event {
        return upcomingEvents[index]
    }
    
    func getLatestEventsCount() -> Int {
        return latestEvents.count
    }
    
    func getLatestEvent(at index: Int) -> Event {
        return latestEvents[index]
    }
    
    func getTeamsCount() -> Int {
        return teams.count
    }
    
    func getTeam(at index: Int) -> Team {
        return teams[index]
    }
}
