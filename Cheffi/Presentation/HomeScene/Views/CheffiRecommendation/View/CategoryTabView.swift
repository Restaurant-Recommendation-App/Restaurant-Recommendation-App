//
//  CategoryTabView.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/21.
//

import UIKit
import SnapKit

class TabButton: UIButton {
    private let defaultTabColor = UIColor(hexString: "9E9E9E")
    private let selectedTabColor = UIColor(hexString: "D82231")
    
    private let borderLayer = CALayer()
    
    var isSelectedTab = false {
        didSet {
            self.updateConfiguration()
            if isSelectedTab {
                removeBorder(layer: borderLayer)
                addBottomBorderWithColor(layer: borderLayer, color: UIColor(hexString: "D82231")!, width: 2)
            } else {
                removeBorder(layer: borderLayer)
            }
        }
    }
    
    override func updateConfiguration() {
        var config = UIButton.Configuration.filled()
        config.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        config.baseForegroundColor = isSelectedTab ? selectedTabColor : defaultTabColor
        config.baseBackgroundColor = .clear
        
        let attributedContainer = AttributeContainer(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: isSelectedTab ? .bold :.regular)]
        )
        
        config.attributedTitle = AttributedString(
            self.currentTitle ?? "",
            attributes: attributedContainer
        )
        self.configuration = config
    }
}

class CategoryTabView: UIView {
    
    private let scrollView = UIScrollView()
    
    private var selectedTab = 0
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let tabsBottomBoder: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        scrollView.showsHorizontalScrollIndicator = false
        
        addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(tabStackView)
        
        tabStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(scrollView)
        }
        
        scrollView.addSubview(tabsBottomBoder)
        tabsBottomBoder.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
        }
        scrollView.sendSubviewToBack(tabsBottomBoder)
    }
    
    func setUpCategories(categories: [String]) {
        let buttons = categories.enumerated().map {
            let button = TabButton()
            button.setTitle($0.element, for: .normal)
            button.titleLabel?.textAlignment = .center
            button.addTarget(self, action: #selector(tappedCategory(_:)), for: .touchUpInside)
            button.tag = $0.offset
            button.isSelectedTab = false
            return button
        }
        
        tabStackView.addArrangedSubviews(buttons)
            
        layoutIfNeeded()
        tabsBottomBoder.addBottomBorderWithColor(layer: CALayer(), color: UIColor(hexString: "F5F5F5")!, width: 2)
        buttons.first?.isSelectedTab = true
    }
    
    @objc func tappedCategory(_ sender: UIButton) {
        guard let deselectedButton = tabStackView.arrangedSubviews
            .first(where: { ($0 as? TabButton)?.isSelectedTab ?? false }) as? TabButton
        else { return }
        deselectedButton.isSelectedTab = false
        
        guard let button = sender as? TabButton else { return }
        button.isSelectedTab = true
    }
    
}
