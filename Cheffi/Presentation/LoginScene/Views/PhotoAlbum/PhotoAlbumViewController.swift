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
    @IBOutlet private weak var arrowImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindViewModel()
    }
    
    // MARK: - Private
    private func setupViews() {
        latestItemsButton.setTitle("최근 항목", for: .normal)
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
        arrowImageView.image = sender.isSelected ? UIImage(named: "icArrowUp") : UIImage(named: "icArrowDown")
        // TODO: - 최근 항목 리스트 나오는 View 추가
    }
}
