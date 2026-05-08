import UIKit

protocol SportsViewProtocol: AnyObject {
    func displaySports()
}


// MARK: - Main View Controller
class SportsViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionview: UICollectionView!
    @IBOutlet weak var btnSound: UIButton!
    @IBOutlet weak var btnTheme: UIButton!
    
    // MARK: Properties
    var presenter: SportsPresenterProtocol!
    private var bannerTimer: Timer?
    private var currentBannerIndex = 0
    private let infiniteMultiplier = 1000
    private var isLoadingData: Bool = true

    // MARK: Lifecycle
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

// MARK: - UI Setup
private extension SportsViewController {
    
    func setupInitialUI() {
        let isDarkMode = UserDefaults.standard.bool(forKey: Constants.Defaults.themeKey)
        let themeIcon = isDarkMode ? Constants.Icons.darkMode : Constants.Icons.lightMode
        btnTheme.setImage(UIImage(systemName: themeIcon), for: .normal)
        let isSoundMuted = UserDefaults.standard.bool(forKey: Constants.Defaults.soundKey)
        let soundIcon = isSoundMuted ? Constants.Icons.soundOff: Constants.Icons.soundOn
        btnSound.setImage(UIImage(systemName: soundIcon), for: .normal)
    }
    
    func setupCollectionViews() {
        let nib = UINib(nibName: Constants.Cells.sportCollectionCell, bundle: nil)
        
        // --- Main Grid Setup ---
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.Cells.sportCollectionCell)
        collectionView.delaysContentTouches = false
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = .zero
        }
        
        // --- Banner Setup ---
        bannerCollectionview.delegate = self
        bannerCollectionview.dataSource = self
        bannerCollectionview.register(nib, forCellWithReuseIdentifier: Constants.Cells.sportCollectionCell)
        bannerCollectionview.isPagingEnabled = true
        bannerCollectionview.showsHorizontalScrollIndicator = false
        
        if let bannerLayout = bannerCollectionview.collectionViewLayout as? UICollectionViewFlowLayout {
            bannerLayout.scrollDirection = .horizontal
            bannerLayout.minimumLineSpacing = 0
            bannerLayout.estimatedItemSize = .zero
        }
    }
}

// MARK: - Actions
extension SportsViewController {
    
    @IBAction func onThemechanged(_ sender: UIButton) {
        SoundManager.shared.playSound(Constants.Sounds.click)

        let isCurrentlyDark = UserDefaults.standard.bool(forKey: Constants.Defaults.themeKey)
        let newDarkModeState = !isCurrentlyDark
        
        UserDefaults.standard.set(newDarkModeState, forKey: Constants.Defaults.themeKey)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.overrideUserInterfaceStyle = newDarkModeState ? .dark : .light
        }
        
        let iconName = newDarkModeState ? Constants.Icons.darkMode : Constants.Icons.lightMode
        btnTheme.setImage(UIImage(systemName: iconName), for: .normal)
        
        
        // animation
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.8,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
        ///////////////////////
    }
    
    @IBAction func onSoundChanged(_ sender: UIButton) {
            
        let isCurrentlyMuted = UserDefaults.standard.bool(forKey: Constants.Defaults.soundKey)
        let newMutedState = !isCurrentlyMuted
        
        UserDefaults.standard.set(newMutedState, forKey: Constants.Defaults.soundKey)
        
        if !newMutedState {
            SoundManager.shared.playSound(Constants.Sounds.click)
        }
        
        let iconName = newMutedState ? Constants.Icons.soundOff : Constants.Icons.soundOn
        btnSound.setImage(UIImage(systemName: iconName), for: .normal)
        
        sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: .allowUserInteraction, animations: {
            sender.transform = .identity
        })
    }
}

// MARK: - Banner Timer Logic
private extension SportsViewController {
    
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
        let count = presenter.getSportsCount()
        guard count > 0 else { return }
        
        let totalItems = count * infiniteMultiplier
        
        if currentBannerIndex >= totalItems - count {
            let middleIndex = (count * infiniteMultiplier) / 2
            currentBannerIndex = middleIndex - (middleIndex % count)
            
            bannerCollectionview.scrollToItem(at: IndexPath(item: currentBannerIndex, section: 0),
                                              at: .centeredHorizontally,
                                              animated: false)
        }
        
        currentBannerIndex += 1
        
        let indexPath = IndexPath(item: currentBannerIndex, section: 0)
        bannerCollectionview.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
    }
}

// MARK: - SportsViewProtocol
extension SportsViewController: SportsViewProtocol {
    func displaySports() {
        self.isLoadingData = false
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.bannerCollectionview.reloadData()
            
            let count = self.presenter.getSportsCount()
            if count > 0 {
                let middleIndex = (count * self.infiniteMultiplier) / 2
                self.currentBannerIndex = middleIndex - (middleIndex % count)
                self.bannerCollectionview.scrollToItem(at: IndexPath(item: self.currentBannerIndex, section: 0), at: .centeredHorizontally, animated: false)
            }
        }
    }
}

// MARK: - UICollectionView DataSource & Delegate
extension SportsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoadingData { return 6 }
        if collectionView == bannerCollectionview {
            return presenter.getSportsCount() * infiniteMultiplier
        }
        return presenter.getSportsCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.sportCollectionCell, for: indexPath) as! SportCollectionViewCell
        
        if isLoadingData {
            cell.lblName.text = ""
            cell.imageV.image = nil
       
            return cell
        } else {
       
        }
        
        let actualIndex = collectionView == bannerCollectionview ? (indexPath.row % presenter.getSportsCount()) : indexPath.row
        let sport = presenter.getSport(at: actualIndex)
        
        cell.lblName.text = sport.sportName
        cell.imageV.image = UIImage(named: sport.sportThumb ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let actualIndex = collectionView == bannerCollectionview ? (indexPath.row % presenter.getSportsCount()) : indexPath.row
        presenter.didSelectSport(at: actualIndex)
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

// MARK: - Passive Animations
extension SportsViewController {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard collectionView == self.collectionView else { return }
        
        cell.transform = CGAffineTransform(translationX: 0, y: 30)
        cell.alpha = 0
        
        let delay = 0.05 * Double(indexPath.row)
        
        UIView.animate(withDuration: 0.5,
                       delay: delay,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.1,
                       options: [.curveEaseOut, .allowUserInteraction], animations: {
            cell.transform = .identity
            cell.alpha = 1
        })
    }
    
    
    // MARK: - Easter Egg Trigger
        override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            if motion == .motionShake {
                // Vibrate the phone to let them know they found a secret!
                let generator = UINotificationFeedbackGenerator()
                generator.notificationOccurred(.success)
                
                // Present the mini-game
                let gameVC = BasketballGameViewController()
                gameVC.modalPresentationStyle = .overFullScreen
                gameVC.modalTransitionStyle = .crossDissolve
                self.present(gameVC, animated: true, completion: nil)
            }
        }
}
