//
//  LeagueDetailsViewController+UI.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//

import UIKit
import SkeletonView

extension LeagueDetailsViewController {
    
    func setupLoadingIndicator() {

    }

    func setupCollectionView() {
        let upcomingNib = UINib(nibName: Constants.Cells.upcomingEventCell, bundle: nil)
        collectionView.register(upcomingNib, forCellWithReuseIdentifier: Constants.Cells.upcomingEventCell)

        let latestNib = UINib(nibName: Constants.Cells.latestEventCell, bundle: nil)
        collectionView.register(latestNib, forCellWithReuseIdentifier: Constants.Cells.latestEventCell)

        let teamNib = UINib(nibName: Constants.Cells.teamCollectionCell, bundle: nil)
        collectionView.register(teamNib, forCellWithReuseIdentifier: Constants.Cells.teamCollectionCell)
        
        let headerNib = UINib(nibName: Constants.Cells.sectionHeaderView, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.Cells.sectionHeaderView)
        
        let emptyNib = UINib(nibName: Constants.Cells.emptyStateCell, bundle: nil)
        collectionView.register(emptyNib, forCellWithReuseIdentifier: Constants.Cells.emptyStateCell)
        
        let containerNib = UINib(nibName: "LatestEventsContainerCell", bundle: nil)
        collectionView.register(containerNib, forCellWithReuseIdentifier: "LatestEventsContainerCell")
        
        
        collectionView.isSkeletonable = true
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else { return nil }
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
            
            func getEmptySectionLayout() -> NSCollectionLayoutSection {
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                section.boundarySupplementaryItems = [header]
                return section
            }
            
            if sectionIndex == 0 {
                if self.presenter.getUpcomingEventsCount() == 0 && !self.isLoadingData { return getEmptySectionLayout() }
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(140))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPaging
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                section.boundarySupplementaryItems = [header]
                return section
            } else if sectionIndex == 1 {
                            
                    if self.isLoadingData {
                        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                        let item = NSCollectionLayoutItem(layoutSize: itemSize)
                        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                        let section = NSCollectionLayoutSection(group: group)
                        section.interGroupSpacing = 16
                        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                        section.boundarySupplementaryItems = [header]
                        return section
                    }
                    
                    if self.presenter.getLatestEventsCount() == 0 { return getEmptySectionLayout() }
                    

                    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(320))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                    section.boundarySupplementaryItems = [header]
                    return section
                    
                } else {
                if self.presenter.getParticipantsCount() == 0 && !self.isLoadingData { return getEmptySectionLayout() }
                
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(70))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                section.boundarySupplementaryItems = [header]
                return section
            }
        }
        return layout
    }
}
