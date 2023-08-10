//
//  PhotoAlbumViewController.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/09.
//

import UIKit

class PhotoAlbumViewController: UIViewController {
    static func instance<T: PhotoAlbumViewController>() -> T {
        let vc: T = .instance(storyboardName: .photoAlbum)
        return vc
    }
    
    enum Constants {
        static let spacing: CGFloat = 4.0
    }
    
    @IBOutlet private weak var latestItemsButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        // latestItemsButton
        latestItemsButton.setTitle("최근 항목", for: .normal)
        latestItemsButton.setImage(UIImage(named: "icArrowDown"), for: .normal)
        latestItemsButton.setImage(UIImage(named: "icArrowUp"), for: .selected)
        latestItemsButton.setTitleColor(.cheffiBlack, for: .normal)
        latestItemsButton.setTitleColor(.cheffiBlack, for: .selected)
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .white
        config.baseBackgroundColor = .white
        config.imagePlacement = .trailing
        config.imagePadding = Constants.spacing
        latestItemsButton.configuration = config
    }
    
    private func bindViewModel() {
        
    }
    
    // MARK: - Public
    
    // MARK: - Actions
    @IBAction private func didTapColse(_ sender: UIButton) {
        self.dismissOne()
    }
    
    @IBAction private func didTapNext(_ sender: UIButton) {
        
    }
    
    @IBAction private func didTapLatestItems(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
}
