//
//  ViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 28/04/2026.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AlamofireManager.shared.getLeagues(sportName: "football") { leagues in
            print(leagues.first?.leagueName)
        }
        AlamofireManager.shared.getEvents(sportName: "football", from: "2026-04-28", to: "2026-05-15", leagueId: 177) { events in
            print(events.first?.displayHomeName)
            print(events.first?.displayAwayName)
        }
        AlamofireManager.shared.getTeam(sportName: "football", leagueId: 177) { teams in
            print(teams.count)
            print(teams.first?.teamName)
          
           
            
        }
        view.backgroundColor = .appPrimary

    }
}

