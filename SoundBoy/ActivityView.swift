//
//  PinView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit



class ActivityView: UIView {
  var gesture:UISwipeGestureRecognizer!
  @IBOutlet weak  var messageLabel:UILabel!
  @IBOutlet weak var titleLabel:UILabel!
  
  var prepareForEditJam:(()->())?
  var isShown = false {
    didSet {
      self.titleLabel.isHidden = isShown ? false : true
    }
  }
  var title:String = "" {
    willSet {
      titleLabel.text = newValue

    }
  }
  
  var message = "Share this pin for other \n to join your jam" {
    willSet {
      messageLabel.text = newValue
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override func awakeFromNib() {
    super.awakeFromNib()
    setup()
  }
  
  func setup() {
     gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
    gesture.direction = .up
    addGestureRecognizer(gesture)
    titleLabel.isHidden = true
    
  }
  
  func show(title:String,message:String) {
    titleLabel.text = title
    messageLabel.text = message
  
  }
  
  @objc func handleSwipe(gesture:UISwipeGestureRecognizer) {
    prepareForEditJam?()
  }
  

}

