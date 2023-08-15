//
//  PhotoCell.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/11.
//

import UIKit

enum PhotoSelectionState {
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
    private var dimView: UIView = {
        let view: UIView = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return view
    }()
    var isSelectedState: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        selectionImageView.image = PhotoSelectionState.photoDeselect.image
        cameraImageView.image = UIImage(named: "icCameraInCell")
        contentView.insertSubview(dimView, belowSubview: selectionImageView)
        dimView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func resetData() {
        photoImageView.image = nil
        isHiddenCameraImage(true)
        isHiddenSelectionImage(true)
        resetSelectionState()
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
        dimView.isHidden = isSelectedState
        if isSelectedState {
            selectionImageView.image = PhotoSelectionState.photoDeselect.image
            checkImageView.isHidden = true
            contentView.layerBorderColor = .clear
            contentView.layerBorderWidth = 0.0
            isSelectedState = false
        } else {
            selectionImageView.image = PhotoSelectionState.photoSelect.image
            checkImageView.isHidden = false
            contentView.layerBorderColor = .main
            contentView.layerBorderWidth = 2.0
            isSelectedState = true
        }
    }
    
    func resetSelectionState() {
        isSelectedState = false
        selectionImageView.image = PhotoSelectionState.photoDeselect.image
        checkImageView.isHidden = true
        contentView.layerBorderColor = .clear
        contentView.layerBorderWidth = 0.0
        dimView.isHidden = true
    }
}
