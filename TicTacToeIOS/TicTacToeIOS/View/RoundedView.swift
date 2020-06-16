//
//  RoundedView.swift
//  ChessIOS
//
//  Created by Lukas Holmberg on 2020-06-14.
//  Copyright © 2020 Stefan Holmberg. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundUIView: UIView {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
}
