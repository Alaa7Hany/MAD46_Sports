//
//  SportsViewController+CollectionView.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 08/05/2026.
//
import UIKit

// MARK: - Collection View Setup & Banner Timer
extension SportsViewController {
    
    func setupCollectionViews() {
        let nib = UINib(nibName: Constants.Cells.sportCollectionCell, bundle: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.Cells.sportCollectionCell)
        collectionView.delaysContentTouches = false
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
        
        let bannerNib = UINib(nibName: Constants.Cells.bannerCell, bundle: nil)
        bannerCollectionview.delegate = self
        bannerCollectionview.dataSource = self
        bannerCollectionview.register(bannerNib, forCellWithReuseIdentifier: Constants.Cells.bannerCell)
        bannerCollectionview.isPagingEnabled = true
        bannerCollectionview.showsHorizontalScrollIndicator = false
        
        if let bannerLayout = bannerCollectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            bannerLayout.scrollDirection = .horizontal
            bannerLayout.minimumLineSpacing = 0
            bannerLayout.estimatedItemSize = .zero
        }
    }
    
    func startBannerTimer() {
        bannerTimer?.invalidate()
        bannerTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.scrollToNextBanner()
        }
        if let timer = bannerTimer {
            RunLoop.main.add(timer, forMode: .common)
        }
    }

    func scrollToNextBanner() {
        let count = presenter.getBannersCount()
        guard count > 0 else { return }
        
        let totalItems = count * infiniteMultiplier
        
        if currentBannerIndex >= totalItems - count {
            let middleIndex = (count * infiniteMultiplier) / 2
            currentBannerIndex = middleIndex - (middleIndex % count)
            bannerCollectionview.scrollToItem(at: IndexPath(item: currentBannerIndex, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        currentBannerIndex += 1
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionview.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadingData { return 6 }
        if collectionView == bannerCollectionview {
            return presenter.getBannersCount() * infiniteMultiplier
        }
        return presenter.getSportsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        if collectionView == bannerCollectionview {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.bannerCell, for: indexPath) as! BannerCollectionViewCell
            
            if isLoadingData {
                cell.bannerImageView.image = nil
                return cell
            }
            
            let actualIndex = indexPath.row % presenter.getBannersCount()
            let imageName = presenter.getBanner(at: actualIndex)
            cell.bannerImageView.image = UIImage(named: imageName)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sportCollectionCell, for: indexPath) as! SportCollectionViewCell
            
            if isLoadingData {
                cell.lblName.text = ""
                cell.imageV.image = nil
                return cell
            }
            
            let sport = presenter.getSport(at: indexPath.row)
            cell.lblName.text = NSLocalizedString(sport.sportName ?? "", comment: "")
            cell.imageV.image = UIImage(named: sport.sportThumb ?? "")
            return cell
        }
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == bannerCollectionview {
            return
        }
        presenter.didSelectSport(at: indexPath.row)
    }
    
    // Passive Animations
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard collectionView == self.collectionView else { return }
        
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        cell.alpha = 0
        let delay = 0.05 * Double(indexPath.row)
        
        UIView.animate(withDuration: 0.5, delay: delay, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: [.curveEaseOut, .allowUserInteraction], animations: {
            cell.transform = .identity
            cell.alpha = 1
        })
    }
}

// MARK: - UICollectionView Delegate FlowLayout
extension SportsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == bannerCollectionview {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
        } else {
            let padding: CGFloat = 10
            let availableWidth = collectionView.bounds.width - (padding * 3)
            let cellWidth = availableWidth / 2
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView == bannerCollectionview ? 0 : 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView == bannerCollectionview ? .zero : UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

// MARK: - UIScrollViewDelegate (Manual Scroll Tracking)
extension SportsViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionview {
            bannerTimer?.invalidate()
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == bannerCollectionview {
            let pageWidth = scrollView.bounds.width
            guard pageWidth > 0 else { return }
            
            currentBannerIndex = Int(round(scrollView.contentOffset.x / pageWidth))
            startBannerTimer()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == bannerCollectionview && !decelerate {
            let pageWidth = scrollView.bounds.width
            guard pageWidth > 0 else { return }
            
            currentBannerIndex = Int(round(scrollView.contentOffset.x / pageWidth))
            startBannerTimer()
        }
    }
}
