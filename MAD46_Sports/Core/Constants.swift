import Foundation

enum Constants {
    
    // MARK: - API Configuration
    enum API {
        static let baseURL = "https://apiv2.allsportsapi.com"
    }
    
    // MARK: - Storyboards
    enum Storyboards {
        static let main = "Main"
    }
    
    // MARK: - ViewController Identifiers
    enum ViewControllers {
        static let mainTabBarVC = "MainTabBarController"
        static let sportsVC = "SportsViewController"
        static let leaguesVC = "LeaguesViewController"
        static let leagueDetailsVC = "LeagueDetailsViewController"
        static let teamDetailsVC = "TeamDetailsViewController"
        static let favoritesVC = "FavoriteLeaguesViewController"
    }
    
    // MARK: - Cell Identifiers
    enum Cells {
        static let sportCollectionCell = "SportCollectionViewCell"
        static let leagueTableCell = "LeagueTableViewCell"
        static let upcomingEventCell = "UpcomingEventCell"  
        static let latestEventCell = "LatestEventCell"
        static let teamCollectionCell = "TeamCell"
    }
        
}
