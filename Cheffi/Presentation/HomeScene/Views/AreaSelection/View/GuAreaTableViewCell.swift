//
//  GuAreaTableViewCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/10/22.
//

import UIKit

class GuAreaTableViewCell: UITableViewCell {
    
    let guAreaName: UILabel = {
        let label = UILabel()
        label.font = Fonts.suit.weight500.size(15)
        label.textColor = .cheffiGray8
        return label
    }()
    
    let checkMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "icUncheck"), for: .normal)
        button.setImage(UIImage(named: "icCheck"), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.isUserInteractionEnabled = false
        return button
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
        
        contentView.addSubview(guAreaName)
        guAreaName.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
        
        contentView.addSubview(checkMarkButton)
        checkMarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-9)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(21)
        }
    }
    
    func configure(areaSelection: AreaSelection) {
        guAreaName.text = areaSelection.areaName
        updateCheckMark(isSelected: areaSelection.isSelected)
    }
    
    func updateCheckMark(isSelected: Bool) {
        checkMarkButton.isSelected = isSelected
    }
}
