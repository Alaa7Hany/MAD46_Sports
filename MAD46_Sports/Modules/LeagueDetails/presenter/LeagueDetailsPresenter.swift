import Foundation

protocol LeagueDetailsPresenterProtocol {
    func viewDidLoad()
    
    // Data Source Methods
    func getUpcomingEventsCount() -> Int
    func getUpcomingEvent(at index: Int) -> Event
    
    func getLatestEventsCount() -> Int
    func getLatestEvent(at index: Int) -> Event
    
    func getParticipantsCount() -> Int
    func getParticipant(at index: Int) -> Participant
    func didSelectParticipant(at index: Int)
    
    func getLeagueName() -> String
    
    func isFavorite() -> Bool
    func toggleFavorite() -> Bool
    func getParticipantSectionTitle() -> String
    func didTapFavorite()
}

class LeagueDetailsPresenter: LeagueDetailsPresenterProtocol {
    
    private weak var view: LeagueDetailsViewProtocol?
    private weak var router: AppRouterProtocol?
    private let networkService: NetworkService
    
    // MARK: - Properties
    private let sportName: String
    private let leagueId: Int?
    private let leagueName: String
    private let leagueModel: LeagueModel // ضفنا المتغير ده
    
    // MARK: - State
    private var upcomingEvents: [Event] = []
    private var latestEvents: [Event] = []
    private var participants: [Participant] = []
    
    init(view: LeagueDetailsViewProtocol, networkService: NetworkService, router: AppRouterProtocol, sportName: String, league: LeagueModel) {
            self.view = view
            self.networkService = networkService
            self.router = router
            self.sportName = sportName
            
            self.leagueModel = league
            self.leagueId = league.leagueKey
            self.leagueName = league.leagueName ?? "Unknown"
        }
    
    func viewDidLoad() {
        view?.startLoading()
        fetchLeagueDetails()
    }
    
    // MARK: - Orchestrator
    private func fetchLeagueDetails() {
        let group = DispatchGroup()
        
        fetchParticipants(group: group)
        fetchLatestEvents(group: group)
        fetchUpcomingEvents(group: group)
        
        group.notify(queue: .main) { [weak self] in
            self?.view?.stopLoading()
            self?.view?.displayData()
        }
    }
    
    // MARK: - Isolated Network Calls
    private func fetchParticipants(group: DispatchGroup) {
        group.enter()
        let method = sportName.lowercased() == "tennis" ? "Players" : "Teams"
        
        networkService.getParticipants(sportName: sportName, method: method, leagueId: leagueId) { [weak self] fetched in
            self?.participants = fetched
            group.leave()
        }
    }
    
    private func fetchLatestEvents(group: DispatchGroup) {
            group.enter()
            let from = DateHelper.getPastDateString(for: sportName)
            let to = DateHelper.getTodayString()
            
            networkService.getEvents(sportName: sportName, from: from, to: to, leagueId: leagueId) { [weak self] events in
                guard let self = self else { return }
                self.latestEvents = self.filterPast(events: events)
                group.leave()
            }
        }
        
        private func fetchUpcomingEvents(group: DispatchGroup) {
            group.enter()
            let from = DateHelper.getTodayString()
            let to = DateHelper.getFutureDateString(for: sportName)
            
            networkService.getEvents(sportName: sportName, from: from, to: to, leagueId: leagueId) { [weak self] events in
                guard let self = self else { return }
                self.upcomingEvents = self.filterUpcoming(events: events)
                group.leave()
            }
        }
    
    // MARK: - Array Filtering Helpers
    private func filterPast(events: [Event]) -> [Event] {
        return events.filter { isEventInPast(dateString: $0.eventDate, timeString: $0.eventTime) }
    }
    
    private func filterUpcoming(events: [Event]) -> [Event] {
        return events.filter { !isEventInPast(dateString: $0.eventDate, timeString: $0.eventTime) }
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
    
    // MARK: - Protocol Data Source Implementation
    func getUpcomingEventsCount() -> Int { return upcomingEvents.count }
    func getUpcomingEvent(at index: Int) -> Event { return upcomingEvents[index] }
    
    func getLatestEventsCount() -> Int { return latestEvents.count }
    func getLatestEvent(at index: Int) -> Event { return latestEvents[index] }
    
    func getParticipantsCount() -> Int { return participants.count }
    func getParticipant(at index: Int) -> Participant { return participants[index] }
    
    // MARK: - Navigation Logic
    func didSelectParticipant(at index: Int) {
        let selected = participants[index]
        
        if let id = selected.key {
            router?.navigateToTeamDetails(
                sportName: sportName,
                teamId: id,
                teamName: selected.name ?? "Team",
                teamLogo: selected.logo
            )
        }
    }
    
    // MARK: - Protocol UI Implementation
    func getLeagueName() -> String {
        return self.leagueName
    }
    
    func getParticipantSectionTitle() -> String {
        return sportName.lowercased() == "tennis" ? "Participating Players" : "Participating Teams"
    }
        
    func didTapFavorite() {
        print("❤️ Presenter received favorite tap for \(leagueName)!")
    }
            
    // MARK: - Favorites Logic
        
    func isFavorite() -> Bool {
        guard let id = self.leagueId else { return false }
        
        let id16 = Int16(id)
        return CoreDataManager.shared.isFavorite(id: id16) != nil
    }

    func toggleFavorite() -> Bool {
        let isFav = isFavorite()
        CoreDataManager.shared.toggleLeagueFavoriteStatus(apiLeague: self.leagueModel, sportName: self.sportName)
        
        return !isFav
    }
    
    
}

