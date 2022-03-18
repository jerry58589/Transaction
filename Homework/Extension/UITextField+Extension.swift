//
//  UITextField+Extension.swift
//  Homework
//
//  Created by JerryLo on 2022/3/14.
//

import Foundation
import UIKit

extension UITextField {
    func setTextFieldUI() {
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.rightViewMode = .always
    }
    
}
