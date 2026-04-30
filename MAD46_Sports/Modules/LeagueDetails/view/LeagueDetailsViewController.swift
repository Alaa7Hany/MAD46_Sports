//
//  LeagueDetailsViewController.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 30/04/2026.
//

import UIKit

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var upcomingEvents: [Event] = []
    var latestEvents: [Event] = []
    var teams: [Team] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let upcomingNib = UINib(nibName: "UpcomingEventCell", bundle: nil)
        collectionView.register(upcomingNib, forCellWithReuseIdentifier: "UpcomingEventCell")

        let latestNib = UINib(nibName: "LatestEventCell", bundle: nil)
        collectionView.register(latestNib, forCellWithReuseIdentifier: "LatestEventCell")

        let teamNib = UINib(nibName: "TeamCell", bundle: nil)
        collectionView.register(teamNib, forCellWithReuseIdentifier: "TeamCell")
        collectionView.dataSource = self
            collectionView.collectionViewLayout = createCompositionalLayout()
        
        loadDummyData()
    }
    
    // MARK: - Compositional Layout Setup
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            if sectionIndex == 0 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(120))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                return section
            }
            
            else if sectionIndex == 1 {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                

                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                return section
            }
            else {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(70))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                return section
            }
        }
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return upcomingEvents.count
        } else if section == 1 {
            return latestEvents.count
        } else {
            return teams.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UpcomingEventCell", for: indexPath) as! UpcomingEventCell
            let event = upcomingEvents[indexPath.row]
            cell.setup(with: event)
            return cell
            
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventCell", for: indexPath) as! LatestEventCell
            let event = latestEvents[indexPath.row]
            cell.setup(with: event)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TeamCell", for: indexPath) as! TeamCell
            let team = teams[indexPath.row]
            cell.setup(with: team.teamLogo)
            return cell
        }
    }
    
    // MARK: - Dummy Data Setup
        func loadDummyData() {
            
            let arsenalLogo = "https://upload.wikimedia.org/wikipedia/en/thumb/5/53/Arsenal_FC.svg/120px-Arsenal_FC.svg.png"
            let chelseaLogo = "https://upload.wikimedia.org/wikipedia/en/thumb/c/cc/Chelsea_FC.svg/120px-Chelsea_FC.svg.png"
            let liverpoolLogo = "https://upload.wikimedia.org/wikipedia/en/thumb/0/0c/Liverpool_FC.svg/120px-Liverpool_FC.svg.png"
            
            let team1 = Team(teamKey: 1, teamName: "Arsenal", teamLogo: arsenalLogo)
            let team2 = Team(teamKey: 2, teamName: "Chelsea", teamLogo: chelseaLogo)
            let team3 = Team(teamKey: 3, teamName: "Liverpool", teamLogo: liverpoolLogo)
            
            self.teams = [team1, team2, team3, team1, team2, team3]
            
            let upcoming1 = Event(
                eventKey: 101, eventTime: "21:00", eventDate: "2026-05-15", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Arsenal", eventAwayTeam: "Chelsea",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: arsenalLogo, awayTeamLogo: chelseaLogo,
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            )
            
            let upcoming2 = Event(
                eventKey: 102, eventTime: "18:30", eventDate: "2026-05-18", eventDateStart: nil,
                eventFinalResult: nil, eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Chelsea", eventAwayTeam: "Liverpool",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: chelseaLogo, awayTeamLogo: liverpoolLogo,
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            )
            
            self.upcomingEvents = [upcoming1, upcoming2, upcoming1]
            
            // 4. Populate Latest Events (These need scores!)
            let latest1 = Event(
                eventKey: 201, eventTime: "20:00", eventDate: "2026-04-28", eventDateStart: nil,
                eventFinalResult: "3 - 1", eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Liverpool", eventAwayTeam: "Arsenal",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: liverpoolLogo, awayTeamLogo: arsenalLogo,
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            )
            
            let latest2 = Event(
                eventKey: 202, eventTime: "16:00", eventDate: "2026-04-25", eventDateStart: nil,
                eventFinalResult: "0 - 0", eventHomeFinalResult: nil, eventAwayFinalResult: nil,
                eventHomeTeam: "Chelsea", eventAwayTeam: "Arsenal",
                eventFirstPlayer: nil, eventSecondPlayer: nil,
                homeTeamLogo: chelseaLogo, awayTeamLogo: arsenalLogo,
                eventHomeTeamLogo: nil, eventAwayTeamLogo: nil, eventFirstPlayerLogo: nil, eventSecondPlayerLogo: nil
            )
            
            self.latestEvents = [latest1, latest2, latest1, latest2]
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
}
