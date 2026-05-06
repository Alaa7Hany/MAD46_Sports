import Foundation

 class TeamPresenter {
    weak var view: TeamView?
    private let networkService: NetworkService
    private var players: [PlayerModel] = []
    
    var sportName: String
    var teamId: Int
    var teamName: String
    var teamLogo: String?

    init(view: TeamView, networkService: NetworkService, sportName: String, teamId: Int, teamName: String, teamLogo: String?) {
        self.view = view
        self.networkService = networkService
        self.sportName = sportName
        self.teamId = teamId
        self.teamName = teamName
        self.teamLogo = teamLogo
    }

    func attachView(_ view: TeamView) {
        self.view = view
    }

    func fetchTeamDetails() {

        AlamofireManager.shared.getRoster(
            sportName: sportName,
            teamId: teamId
        ) { [weak self] playersList in
            guard let self = self else { return }

            DispatchQueue.main.async {

                if playersList.isEmpty {
                    self.view?.showError(message: "No players found for this team.")
                } else {
                    self.players = playersList
                    self.view?.reloadData()
                }
            }
        }
    }

    func getTeamName() -> String {
        return teamName
    }

    func getTeamLogo() -> String {
        return teamLogo ?? players.first?.playerLogo ?? ""
    }

    private func normalizedPlayers(for type: String) -> [PlayerModel] {
        players.filter { ($0.playerType ?? "").trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == type.lowercased() }
    }

    func getGoalkeepers() -> [PlayerModel] {
        normalizedPlayers(for: "Goalkeepers")
    }

    func getDefenders() -> [PlayerModel] {
        normalizedPlayers(for: "Defenders")
    }

    func getMidfielders() -> [PlayerModel] {
        normalizedPlayers(for: "Midfielders")
    }

    func getForwards() -> [PlayerModel] {
        normalizedPlayers(for: "Forwards")
    }
}
