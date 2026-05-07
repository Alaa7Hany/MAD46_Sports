import UIKit
import SkeletonView

class LeagueDetailsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter: LeagueDetailsPresenterProtocol!
    private var favoriteBarButton: UIBarButtonItem!
    var isLoadingData: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNavigationBar()
        
        presenter.viewDidLoad()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .appPrimary
        self.title = presenter.getLeagueName()
        
        favoriteBarButton = UIBarButtonItem(
            image: UIImage(systemName: Constants.Icons.noFav),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteBarButton.tintColor = .red
        self.navigationItem.rightBarButtonItem = favoriteBarButton
        
        updateFavoriteIcon(isFav: presenter.isFavorite())
    }
    
    private func updateFavoriteIcon(isFav: Bool) {
        let imageName = isFav ? Constants.Icons.isFav : Constants.Icons.noFav
        favoriteBarButton.image = UIImage(systemName: imageName)
    }

    @objc private func favoriteButtonTapped() {
        SoundManager.shared.playSound(Constants.Sounds.fav)
        let isFavNow = presenter.toggleFavorite()
        updateFavoriteIcon(isFav: isFavNow)
    }
}


// MARK: - LeagueDetailsViewProtocol
extension LeagueDetailsViewController: LeagueDetailsViewProtocol {
    func startLoading() {
        DispatchQueue.main.async {
            self.isLoadingData = true
            self.collectionView.reloadData()
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isLoadingData = false
            self.collectionView.collectionViewLayout.invalidateLayout()
            self.collectionView.reloadData()
        }
    }
    
    func displayData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

