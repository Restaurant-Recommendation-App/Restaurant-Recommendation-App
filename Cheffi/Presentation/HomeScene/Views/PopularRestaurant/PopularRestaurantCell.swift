//
//  PopularRestaurantCell.swift
//  Cheffi
//
//  Created by RONICK on 2023/07/17.
//

import UIKit

class PopularRestaurantCell: UITableViewCell {
    
    private let mainPopularRestaurantView = MainPopularRestaurantView()
    private let popularRestaurantContentsView = PopularRestaurantContentsView()
    
    private let viewMoreContentsButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        button.setTitleColor(.black, for: .normal)
        button.setTitle("전체 보기", for: .normal)
        button.titleLabel?.textAlignment = .center

        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "E2E2E2")?.cgColor
        
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUp()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setUp() {
        contentView.addSubview(mainPopularRestaurantView)
        mainPopularRestaurantView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(400)
        }
        
        contentView.addSubview(popularRestaurantContentsView)
        popularRestaurantContentsView.snp.makeConstraints {
            $0.top.equalTo(mainPopularRestaurantView.snp.bottom).offset(24)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(270)
        }
        
        contentView.addSubview(viewMoreContentsButton)
        viewMoreContentsButton.snp.makeConstraints {
            $0.top.equalTo(popularRestaurantContentsView.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(40)
        }
    }
}
