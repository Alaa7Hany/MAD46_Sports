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
       testCoreData()
    }
func testCoreData(){
    let manager = CoreDataManager.shared
        
     
        manager.saveLeague(id: 1, name: "Premier League", logo: nil)
        manager.saveLeague(id: 2, name: "La Liga", logo: nil)
    manager.deleteLeague(league: manager.fetchLeague()[0])
        
    let leagues = manager.fetchLeague()
        
        print(" Data from CoreData:")
        
        for league in leagues {
            print("ID:", league.leagueId)
            print("Name:", league.leagueName ?? "")
            print("----------")
        }
    }

}

