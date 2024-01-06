//
//  CategoryView.swift
//  Cheffi
//
//  Created by RONICK on 2023/12/17.
//

import UIKit
import SnapKit

// TODO: 공통 컴포넌트로 앱 전체 적용 필요
class CategoryCell: UICollectionViewCell {
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = Fonts.suit.weight400.size(15)
        label.textColor = .cheffiGray5
        
        return label
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .cheffiGray10
        
        return view
    }()
    
    var selectedState: Bool = false {
        didSet { didChangeCategory() }
    }
    
    override var isSelected: Bool {
        didSet { selectedState = isSelected }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        contentView.addSubview(title)
        title.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        contentView.addSubview(borderView)
        borderView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
    
    func configure(title: String) {
        self.title.text = title
    }
    
    private func didChangeCategory() {
        if selectedState {
            title.font = Fonts.suit.weight700.size(15)
            title.textColor = .cheffiBlack
            borderView.backgroundColor = .cheffiBlack
            
            borderView.snp.updateConstraints {
                $0.height.equalTo(2)
            }
        } else {
            title.font = Fonts.suit.weight400.size(15)
            title.textColor = .cheffiGray5
            borderView.backgroundColor = .cheffiGray10
            
            borderView.snp.updateConstraints {
                $0.height.equalTo(1)
            }
        }
    }
}

class CategoryView: UICollectionView {
    weak var categoryDelegate: CategoryTabViewDelegate?
    
    var categories: [SearchCategory] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
        
    private func setupCollectionView() {
        delegate = self
        dataSource = self
        
        register(cellWithClass: CategoryCell.self)
    }
    
    func configure(categories: [SearchCategory]) {
        self.categories = categories
        reloadData()
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withClass: CategoryCell.self, for: indexPath)
        cell.isSelected.toggle()
        
        categoryDelegate?.didTapCategory(index: indexPath.item)
    }
}

// MARK: - UICollectionViewDelegate
extension CategoryView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CategoryCell.self, for: indexPath)
        cell.configure(title: categories[indexPath.item].title)
        
        if indexPath.item == 0 {
            selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width / CGFloat(categories.count)
        return CGSize(width: width, height: bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
