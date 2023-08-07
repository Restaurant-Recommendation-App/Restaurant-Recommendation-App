//
//  ProfileSetupViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/07.
//

import UIKit
import Combine

protocol ProfileSetupDelegate {
    func didTapNext()
}

class ProfileSetupViewController: UIViewController {
    static func instance<T: ProfileSetupViewController>(viewModel: ProfileSetupViewModel) -> T {
        let vc: T = .instance(storyboardName: .profileSetup)
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet private weak var progressView: UIProgressView!
    @IBOutlet private weak var contentView: UIView!
    private var pageViewController: UIPageViewController!
    private var viewControllersList: [UIViewController] = []
    private var viewModel: ProfileSetupViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    enum Constants {
        static let progressBackgroundColor = UIColor(hexString: "D9D9D9")
        static let progressTintColor = UIColor(hexString: "D82231")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupPageViewController()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        // Progress
        progressView.trackTintColor = Constants.progressBackgroundColor
        progressView.progressTintColor = Constants.progressTintColor
    }
    
    private func setupPageViewController() {
        let nicknameVC = NicknameViewController.instance()
        nicknameVC.delegate = self
        let profilePhotoVC = ProfilePhotoViewController.instance()
        profilePhotoVC.delegate = self
        let foodSelectionVC = FoodSelectionViewController.instance()
        foodSelectionVC.delegate = self
        let preferenceVC = PreferenceViewController.instance()
        preferenceVC.delegate = self
        let followSelectionVC = FollowSelectionViewController.instance()
        followSelectionVC.delegate = self
        viewControllersList = [
            nicknameVC,
            profilePhotoVC,
            foodSelectionVC,
            preferenceVC,
            followSelectionVC
        ]
        
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        if let scrollView = pageViewController.view.subviews.filter({ $0 is UIScrollView }).first as? UIScrollView {
            scrollView.isScrollEnabled = false
        }

        if let firstViewController = viewControllersList.first {
            pageViewController.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
        addChild(pageViewController)
        contentView.addSubview(pageViewController.view)
        pageViewController.view.frame = contentView.bounds
        pageViewController.didMove(toParent: self)
    }
    
    private func bindViewModel() {
        viewModel.output.progress
            .sink { [weak self] progress in
                self?.progressView.setProgress(progress, animated: true)
            }
            .store(in: &cancellables)
        
        viewModel.output.currentPage
            .sink { [weak self] index in
                guard let self = self, index < self.viewControllersList.count else { return }
                let viewController = self.viewControllersList[index]
                let currentVCIndex = self.viewControllersList.firstIndex(of: self.pageViewController.viewControllers?.first ?? viewController) ?? 0
                let direction: UIPageViewController.NavigationDirection = currentVCIndex < index ? .forward : .reverse
                self.pageViewController.setViewControllers([viewController], direction: direction, animated: true, completion: nil)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public
    
    // MAKR: - Actions
    @IBAction private func didTapBack(_ sender: UIButton) {
        let currentPage = viewModel.output.currentPage.value
        if currentPage == 0 {
            self.dismissOrPop()
        } else {
            viewModel.input.previousButtonTapped.send()
        }
    }
}

extension ProfileSetupViewController: ProfileSetupDelegate {
    func didTapNext() {
        if viewModel.output.currentPage.value == viewControllersList.count - 1 {
            self.dismissAll()
        } else {
            viewModel.input.nextButtonTapped.send()
        }
    }
}

// MARK: - UIPageViewControllerDelegate, UIPageViewControllerDataSource
extension ProfileSetupViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllersList[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index < (viewControllersList.count - 1) else {
            return nil
        }
        return viewControllersList[index + 1]
    }
}
