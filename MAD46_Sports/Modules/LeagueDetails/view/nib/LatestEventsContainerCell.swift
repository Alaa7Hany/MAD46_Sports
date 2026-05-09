//
//  LatestEventsContainerCell.swift
//  MAD46_Sports
//
//  Created by JETSMobileLabMini3 on 07/05/2026.
//

import UIKit

class LatestEventsContainerCell: UICollectionViewCell {

    // MARK: - Outlets
    @IBOutlet weak var innerCollectionView: UICollectionView!
    
    // MARK: - Properties
    private var latestEvents: [Event] = []
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupInnerCollectionView()
    }
    
    private func setupInnerCollectionView() {
        innerCollectionView.dataSource = self
        innerCollectionView.delegate = self
        innerCollectionView.backgroundColor = .clear
        innerCollectionView.showsVerticalScrollIndicator = false
        
        let latestNib = UINib(nibName: Constants.Cells.latestEventCell, bundle: nil)
        innerCollectionView.register(latestNib, forCellWithReuseIdentifier: Constants.Cells.latestEventCell)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 100)
        innerCollectionView.collectionViewLayout = layout
    }
    
    func setup(with events: [Event]) {
        self.latestEvents = events
        self.innerCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource & Delegate
extension LatestEventsContainerCell: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return latestEvents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.latestEventCell, for: indexPath) as! LatestEventCell
        
        cell.setup(with: latestEvents[indexPath.row])
        return cell
    }
}
