//
//  AnimatableView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/2/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//


import UIKit



protocol AnimatableView{
    var bottonConstraint:NSLayoutConstraint{get set}
    
   func slideUpAnimation()
}

extension AnimatableView  where Self: UIView {
   func slideUpAnimation() {
    if superview != nil {
        if bottonConstraint.constant == superview!.bounds.height / 2 {
            }
        }
    }
    

}
