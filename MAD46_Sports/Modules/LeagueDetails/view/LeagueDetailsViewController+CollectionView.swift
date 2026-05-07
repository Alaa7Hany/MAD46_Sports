//
//  LeagueDetailsViewController+CollectionView.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//

import UIKit
import SkeletonView

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return isLoadingData ? 3 : max(1, presenter.getUpcomingEventsCount())
        } else if section == 1 {
            return isLoadingData ? 3 : 1
        } else {
            return isLoadingData ? 6 : max(1, presenter.getParticipantsCount())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            if isLoadingData {
                return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.upcomingEventCell, for: indexPath) as! UpcomingEventCell
            }
            if presenter.getUpcomingEventsCount() == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.emptyStateCell, for: indexPath) as! EmptyStateCell
                cell.setup(message: "No upcoming events", animationName: Constants.Lottie.emptyEvents)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.upcomingEventCell, for: indexPath) as! UpcomingEventCell
            cell.hideSkeleton()
            cell.setup(with: presenter.getUpcomingEvent(at: indexPath.row))
            return cell
            
        } else if indexPath.section == 1 {
            if isLoadingData {
                return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.latestEventCell, for: indexPath) as! LatestEventCell
            }
            
            if presenter.getLatestEventsCount() == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.emptyStateCell, for: indexPath) as! EmptyStateCell
                cell.setup(message: "No recent results", animationName: Constants.Lottie.emptyEvents)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LatestEventsContainerCell", for: indexPath) as! LatestEventsContainerCell
            let latestCount = presenter.getLatestEventsCount()
            let latestEvents = (0..<latestCount).map { presenter.getLatestEvent(at: $0) }
            cell.setup(with: latestEvents)
            return cell
            
        } else {
            if isLoadingData {
                return collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.teamCollectionCell, for: indexPath) as! TeamCell
            }
            if presenter.getParticipantsCount() == 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.emptyStateCell, for: indexPath) as! EmptyStateCell
                cell.setup(message: "No participants found", animationName: Constants.Lottie.emptyEvents)
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.teamCollectionCell, for: indexPath) as! TeamCell
            cell.hideSkeleton()
            cell.setup(with: presenter.getParticipant(at: indexPath.row).logo)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: Constants.Cells.sectionHeaderView,
            for: indexPath
        ) as! SectionHeaderView
        
        if indexPath.section == 0 {
            header.setup(title: "Upcoming Events")
        } else if indexPath.section == 1 {
            header.setup(title: "Latest Results")
        } else {
            header.setup(title: presenter.getParticipantSectionTitle())
        }
        
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 && presenter.getParticipantsCount() > 0 {
            presenter.didSelectParticipant(at: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isLoadingData {
            cell.showAnimatedGradientSkeleton(
                usingGradient: .init(baseColor: .systemGray6),
                animation: nil,
                transition: .crossDissolve(0.25)
            )
        }
    }
}

