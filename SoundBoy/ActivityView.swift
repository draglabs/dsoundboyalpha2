//
//  PinView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit



class ActivityView: UIView {
  let topBarView = UIView()
  let editJamButton = UIButton(type:.system)
  var gesture:UISwipeGestureRecognizer!
  private let messageLabel = UILabel()
  private let titleLabel = UILabel()
  var parentView:UIView?
  var prepareForEditJam:(()->())?
  private var isShown = false
  
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
 
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  convenience init(parent:UIView) {
    self.init()
    self.isHidden = true
    self.parentView = parent
    parent.addSubview(self)
    setup()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func setup() {
     gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
    gesture.direction = .up
    addGestureRecognizer(gesture)
    
    uiSetup()
    
  }
  
  
  func show(title:String,isPin:Bool) {
    if !isShown {
    if let parent = parentView {
      self.title = title
      if self.isHidden {
        self.isHidden = false
      }else {
        parent.addSubview(self)
      }
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
         self.frame = CGRect(x: 0, y: parent.bounds.midY + 120, width: parent.bounds.width, height:parent.bounds.midY - 120)
      }, completion: {done in })
    }
      //uiSetup()
      isShown = true
    }
    if !isPin {
      editJamButton.isHidden = true
    }else {
      editJamButton.isHidden = false
    }
  }
  
  func hide() {
    if isShown {
    UIView.animate(withDuration: 0.6, animations: {
    self.center.y += self.parentView!.bounds.maxY
    }, completion: { done in
      self.isHidden = true
    })
      isShown = false
    }
  }

  private func uiSetup() {
    
    //global
    backgroundColor = UIColor(displayP3Red: 33/255, green: 47/255, blue: 62/255, alpha: 1)
    
    // topView
    topBarView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 20)
    topBarView.backgroundColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1)
    
    setupInitialView()
   
  }
  
  private func setupInitialView() {
    //labels
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.text = title
    titleLabel.textAlignment = .center
    titleLabel.font = UIFont.init(name: "Avenir-Medium", size: 32)
    titleLabel.textColor = .white
    titleLabel.numberOfLines = 10
    
    // Message lable
    messageLabel.text = message
    messageLabel.textAlignment = .center
    messageLabel.font = UIFont.init(name: "Avenir-Book", size: 15)
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 2
    
    editJamButton.translatesAutoresizingMaskIntoConstraints = false
    editJamButton.setTitle("Edit current jam", for: .normal)
    
    editJamButton.layer.borderWidth = 2
    editJamButton.layer.borderColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1).cgColor
    editJamButton.setTitleColor(UIColor.white, for: .normal)
    editJamButton.addTarget(self, action: #selector(handleEdit(sender:)), for: .touchDragInside)
    
    
    addSubview(topBarView)
    addSubview(titleLabel)
    addSubview(messageLabel)
    addSubview(editJamButton)
    initialConstraints()
    layoutIfNeeded()
    editJamButton.layer.cornerRadius = editJamButton.bounds.height / 2
  
  
  }
  
  private func initialConstraints() {
    
    titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    titleLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 10).isActive = true
    titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    titleLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
    messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    messageLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    editJamButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
    editJamButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    editJamButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant:100).isActive = true
    editJamButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
  }
  

  
  @objc func handleEdit(sender:UIButton) {
    prepareForEditJam?()
  }
 
  @objc func handleSwipe(gesture:UISwipeGestureRecognizer) {
    prepareForEditJam?()
  }
  

}

