//
//  TopAlignedLabel.swift
//  ZhihuDiary
//
//  Created by Jonathan Lin on 2015/6/20.
//  Copyright © 2015年 LittleLin. All rights reserved.
//

import UIKit

@IBDesignable class TopAlignedLabel: UILabel {
    override func drawTextInRect(rect: CGRect) {
        if let stringText = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = self.lineBreakMode;
            let stringTextAsNSString: NSString = stringText as NSString
            let labelStringSize = stringTextAsNSString.boundingRectWithSize(CGSizeMake(CGRectGetWidth(self.frame), CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName:self.font,NSParagraphStyleAttributeName: paragraphStyle],
                context: nil).size
            super.drawTextInRect(CGRectMake(0, 0, CGRectGetWidth(self.frame), labelStringSize.height))
        } else {
            super.drawTextInRect(rect)
        }
    }
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.layer.borderWidth = 1
    }
}