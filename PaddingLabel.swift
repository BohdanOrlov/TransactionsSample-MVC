//
//  PaddingLabel.swift
//  LootInterview
//
//  Created by Thomas Angistalis on 22/08/2018.
//  Copyright © 2018 Thomas Angistalis. All rights reserved.
//

import UIKit

@IBDesignable open class PaddingLabel: UILabel {
    
    @IBInspectable var topInset: CGFloat = 4.0
    @IBInspectable var bottomInset: CGFloat = 4.0
    @IBInspectable var leftInset: CGFloat = 4.0
    @IBInspectable var rightInset: CGFloat = 4.0
    
    override open func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    override open var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}
