//
//  BaseView.swift
//  Cheffi
//
//  Created by USER on 2023/07/15.
//

import UIKit

class BaseView: UIView {
    @IBOutlet weak var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private func loadView() {
        let bundle = Bundle(for: type(of: self))
        bundle.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)
        
        guard let content = contentView else { return }
        
        content.frame = self.bounds
        insertSubview(content, at: 0)
        content.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

