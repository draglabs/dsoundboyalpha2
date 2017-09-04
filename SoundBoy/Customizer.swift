//
//  Customizer.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

final class Customizer: NSObject {
    static func main(nav: UINavigationController) {
        nav.navigationBar.isHidden = false
        nav.navigationBar.isTranslucent = false
        nav.navigationBar.barTintColor = UIColor(colorLiteralRed: 168/255, green: 36/255, blue: 36/255, alpha: 1.0)
        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
        nav.navigationBar.shadowImage = UIImage()
       nav.navigationBar.tintColor = .white
    }
  static func login(nav:UINavigationController) {
      nav.navigationBar.isHidden = true
  }
}
