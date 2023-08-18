//
//  CircleCropView.swift
//  Cheffi
//
//  Created by Juhyun Seo on 2023/08/13.
//

import UIKit

class CircleCropView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var circleInset: CGRect {
        let rect = bounds
        let minSize = min(rect.width, rect.height)
        let hole = CGRect(x: (rect.width - minSize) / 2, y: (rect.height - minSize) / 2, width: minSize, height: minSize).insetBy(dx: 15, dy: 15)
        return hole
    }

    override public func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.saveGState()

        let holeInset = circleInset
        
        // 전체 뷰 영역에 색 채움
        context.setFillColor(UIColor.black.withAlphaComponent(0.4).cgColor)
        context.fill(rect)
        
        // 원형의 영역을 제거
        context.setFillColor(UIColor.clear.cgColor)
        context.setBlendMode(.clear)
        context.fillEllipse(in: holeInset)
        
        // 원형의 테두리
        context.setStrokeColor(UIColor.white.cgColor)
        context.setBlendMode(.normal)
        context.strokeEllipse(in: holeInset)
        
        context.restoreGState()
    }
}
