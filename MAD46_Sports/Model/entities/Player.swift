import Foundation

struct Player: Decodable {
    let playerKey: Int?
    let playerName: String?
    
    // Position (Football provides this, Tennis does not)
    let playerType: String?
    
    // Images (Varies by sport)
    let playerImage: String? // Used in Football
    let playerLogo: String?  // Used in Tennis
    
    enum CodingKeys: String, CodingKey {
        case playerKey = "player_key"
        case playerName = "player_name"
        case playerType = "player_type"
        case playerImage = "player_image"
        case playerLogo = "player_logo"
    }
    
    // MARK: - Computed Properties for the UI
    
    var displayImage: String? {
        // Returns the football image if it exists, otherwise falls back to the tennis logo
        return playerImage ?? playerLogo
    }
    
    var displayPosition: String {
        // If the sport doesn't have positions (like Tennis), default to a clean fallback string
        return playerType ?? "Player"
    }
}

// Wrapper for the Alamofire response
struct PlayerResponse: Decodable {
    let result: [Player]?
}
