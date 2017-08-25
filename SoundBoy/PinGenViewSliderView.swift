//
//  PinGenViewSliderView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/6/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class PinGenViewSliderView: UIView {
    let pinLabel = UILabel()
   
    let pinInfoLabel = UILabel()
    var willAnimate:(()->())?
    


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {

    }

    func setupConstraint() {
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        pinLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pinLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        pinLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
    func didAnimate() {
        shouldShowPin()
    }
    
    
    func shouldShowPin() {
        
    }
    
}
