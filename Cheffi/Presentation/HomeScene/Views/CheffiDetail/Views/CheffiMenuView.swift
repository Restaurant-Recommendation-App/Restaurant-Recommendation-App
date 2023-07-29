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
    }
    
    func setupMenu(_ menus: [Menu]) {
        stackView.arrangedSubviews.forEach({
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        })
        
        menus.forEach({ menu in
            let menuItem = CheffiMenuItemView()
            menuItem.set(menu: menu)
            stackView.addArrangedSubview(menuItem)
        })
    }
}
