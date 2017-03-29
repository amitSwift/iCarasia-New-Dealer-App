//
//  CustomImageView.swift
//  looped
//
//  Created by Amit Verma  on 12/28/16.
//  Copyright © 2016 Divya Khanna. All rights reserved.
//

import UIKit
import QuartzCore

class CustomImageView: UIImageView {

    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth   = borderWidth
        }
    }
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor   = borderColor?.cgColor
        }
    }

}
