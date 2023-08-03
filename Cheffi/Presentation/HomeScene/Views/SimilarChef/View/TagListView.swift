//
//  TagListView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import SnapKit

class TagButton: UIButton {
    private let defaultTagColor = UIColor(hexString: "EDEDED")
    private let defaultTextColor = UIColor.cheffiGray5
    private let selectedTagColor = UIColor.main
    
    var isSelectedTag = false {
        didSet {
            self.updateConfiguration()
            self.layerBorderWidth = 1
            self.layerBorderColor = isSelectedTag ? selectedTagColor : defaultTagColor
        }
    }
    
    override func updateConfiguration() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16)
        config.baseForegroundColor = isSelectedTag ? .cheffiWhite : defaultTextColor
        config.baseBackgroundColor = isSelectedTag ? selectedTagColor : .cheffiWhite
        config.title = self.currentTitle
        
        self.configuration = config
    }
}

class TagListView: UIView {
    enum Constants {
        static let spacing: CGFloat = 8.0
        static let leftInset: CGFloat = 16
        static let rightInset: CGFloat = -16
    }
    
    private var tagList: [String] = []
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private var selectedTagIndexes: [Int] = [] {
        didSet {
            updateTagSelection()
        }
    }
    
    var didTapTagsHandler: (([String]) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.spacing = Constants.spacing
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(Constants.leftInset)
            make.trailing.equalToSuperview().offset(Constants.rightInset)
            make.height.equalTo(scrollView)
        }
    }
    
    func setupTags(_ tagList: [String]) {
        guard !tagList.isEmpty else { return }

        self.tagList = tagList
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let selectedCategories = UserDefaultsManager.HomeSimilarChefInfo.categories
        debugPrint("------------------------------------------")
        debugPrint("저장된 카테고리 리스트 - ", selectedCategories)
        debugPrint("------------------------------------------")
        
        for (index, tag) in tagList.enumerated() {
            let button = TagButton()
            button.setTitle(tag, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layerCornerRadius = 15
            button.clipsToBounds = true
            button.tag = index
            
            button.addTarget(self, action: #selector(didTapTag(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
        
        // UserDefaults에서 가져온 카테고리 리스트에 따라 selectedTagIndexes를 설정
        selectedTagIndexes = tagList.indices.filter { selectedCategories.contains(tagList[$0]) }
    }
    
    private func updateTagSelection() {
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            guard let button = view as? TagButton else { continue }
            
            button.isSelectedTag = selectedTagIndexes.contains(index)
        }
    }
    
    @objc private func didTapTag(_ sender: UIButton) {
        if let index = selectedTagIndexes.firstIndex(of: sender.tag) {
            selectedTagIndexes.remove(at: index)
        } else {
            selectedTagIndexes.append(sender.tag)
        }
        
        didTapTagsHandler?(selectedTagIndexes.map({ self.tagList[$0] }))
    }
}
