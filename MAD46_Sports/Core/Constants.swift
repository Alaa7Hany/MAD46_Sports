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
        static let onBoardingVC = "OnBoardingViewController"
        static let sportsVC = "SportsViewController"
        static let leaguesVC = "LeaguesViewController"
        static let leagueDetailsVC = "LeagueDetailsViewController"
        static let teamVC = "TeamViewController"
        static let favoritesVC = "FavViewController"
    }
    
    // MARK: - Cell Identifiers
    enum Cells {
        static let sportCollectionCell = "SportCollectionViewCell"
        static let leagueTableCell = "LeagueTableViewCell"
        static let upcomingEventCell = "UpcomingEventCell"  
        static let latestEventCell = "LatestEventCell"
        static let teamCollectionCell = "TeamCell"
        static let sectionHeaderView = "SectionHeaderView"
    }
    
    enum Defaults{
        static let themeKey = "themeKey"
        static let onboarding = "onboarding"
        static let soundKey = "soundKey"
    }
    
    enum Icons{
        static let lightMode = "moon.fill"
        static let darkMode = "sun.max.fill"
        static let soundOff = "speaker.wave.2.fill"
        static let soundOn = "speaker.slash.fill"
    }
}

import UIKit

extension UIView {
    private var shimmerLayerName: String {
        return "shimmerLayer"
    }

    func startShimmering() {
        if layer.sublayers?.contains(where: { $0.name == shimmerLayerName }) == true {
            return
        }

        let lightColor = UIColor(white: 0.85, alpha: 1.0).cgColor
        let darkColor = UIColor(white: 0.95, alpha: 1.0).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [darkColor, lightColor, darkColor]
        gradient.frame = CGRect(x: -bounds.width, y: 0, width: 3 * bounds.width, height: bounds.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.locations = [0.0, 0.5, 1.0]
        gradient.name = shimmerLayerName
        
        layer.addSublayer(gradient)

        let animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.duration = 1.2
        animation.fromValue = -bounds.width
        animation.toValue = bounds.width
        animation.repeatCount = .infinity
        animation.isRemovedOnCompletion = false

        gradient.add(animation, forKey: "shimmer")
    }

    func stopShimmering() {
        layer.sublayers?.filter { $0.name == shimmerLayerName }.forEach {
            $0.removeAllAnimations()
            $0.removeFromSuperlayer()
        }
    }
}
