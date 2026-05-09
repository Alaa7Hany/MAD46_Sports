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
    
    let pageControl = UIPageControl()
    
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
        setupBannerExtras()
        presenter.viewDidLoad()
        startBannerTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        bannerTimer?.invalidate()
    }
    
    // MARK: - Banner Extras (Corner Radius + Shadow + Page Dots)
    func setupBannerExtras() {
        bannerCollectionview.layer.cornerRadius = 16
        bannerCollectionview.clipsToBounds = true
        
        if let superview = bannerCollectionview.superview {
            let shadowContainer = UIView()
            shadowContainer.translatesAutoresizingMaskIntoConstraints = false
            shadowContainer.layer.cornerRadius = 16
            shadowContainer.layer.shadowColor = UIColor.appPrimary.cgColor
            shadowContainer.layer.shadowOpacity = 0.25
            shadowContainer.layer.shadowOffset = CGSize(width: 0, height: 4)
            shadowContainer.layer.shadowRadius = 8
            shadowContainer.layer.masksToBounds = false
            shadowContainer.backgroundColor = .clear
            superview.insertSubview(shadowContainer, belowSubview: bannerCollectionview)
            NSLayoutConstraint.activate([
                shadowContainer.topAnchor.constraint(equalTo: bannerCollectionview.topAnchor),
                shadowContainer.leadingAnchor.constraint(equalTo: bannerCollectionview.leadingAnchor),
                shadowContainer.trailingAnchor.constraint(equalTo: bannerCollectionview.trailingAnchor),
                shadowContainer.bottomAnchor.constraint(equalTo: bannerCollectionview.bottomAnchor)
            ])
        }
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .appPrimary
        pageControl.pageIndicatorTintColor = UIColor.appPrimary.withAlphaComponent(0.3)
        pageControl.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: bannerCollectionview.centerXAnchor),
            pageControl.topAnchor.constraint(equalTo: bannerCollectionview.bottomAnchor, constant: 4)
        ])
    }
    
}

// MARK: - SportsViewProtocol
extension SportsViewController: SportsViewProtocol {
    func displaySports() {
        self.isLoadingData = false
        DispatchQueue.main.async {
            let count = self.presenter.getSportsCount()
            self.pageControl.numberOfPages = count
            
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
