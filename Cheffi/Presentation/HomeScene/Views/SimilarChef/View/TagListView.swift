//
//  TagListView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit
import SnapKit

class TagButton: UIButton {
    private let defaultTagColor = UIColor(hexString: "9E9E9E")
    private let selectedTagColor = UIColor.red
    
    var isSelectedTag = false {
        didSet {
            self.updateConfiguration()
            self.layerBorderWidth = 1
            self.layerBorderColor = isSelectedTag ? selectedTagColor : defaultTagColor
        }
    }
    
    override func updateConfiguration() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12)
        config.baseForegroundColor = isSelectedTag ? .white : defaultTagColor
        config.baseBackgroundColor = isSelectedTag ? selectedTagColor : .white
        config.title = self.currentTitle
        
        self.configuration = config
    }
}

class TagListView: UIView {
    private var tagList: [String] = []
    private let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private var selectedTagIndexes: [Int] = [] {
        didSet {
            updateTagSelection()
        }
    }
    
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
        stackView.spacing = 8
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(stackView)
        self.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16) // Add offset to trailing as well
        }
    }
    
    func setupTags(_ tagList: [String]) {
        guard !tagList.isEmpty else { return }

        self.tagList = tagList
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, tag) in tagList.enumerated() {
            let button = TagButton()
            button.setTitle(tag, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.layerCornerRadius = 10
            button.clipsToBounds = true
            button.tag = index
            
            button.addTarget(self, action: #selector(tagTapped(_:)), for: .touchUpInside)
            
            stackView.addArrangedSubview(button)
        }
        
        if !tagList.isEmpty {
            selectedTagIndexes = [0]
        }
    }
    
    private func updateTagSelection() {
        for (index, view) in stackView.arrangedSubviews.enumerated() {
            guard let button = view as? TagButton else { continue }
            
            button.isSelectedTag = selectedTagIndexes.contains(index)
        }
    }
    
    @objc private func tagTapped(_ sender: UIButton) {
        if let index = selectedTagIndexes.firstIndex(of: sender.tag) {
            selectedTagIndexes.remove(at: index)
        } else {
            selectedTagIndexes.append(sender.tag)
        }
    }
}
