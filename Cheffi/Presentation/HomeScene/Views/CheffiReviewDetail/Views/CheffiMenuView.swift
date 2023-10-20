//
//  CheffiMenuView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit

class CheffiMenuView: BaseView {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
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
        titleLabel.text = "메뉴".localized()
        titleLabel.font = Fonts.suit.weight700.size(18.0)
        titleLabel.textColor = .cheffiGray9
    }
    
    func setupMenu(_ menus: [MenuDTO]) {
        stackView.arrangedSubviews.forEach({ $0.removeFromSuperview() })
        
        let menuItemViews = menus.map { menu -> CheffiMenuItemView in
            let menuItemView = CheffiMenuItemView()
            menuItemView.set(menu: menu)
            return menuItemView
        }

        let priceMaxWidth = menuItemViews.reduce(0) { max($0, $1.getWidhtOfPriceLabelWidth()) }
        let menuNameMaxWidth = menuItemViews.reduce(0) { max($0, $1.getWidhtOfMenuNameLabelWidth()) }

        menuItemViews.forEach { menuItemView in
            menuItemView.updatePriceLabelWidth(priceMaxWidth)
            menuItemView.updateMenuNameLabelWidth(menuNameMaxWidth)
            stackView.addArrangedSubview(menuItemView)
        }
    }
}
