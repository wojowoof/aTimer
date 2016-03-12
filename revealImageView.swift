//
//  revealImageView.swift
//  aTimer
//
//  Created by Jack Woychowski on 3/5/16.
//  Copyright © 2016 Jack Woychowski. All rights reserved.
//

import UIKit

class revealImageView: UIImageView {
    let coverlayer = CAShapeLayer()
    var coverpct : Float = 0.0

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        // coverlayer.path = UIBezierPath(roundedRect: CGRect(x:64, y:64, width: 120, height:240), byRoundingCorners: UIRectCorner.AllCorners, cornerRadii: CGSize(width:15.0, height:15.0)).CGPath
        coverPercent(coverpct)
        coverlayer.fillColor = UIColor.magentaColor().CGColor
        self.layer.addSublayer(coverlayer)
    }

    func coverPercent(pct: Float) {
        print("Set cover to \(pct)%")
        coverpct = pct
        let superbounds = self.bounds
        // let bottomLeft = CGPoint(x: superbounds.origin.x, y: superbounds.origin.y)
        // let coverSize = CGSize(width: superbounds.size.width / 2, height: superbounds.size.height / 2)
        let bottomLeft = CGPoint(x: superbounds.origin.x, y: superbounds.size.height)
        let coverSize = CGSize(width: superbounds.size.width,
            height: 0 - CGFloat(Float(superbounds.size.height) * pct / 100.0))
        print("Super: \(superbounds.origin) - \(superbounds.size)")
        print("Box: origin \(bottomLeft) cover \(coverSize)")
        coverlayer.path = UIBezierPath(rect: CGRect(origin: bottomLeft, size: coverSize)).CGPath
    }

}
