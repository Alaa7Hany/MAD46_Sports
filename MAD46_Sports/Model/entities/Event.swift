import Foundation

struct Event: Decodable {
    let eventKey: Int?
    let eventTime: String?
    
    // Dates
    let eventDate: String?
    let eventDateStart: String?
    
    // Results
    let eventFinalResult: String?
    let eventHomeFinalResult: String?
    let eventAwayFinalResult: String?
    
    // Competitor Names (Teams vs. Players)
    let eventHomeTeam: String?
    let eventAwayTeam: String?
    let eventFirstPlayer: String?
    let eventSecondPlayer: String?
    
    // Logos
    let homeTeamLogo: String?
    let awayTeamLogo: String?
    let eventHomeTeamLogo: String?
    let eventAwayTeamLogo: String?
    let eventFirstPlayerLogo: String?
    let eventSecondPlayerLogo: String?
    
    enum CodingKeys: String, CodingKey {
        case eventKey = "event_key"
        case eventTime = "event_time"
        
        case eventDate = "event_date"
        case eventDateStart = "event_date_start"
        
        case eventFinalResult = "event_final_result"
        case eventHomeFinalResult = "event_home_final_result"
        case eventAwayFinalResult = "event_away_final_result"
        
        case eventHomeTeam = "event_home_team"
        case eventAwayTeam = "event_away_team"
        case eventFirstPlayer = "event_first_player"
        case eventSecondPlayer = "event_second_player"
        
        case homeTeamLogo = "home_team_logo"
        case awayTeamLogo = "away_team_logo"
        case eventHomeTeamLogo = "event_home_team_logo"
        case eventAwayTeamLogo = "event_away_team_logo"
        case eventFirstPlayerLogo = "event_first_player_logo"
        case eventSecondPlayerLogo = "event_second_player_logo"
    }
    
    // MARK: - Computed Properties for the UI
    // Your UI cells will ONLY use these properties!
    
    var displayHomeName: String? {
        return eventHomeTeam ?? eventFirstPlayer
    }
    
    var displayAwayName: String? {
        return eventAwayTeam ?? eventSecondPlayer
    }
    
    var displayHomeLogo: String? {
        return homeTeamLogo ?? eventHomeTeamLogo ?? eventFirstPlayerLogo
    }
    
    var displayAwayLogo: String? {
        return awayTeamLogo ?? eventAwayTeamLogo ?? eventSecondPlayerLogo
    }
    
    var displayDate: String? {
        return eventDate ?? eventDateStart
    }
    
    var displayResult: String? {
        // Football, Basketball, Tennis (e.g., "2 - 1" or "86 - 71")
        if let combined = eventFinalResult, !combined.isEmpty, combined != "-" {
            return combined
        }
        
        // Cricket (e.g., "197/6 - 188/7")
        if let homeScore = eventHomeFinalResult, let awayScore = eventAwayFinalResult {
            return "\(homeScore) - \(awayScore)"
        }
        
        // Match hasn't happened yet
        return "VS"
    }
}

// Wrapper for the Alamofire response
struct EventResponse: Decodable {
    let result: [Event]?
}
