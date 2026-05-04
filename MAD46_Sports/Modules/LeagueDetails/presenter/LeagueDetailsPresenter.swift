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
    func didSelectTeam(at index: Int)
    
    func getLeagueName() -> String
    
    func isFavorite() -> Bool
    func toggleFavorite() -> Bool
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    private weak var view: LeagueDetailsViewProtocol?
    private weak var router: AppRouterProtocol?
    private let networkService: NetworkService
    
    private let sportName: String
    private let leagueId: Int
    private let leagueName: String
    
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var teams: [Team] = []
    
    init(view: LeagueDetailsViewProtocol, networkService: NetworkService, router: AppRouterProtocol, sportName: String, leagueId: Int, leagueName: String) {
            self.view = view
            self.networkService = networkService
            self.router = router
            self.sportName = sportName
            self.leagueId = leagueId
            self.leagueName = leagueName    
        }
    
    func viewDidLoad() {
        view?.startLoading()
        fetchLeagueDetails()
    }
    
    private func fetchLeagueDetails() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let today = Date()
        
        let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: today)!
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: today)!
        
        let strToday = formatter.string(from: today)
        let strLastMonth = formatter.string(from: lastMonth)
        let strNextMonth = formatter.string(from: nextMonth)
        
        let group = DispatchGroup()
        
        group.enter()
        networkService.getTeam(sportName: sportName, leagueId: leagueId) { [weak self] fetchedTeams in
            self?.teams = fetchedTeams
            group.leave()
        }
        
        group.enter()
        networkService.getEvents(sportName: sportName, from: strLastMonth, to: strToday, leagueId: leagueId) { [weak self] events in
            let pastEvents = events.filter { event in
                return self?.isEventInPast(dateString: event.eventDate, timeString: event.eventTime) ?? false
            }
            self?.latestEvents = pastEvents
            group.leave()
        }
        
        group.enter()
        networkService.getEvents(sportName: sportName, from: strToday, to: strNextMonth, leagueId: leagueId) { [weak self] events in
            let futureEvents = events.filter { event in
                return !(self?.isEventInPast(dateString: event.eventDate, timeString: event.eventTime) ?? false)
            }
            self?.upcomingEvents = futureEvents
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.stopLoading()
            self?.view?.displayData()
        }
    }
    
    private func isEventInPast(dateString: String?, timeString: String?) -> Bool {
        guard let date = dateString, let time = timeString else { return false }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        
        if let eventDate = formatter.date(from: "\(date) \(time)") {
            return eventDate < Date()
        }
        
        return false
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
    
    func didSelectTeam(at index: Int) {
        let selectedTeam = teams[index]
        router?.navigateToTeamDetails(team: selectedTeam)
    }
    
    func getLeagueName() -> String {
        return self.leagueName
    }
        
    func didTapFavorite() {
        print("❤️ Presenter received favorite tap for \(leagueName)!")
    }
            
    func isFavorite() -> Bool {
            let id16 = Int16(self.leagueId)
            return CoreDataManager.shared.isFavorite(id: id16) != nil
        }

    func toggleFavorite() -> Bool {
            let id16 = Int16(self.leagueId)
            
            let result = CoreDataManager.shared.toggleFavorite(
                id: id16,
                name: self.leagueName,
                logo: nil
            )
            
            return result
        }
    }

