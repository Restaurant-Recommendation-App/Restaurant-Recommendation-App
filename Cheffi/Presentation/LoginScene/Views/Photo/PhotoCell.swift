//
//  PhotoCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/11.
//

import UIKit

enum PhotoSection {
    case photoSelect
    case photoDeselect
    
    var image: UIImage {
        switch self {
        case .photoSelect:
            return UIImage(named: "icPhotoSelect")!
        case .photoDeselect:
            return UIImage(named: "icPhotoDeselect")!
        }
    }
}

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var cameraImageView: UIImageView!
    @IBOutlet private weak var photoImageView: UIImageView!
    @IBOutlet private weak var selectionImageView: UIImageView!
    @IBOutlet private weak var checkImageView: UIImageView!
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        return indicator
    }()
    var isSelectedState: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLoadingIndicator()
        resetData()
        setupViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetData()
    }
    
    // MARK: - Private
    private func setupViews() {
        contentView.backgroundColor = .cheffiGray1
        selectionImageView.image = PhotoSection.photoDeselect.image
        cameraImageView.image = UIImage(named: "icCameraInCell")
    }
    
    private func setupLoadingIndicator() {
        contentView.addSubview(loadingIndicator)
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    private func resetData() {
        photoImageView.image = nil
        selectionImageView.image = PhotoSection.photoDeselect.image
        isHiddenCameraImage(true)
        isHiddenSelectionImage(true)
        checkImageView.isHidden = true
    }
    
    // MARK: - Public
    func configure(with image: UIImage) {
        self.photoImageView.image = image
    }
    
    func isHiddenCameraImage(_ isHidden: Bool) {
        cameraImageView.isHidden = isHidden
    }
    
    func isHiddenSelectionImage(_ isHidden: Bool) {
        selectionImageView.isHidden = isHidden
    }
    
    func updateSelectionImage() {
        if isSelectedState {
            selectionImageView.image = PhotoSection.photoDeselect.image
            checkImageView.isHidden = true
            contentView.layerBorderColor = .clear
            contentView.layerBorderWidth = 0.0
            isSelectedState = false
        } else {
            selectionImageView.image = PhotoSection.photoSelect.image
            checkImageView.isHidden = false
            contentView.layerBorderColor = .main
            contentView.layerBorderWidth = 2.0
            isSelectedState = true
        }
    }
    
    func resetSelectionState() {
        isSelectedState = false
        selectionImageView.image = PhotoSection.photoDeselect.image
        checkImageView.isHidden = true
        contentView.layerBorderColor = .clear
        contentView.layerBorderWidth = 0.0
    }
    
    func showLoadingIndicator() {
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimating()
    }
}
