//
//  ProvinceAreaTableViewCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/22.
//

import UIKit
import SnapKit

final class ProvinceAreaTableViewCell: UITableViewCell {
    
    let provinceTitle: UILabel = {
        let label = UILabel()
        label.font = Fonts.suit.weight500.size(15)
        label.textColor = .cheffiGray6
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        selectionStyle = .none
        
        contentView.addSubview(provinceTitle)
        provinceTitle.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func configure(areaSelection: AreaSelection) {
        provinceTitle.text = areaSelection.areaName
        updateAreaTitle(isSelected: areaSelection.isSelected)
    }
    
    func updateAreaTitle(isSelected: Bool) {
        if isSelected {
            provinceTitle.textColor = .cheffiGray8
            contentView.backgroundColor = .cheffiWhite
        } else {
            provinceTitle.textColor = .cheffiGray6
            contentView.backgroundColor = .cheffiWhite05
        }
    }
}
