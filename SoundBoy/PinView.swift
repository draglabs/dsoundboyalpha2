//
//  PinView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit

class PinView: UIView {
  let topBarView = UIView()
  var pin:String = "495730808"
  let message = "Share this pin for other \n to join your jam"
  let messabeLabel = UILabel()
  let pinLabel = UILabel()
  
  var parentView:UIView?

  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(parent:UIView) {
    self.init()
    self.parentView = parent
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup() {
    uiSetup()
  }
  
  func animateShow() {
   
  }
  
  func displayPin(pin:String) {
    
    if let parent = parentView {
      self.pin = pin
     
      parent.addSubview(self)
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
         self.frame = CGRect(x: 0, y: parent.bounds.midY + 100, width: parent.bounds.width, height:parent.bounds.midY - 160)
      }, completion: {done in })
    }
    uiSetup()
  }

  func uiSetup() {
    
    //self 
    backgroundColor = UIColor(colorLiteralRed: 33/255, green: 47/255, blue: 62/255, alpha: 1)
    // topView
    topBarView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 40)
    topBarView.backgroundColor = UIColor(colorLiteralRed: 168/255, green: 36/255, blue: 36/255, alpha: 1)
    
    //labels 
    pinLabel.translatesAutoresizingMaskIntoConstraints = false
    messabeLabel.translatesAutoresizingMaskIntoConstraints = false
    pinLabel.text = pin
    pinLabel.textAlignment = .center
    pinLabel.font = UIFont.init(name: "Avenir-Medium", size: 32)
    pinLabel.textColor = .white
    pinLabel.numberOfLines = 1
    
    messabeLabel.text = message
    messabeLabel.textAlignment = .center
    messabeLabel.font = UIFont.init(name: "Avenir-Book", size: 15)
    messabeLabel.textColor = .white
    messabeLabel.numberOfLines = 2
    addSubview(topBarView)
    addSubview(pinLabel)
    addSubview(messabeLabel)
    uiConstraints()
  }
  
  func uiConstraints() {
    pinLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    pinLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 20).isActive = true
    pinLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    pinLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    messabeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    messabeLabel.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 8).isActive = true
    messabeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    messabeLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
}
