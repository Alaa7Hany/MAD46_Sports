import Foundation

struct League: Decodable {
    let leagueKey: Int?
    let leagueName: String?
    let leagueLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case leagueKey = "league_key"
        case leagueName = "league_name"
        case leagueLogo = "league_logo"
    }
}

struct LeagueResponse: Decodable {
    let result: [League]?
}
