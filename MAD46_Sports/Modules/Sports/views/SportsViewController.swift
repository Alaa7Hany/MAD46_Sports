import UIKit

protocol SportsViewProtocol: AnyObject {
    func displaySports()
}

// MARK: - Main View Controller
class SportsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionview: UICollectionView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnTheme: UIButton!
    
    var presenter: SportsPresenterProtocol!
    var bannerTimer: Timer?
    var currentBannerIndex = 0
    let infiniteMultiplier = 1000
    var isLoadingData: Bool = true

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialUI()
        setupCollectionViews()
        presenter.viewDidLoad()
        startBannerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerTimer?.invalidate()
    }
}

// MARK: - SportsViewProtocol
extension SportsViewController: SportsViewProtocol {
    func displaySports() {
        self.isLoadingData = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.bannerCollectionview.reloadData()
            
            let count = self.presenter.getBannersCount()
            if count > 0 {
                let middleIndex = (count * self.infiniteMultiplier) / 2
                self.currentBannerIndex = middleIndex - (middleIndex % count)
                self.bannerCollectionview.scrollToItem(at: IndexPath(item: self.currentBannerIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
}
