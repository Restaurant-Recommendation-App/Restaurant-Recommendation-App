//
//  ProfileTagListView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 10/2/23.
//

import UIKit

final class ProfileTagListView: BaseView {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var layout: LeftAlignedCollectionViewFlowLayout!
    private var tags: [String] = []
    private var selectedTags: [String] = []
    var didTapTagsHandler: (([String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Private
    private func setupViews() {
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 12
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(nibWithCellClass: ProfileTagCell.self)
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Public
    func setupTags(_ tags: [String]) {
        guard !tags.isEmpty else { return }
        self.tags = tags
        self.collectionView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ProfileTagListView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: ProfileTagCell.self, for: indexPath)
        cell.setTagName(with: tags[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = tags[indexPath.item]
        let padding: CGFloat = 45
        let width = text.size(withAttributes: [NSAttributedString.Key.font: Fonts.suit.weight500.size(15)]).width + padding
        return CGSize(width: width, height: 36)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.item]
        selectedTags.append(tag)
        didTapTagsHandler?(selectedTags)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let tag = tags[indexPath.item]
        if let index = selectedTags.firstIndex(of: tag) {
            selectedTags.remove(at: index)
        }
        didTapTagsHandler?(selectedTags)
    }
}


class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)
        
        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }
            
            layoutAttribute.frame.origin.x = leftMargin
            
            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY, maxY)
        }
        
        return attributes
    }
}
