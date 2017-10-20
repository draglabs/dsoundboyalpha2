//
//  JoinStartView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/30/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit

class JoinStartJamView: UIView {
  let joinButton = UIButton(type: .system)
  let jamButton  = UIButton(type: .system)

    var didPressedJoin:((_ bottomView:JoinStartJamView,_ join:UIButton)->())?
    var didPressedJam:((_ bottomView:JoinStartJamView,_ jam:UIButton)->())?
  
    fileprivate let buttonColor = UIColor(displayP3Red: 160/255, green: 16/255, blue: 33/255, alpha: 1)
    
    func setup() {
      clipsToBounds = true
        setupButtons()
    }
  
    convenience init() {
        self.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func setupButtons() {
    
        jamButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(jamButton)
        addSubview(joinButton)
        setupConstraints()
    
        // buttons
        jamButton.layer.borderColor  = UIColor.white.cgColor
        jamButton.layer.borderWidth = 1
        jamButton.backgroundColor = buttonColor
        jamButton.tintColor = UIColor.white
    
        joinButton.layer.borderColor = UIColor.white.cgColor
        joinButton.layer.borderWidth = 1
        joinButton.backgroundColor = buttonColor
        joinButton.tintColor = UIColor.white
    
        // radius on buttons 
        layoutIfNeeded()
        jamButton.layer.cornerRadius = jamButton.bounds.height / 2
        joinButton.layer.cornerRadius = joinButton.bounds.height / 2
    
        // titles and font for buttons 
        jamButton.setTitle ("Rec",  for: .normal)
        joinButton.setTitle("Join", for: .normal)
    
    
        setupConstraints()
        addButtonActions()
    
    }
    
    func setupConstraints() {
        jamButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant:-20).isActive = true
        jamButton.topAnchor.constraint(equalTo: topAnchor, constant:20).isActive = true
        jamButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        jamButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
        joinButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant:20).isActive = true
        joinButton.topAnchor.constraint(equalTo: topAnchor, constant:20).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    // button actions
    func addButtonActions() {
        joinButton.addTarget(self, action: #selector(joinButtonPressed(sender:)), for: .touchUpInside)
        jamButton.addTarget(self, action: #selector(jamButtonPressed(sender:)), for: .touchUpInside)
    }
  
  func updateJamButton(isJamActive:Bool) {
    if isJamActive {
      joinButton.setTitle("Exit Jam", for: .normal)
    }else {
      joinButton.setTitle("Join", for: .normal)
    }
  }
}


//MARK:button actions
extension JoinStartJamView {
    
  @objc func jamButtonPressed(sender:UIButton) {
        didPressedJam?(self,sender)
    }
  @objc func joinButtonPressed(sender:UIButton) {
        didPressedJoin?(self, sender)
    }
}
