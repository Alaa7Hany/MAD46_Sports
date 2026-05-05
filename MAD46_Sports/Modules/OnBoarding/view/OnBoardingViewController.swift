import UIKit

class OnBoardingViewController: UIViewController, OnBoardingView {
    
    var presenter: OnBoardingPresenter!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func skipBtn(_ sender: Any) {
        presenter.finishOnBoarding()
    }
    
    
    var currentPage = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == presenter.getCountPages() - 1 {
                nextButton.setTitle("Start Now", for: .normal)
            } else {
                nextButton.setTitle("Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
            super.viewDidLoad()
            collectionView.delegate = self
            collectionView.dataSource = self
            pageControl.numberOfPages = presenter.getCountPages()
            
            collectionView.isPagingEnabled = true
            collectionView.showsHorizontalScrollIndicator = false
            
            if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.estimatedItemSize = .zero
            }
        }
    

    @IBAction func nextButtonClicked(_ sender: UIButton) {
        if currentPage == presenter.getCountPages() - 1 {
            presenter.finishOnBoarding()
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

extension OnBoardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.getCountPages()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCell", for: indexPath) as! OnboardingCollectionViewCell
        
        let page = presenter.getPage(at: indexPath.row)
        cell.setup(page)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        
        guard width > 0 else { return }
        
        let page = Int((scrollView.contentOffset.x + (width / 2)) / width)
        
        if currentPage != page {
            currentPage = page
        }
    }
    

}

