import UIKit

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: LeagueDetailsPresenterProtocol!
    private var activityIndicator: UIActivityIndicatorView!
    private var favoriteBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoadingIndicator()
        setupCollectionView()
        setupNavigationBar()
        
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .appPrimary
        
        self.title = presenter.getLeagueName()
        
        favoriteBarButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteBarButton.tintColor = .red
        
        self.navigationItem.rightBarButtonItem = favoriteBarButton
        let isFav = presenter.isFavorite()
        updateFavoriteIcon(isFav: isFav)
    }
    private func updateFavoriteIcon(isFav: Bool) {
            let imageName = isFav ? "heart.fill" : "heart"
            favoriteBarButton.image = UIImage(systemName: imageName)
        }

        @objc private func favoriteButtonTapped() {
            let isFavNow = presenter.toggleFavorite()
            updateFavoriteIcon(isFav: isFavNow)
        }
}

extension LeagueDetailsViewController {
    
    private func setupLoadingIndicator() {
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .systemGreen
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    private func setupCollectionView() {
        let upcomingNib = UINib(nibName: Constants.Cells.upcomingEventCell, bundle: nil)
        collectionView.register(upcomingNib, forCellWithReuseIdentifier: Constants.Cells.upcomingEventCell)

        let latestNib = UINib(nibName: Constants.Cells.latestEventCell, bundle: nil)
        collectionView.register(latestNib, forCellWithReuseIdentifier: Constants.Cells.latestEventCell)


        let teamNib = UINib(nibName: Constants.Cells.teamCollectionCell, bundle: nil)
        collectionView.register(teamNib, forCellWithReuseIdentifier: Constants.Cells.teamCollectionCell)
        
        let headerNib = UINib(nibName: Constants.Cells.sectionHeaderView, bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: Constants.Cells.sectionHeaderView)
        
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
            
            if sectionIndex == 0 {
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
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 16
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 20, trailing: 16)
                section.boundarySupplementaryItems = [header]
                return section
                
            } else {
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
    
        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            
            guard kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: "SectionHeaderView",
                for: indexPath
            ) as! SectionHeaderView
            
            if indexPath.section == 0 {
                header.setup(title: "Upcoming Events")
            } else if indexPath.section == 1 {
                header.setup(title:"Latest Results")
            } else {
                header.setup(title:"Participating Teams")
            }
        }
        return layout
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "SectionHeaderView",
            for: indexPath
        ) as! SectionHeaderView
        
        if indexPath.section == 0 {
            header.setup(title: "Upcoming Events")
        } else if indexPath.section == 1 {
            header.setup(title: "Latest Results")
        } else {
            // 👉 UPDATE: Now gets the dynamic string from the Presenter
            header.setup(title: presenter.getParticipantSectionTitle())
        }
        
        return header
    }
}

// MARK: - LeagueDetailsViewProtocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    
    func startLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.collectionView.isHidden = true
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
        }
    }
    
    func displayData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UICollectionViewDataSource
extension LeagueDetailsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { return presenter.getUpcomingEventsCount() }
        else if section == 1 { return presenter.getLatestEventsCount() }
        else { return presenter.getParticipantsCount() }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.upcomingEventCell, for: indexPath) as! UpcomingEventCell
            cell.setup(with: presenter.getUpcomingEvent(at: indexPath.row))
            return cell
            
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.latestEventCell, for: indexPath) as! LatestEventCell
            cell.setup(with: presenter.getLatestEvent(at: indexPath.row))
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.teamCollectionCell, for: indexPath) as! TeamCell
            cell.setup(with: presenter.getParticipant(at: indexPath.row).logo)
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegate
extension LeagueDetailsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            presenter.didSelectParticipant(at: indexPath.row)
        }
    }
}
