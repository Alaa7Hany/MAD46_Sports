//
//  TeamSection.swift
//  SportFolio
//
//  Created by JETSMobileLabMini2 on 01/05/2026.
//


import UIKit

enum TeamSection: Int, CaseIterable {
    case goalkeepers
    case defenders
    case midfielders
    case forwards

    var title: String {
        switch self {
        case .goalkeepers: return NSLocalizedString("TEAM_SECTION_GOALKEEPERS", comment: "")
        case .defenders: return NSLocalizedString("TEAM_SECTION_DEFENDERS", comment: "")
        case .midfielders: return NSLocalizedString("TEAM_SECTION_MIDFIELDERS", comment: "")
        case .forwards: return NSLocalizedString("TEAM_SECTION_FORWARDS", comment: "")
        }
    }

    var icon: String {
        switch self {
        case .goalkeepers: return "🧤"
        case .defenders: return "🛡️"
        case .midfielders: return "⚽"
        case .forwards: return "⚡"
        }
    }

    var badgeText: String {
        switch self {
        case .goalkeepers: return NSLocalizedString("TEAM_BADGE_GK", comment: "")
        case .defenders: return NSLocalizedString("TEAM_BADGE_DEF", comment: "")
        case .midfielders: return NSLocalizedString("TEAM_BADGE_MID", comment: "")
        case .forwards: return NSLocalizedString("TEAM_BADGE_FWD", comment: "")
        }
    }

    var badgeColor: UIColor {
        switch self {
        case .goalkeepers: return UIColor(red: 0.72, green: 0.49, blue: 0.10, alpha: 1.0)
        case .defenders: return UIColor.systemGreen
        case .midfielders: return UIColor.systemBlue
        case .forwards: return UIColor.systemRed
        }
    }
}