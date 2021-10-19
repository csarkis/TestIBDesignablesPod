//
//  MyGraphicLibrary+Button.swift
//  GraphicLibrary_Vendored
//
//  Created by Carl Sarkis on 19/10/2021.
//

import UIKit

public extension MyGraphicLibrary {
    @objc(MyGraphicLibraryButton) @IBDesignable class Button: UIButton {
        public override init(frame: CGRect) {
            super.init(frame: frame)
            self.applyStyle()
        }

        /// :nodoc: Creation from the Interface Builder
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            self.applyStyle()
        }

        /// Customize the button
        func applyStyle() {
            self.layer.cornerRadius = 2
            self.backgroundColor =  UIColor.blue
            self.setTitleColor(UIColor.white, for: .normal)
        }
    }
}
