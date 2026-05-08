import UIKit

class OnboardingContentViewController: UIViewController {
    
    let pageModel: OnBoardingModel
    let pageIndex: Int
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        label.textColor = UIColor.white.withAlphaComponent(0.85)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    init(pageModel: OnBoardingModel, pageIndex: Int) {
        self.pageModel = pageModel
        self.pageIndex = pageIndex
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        setupAnimations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        
        view.addSubview(textStackView)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            textStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -140),
            textStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            textStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func configureContent() {
        backgroundImageView.image = UIImage(named: pageModel.image)
        titleLabel.text = pageModel.title
        descriptionLabel.text = pageModel.desc
    }
    
    private func setupAnimations() {
        titleLabel.alpha = 0
        descriptionLabel.alpha = 0
        titleLabel.transform = CGAffineTransform(translationX: 0, y: 20)
        descriptionLabel.transform = CGAffineTransform(translationX: 0, y: 20)
    }
    
    private func startAnimations() {
        UIView.animate(withDuration: 0.6, delay: 0.1, options: .curveEaseOut, animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = .identity
        })
        
        UIView.animate(withDuration: 0.6, delay: 0.3, options: .curveEaseOut, animations: {
            self.descriptionLabel.alpha = 1
            self.descriptionLabel.transform = .identity
        })
    }
}

class OnBoardingViewController: UIViewController, OnBoardingView {
    
    var presenter: OnBoardingPresenter!
    
    private var pageViewController: UIPageViewController!
    private var contentControllers: [OnboardingContentViewController] = []
    
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .white
        pc.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.4)
        pc.isUserInteractionEnabled = false
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    private lazy var getStartedButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AppPrimary") ?? .systemBlue
        button.layer.cornerRadius = 25
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getStartedTapped), for: .touchUpInside)
        
        button.layer.shadowColor = UIColor(named: "AppPrimary")?.cgColor ?? UIColor.systemBlue.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.4
        
        return button
    }()
    
    private lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AppPrimary") ?? .systemBlue
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupData()
        setupPageViewController()
        setupUI()
    }
    
    private func setupData() {
        for index in 0..<presenter.getCountPages() {
            let pageModel = presenter.getPage(at: index)
            let vc = OnboardingContentViewController(pageModel: pageModel, pageIndex: index)
            contentControllers.append(vc)
        }
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        if let firstVC = contentControllers.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupUI() {
        view.addSubview(pageControl)
        view.addSubview(getStartedButton)
        view.addSubview(skipButton)
        
        pageControl.numberOfPages = presenter.getCountPages()
        pageControl.currentPage = 0
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            skipButton.widthAnchor.constraint(equalToConstant: 80),
            skipButton.heightAnchor.constraint(equalToConstant: 40),
            
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func getStartedTapped() {
        presenter.finishOnBoarding()
    }
    
    @objc private func skipTapped() {
        presenter.finishOnBoarding()
    }
    
    private func updateUI(for pageIndex: Int) {
        pageControl.currentPage = pageIndex
        let isLastPage = pageIndex == presenter.getCountPages() - 1
        
        UIView.animate(withDuration: 0.3) {
            self.pageControl.alpha = isLastPage ? 0 : 1
            self.getStartedButton.alpha = isLastPage ? 1 : 0
            self.skipButton.alpha = isLastPage ? 0 : 1
        }
    }
}

extension OnBoardingViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingContentViewController else { return nil }
        var index = currentVC.pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        return contentControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? OnboardingContentViewController else { return nil }
        var index = currentVC.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == presenter.getCountPages() {
            return nil
        }
        
        return contentControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed, let visibleVC = pageViewController.viewControllers?.first as? OnboardingContentViewController {
            updateUI(for: visibleVC.pageIndex)
        }
    }
}
