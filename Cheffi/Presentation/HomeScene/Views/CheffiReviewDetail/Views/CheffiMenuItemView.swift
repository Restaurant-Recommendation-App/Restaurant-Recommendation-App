//
//  CheffiMenuItemView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/07/29.
//

import UIKit

class LineDashView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        createDottedLine(width: 1.0, color: UIColor.cheffiGray2.cgColor)
    }
    
    func createDottedLine(width: CGFloat, color: CGColor) {
        layer.sublayers?.forEach { if type(of: $0) == CAShapeLayer.self { $0.removeFromSuperlayer() } }
            
        let caShapeLayer = CAShapeLayer()
        caShapeLayer.strokeColor = color
        caShapeLayer.lineWidth = width
        caShapeLayer.lineDashPattern = [2, 3]
        let cgPath = CGMutablePath()
        
        let center = self.frame.height / 2
        let cgPoint = [CGPoint(x: 0, y: center), CGPoint(x: self.frame.width, y: center)]
        cgPath.addLines(between: cgPoint)
        caShapeLayer.path = cgPath
        layer.addSublayer(caShapeLayer)
    }
}

class CheffiMenuItemView: UIView {
    
    private let menuNameLabel: UILabel = {
        let label = UILabel()
        label.text = "-"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .cheffiGray8
        return label
    }()
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "원"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = .cheffiGray7
        label.textAlignment = .right
        return label
    }()
    private let lineDashView: LineDashView = {
       let view = LineDashView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        return view
    }()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 16
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func set(menu: MenuDTO) {
        menuNameLabel.text = menu.name
        priceLabel.text = menu.price.commaRepresentation + "원"
    }
    
    func updatePriceLabelWidth(_ width: CGFloat) {
        priceLabel.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
    
    func updateMenuNameLabelWidth(_ width: CGFloat) {
        menuNameLabel.snp.updateConstraints { make in
            make.width.equalTo(width)
        }
    }
    
    func getWidhtOfPriceLabelWidth() -> CGFloat {
        return self.getWidthOfLabel(label: self.priceLabel)
    }
    
    func getWidhtOfMenuNameLabelWidth() -> CGFloat {
        return self.getWidthOfLabel(label: self.menuNameLabel)
    }
    
    // MARK: - Private
    private func setupViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(menuNameLabel)
        stackView.addArrangedSubview(lineDashView)
        stackView.addArrangedSubview(priceLabel)
        
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        }
    }
    
    private func getWidthOfLabel(label: UILabel) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: label.frame.height)
        let boundingBox = label.text!.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: label.font!], context: nil)

        return ceil(boundingBox.width)
    }
}
