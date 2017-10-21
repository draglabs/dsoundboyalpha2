//
//  PinView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/7/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit


class jamEditorView: UIView {
  var gesture:UISwipeGestureRecognizer!
  let editJamButton = UIButton(type:.system)
  let jamNameTextfield = UITextField()
  let locationtextfield = UITextField()
  let notesTextView = UITextView()
  let doneButton = UIButton(type:.system)
  
  private func editJamUISetup() {
    jamNameTextfield.placeholder = "Name of the jam"
    jamNameTextfield.clearsOnInsertion = true
    jamNameTextfield.textAlignment = .center
    jamNameTextfield.backgroundColor = UIColor.white
    jamNameTextfield.translatesAutoresizingMaskIntoConstraints = false
    
    jamNameTextfield.delegate = self
    locationtextfield.placeholder = "Location of the Jam"
    locationtextfield.clearsOnInsertion = true
    locationtextfield.textAlignment = .center
    locationtextfield.backgroundColor = UIColor.white
    locationtextfield.translatesAutoresizingMaskIntoConstraints = false
    
    locationtextfield.delegate = self
    notesTextView.clearsOnInsertion = true
    notesTextView.text = "Notes"
    notesTextView.textAlignment = .center
    notesTextView.backgroundColor = UIColor.white
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.delegate = self
    notesTextView.resignFirstResponder()
    doneButton.addTarget(self, action: #selector(handleDismiss(sender:)), for: .touchUpInside)
    doneButton.setTitle("DONE", for: .normal)
    doneButton.layer.borderWidth = 2
    doneButton.layer.borderColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1).cgColor
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(jamNameTextfield)
    addSubview(locationtextfield)
    addSubview(notesTextView)
    addSubview(doneButton)
    editJamConstraints()
    layoutIfNeeded()
    doneButton.layer.cornerRadius = doneButton.bounds.height / 2
  }
  private func editJamConstraints() {
    jamNameTextfield.leadingAnchor.constraint(equalTo: leadingAnchor,constant:50).isActive = true
    jamNameTextfield.topAnchor.constraint(equalTo: topAnchor,constant:28).isActive = true
    jamNameTextfield.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-50).isActive = true
    jamNameTextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    locationtextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    locationtextfield.topAnchor.constraint(equalTo: jamNameTextfield.bottomAnchor, constant: 18).isActive = true
    locationtextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    locationtextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    notesTextView.topAnchor.constraint(equalTo: locationtextfield.bottomAnchor, constant: 18).isActive = true
    notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    notesTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100).isActive = true
    doneButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 8).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
    doneButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
  @objc func handleDismiss(sender:UIButton) {
    
  }
  private func prepareForDismissal() {
    becomeFirstResponder()
    NotificationCenter.default.removeObserver(self)
    UIView.animate(withDuration: 0.3, animations: {
      self.jamNameTextfield.alpha = 0
      self.locationtextfield.alpha = 0
      self.notesTextView.alpha = 0
      
    }, completion: {_ in
      self.jamNameTextfield.isHidden = true
      self.locationtextfield.isHidden = true
      self.notesTextView.isHidden = true
      //self.animateDismissal()
      
    })
  }
}


extension jamEditorView:UITextFieldDelegate,UITextViewDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    return true
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.text = ""
  }
  @objc func handleWillShow(notification:NSNotification) {
    // just in case we need it later for animation or frame calculation
  }
}




class ActivityView: UIView {
  let topBarView = UIView()
  let editJamButton = UIButton(type:.system)
  let jamNameTextfield = UITextField()
  let locationtextfield = UITextField()
  let notesTextView = UITextView()
  let doneButton = UIButton(type:.system)
  var gesture:UISwipeGestureRecognizer!
  let location = LocationWorker()
  private var isShown = false
  var pin:String = "" {
    willSet {
      pinLabel.text = newValue
    }
  }
  
  var message = "Share this pin for other \n to join your jam" {
    willSet {
      messageLabel.text = newValue
    }
  }
  
  let messageLabel = UILabel()
  let pinLabel = UILabel()
  
  var parentView:UIView? {
    didSet {
      
    }
  }

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
     gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
    gesture.direction = .up
    addGestureRecognizer(gesture)
    uiSetup()
  }
  
  
  func show(pin:String) {
    gesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
    gesture.direction = .up
    addGestureRecognizer(gesture)
    if !isShown {
    if let parent = parentView {
      self.pin = pin
      parent.addSubview(self)
      
      UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
         self.frame = CGRect(x: 0, y: parent.bounds.midY + 120, width: parent.bounds.width, height:parent.bounds.midY - 120)
      }, completion: {done in })
    }
     uiSetup()
      isShown = true
    }
    
  }
  
  func hide() {
    if isShown {
    UIView.animate(withDuration: 0.6, animations: {
    self.center.y += self.parentView!.bounds.maxY
    }, completion: { done in
      self.removeFromSuperview()
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
    pinLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    pinLabel.text = pin
    pinLabel.textAlignment = .center
    pinLabel.font = UIFont.init(name: "Avenir-Medium", size: 32)
    pinLabel.textColor = .white
    pinLabel.numberOfLines = 10
    
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
    addSubview(pinLabel)
    addSubview(messageLabel)
    addSubview(editJamButton)
    initialConstraints()
    layoutIfNeeded()
    editJamButton.layer.cornerRadius = editJamButton.bounds.height / 2
    editJamUISetup()
    jamNameTextfield.isHidden = true
    locationtextfield.isHidden = true
    notesTextView.isHidden = true
    doneButton.isHidden = true
  }
  
  private func initialConstraints() {
    
    pinLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    pinLabel.topAnchor.constraint(equalTo: topBarView.bottomAnchor, constant: 10).isActive = true
    pinLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    pinLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    messageLabel.topAnchor.constraint(equalTo: pinLabel.bottomAnchor, constant: 0).isActive = true
    messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    messageLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    
    editJamButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor).isActive = true
    editJamButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    editJamButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant:100).isActive = true
    editJamButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
  }
  
  private func editJamUISetup() {
    jamNameTextfield.placeholder = "Name of the jam"
    jamNameTextfield.clearsOnInsertion = true
    jamNameTextfield.textAlignment = .center
    jamNameTextfield.backgroundColor = UIColor.white
    jamNameTextfield.translatesAutoresizingMaskIntoConstraints = false
    
    jamNameTextfield.delegate = self
    locationtextfield.placeholder = "Location of the Jam"
    locationtextfield.clearsOnInsertion = true
    locationtextfield.textAlignment = .center
    locationtextfield.backgroundColor = UIColor.white
    locationtextfield.translatesAutoresizingMaskIntoConstraints = false
    
    locationtextfield.delegate = self
    notesTextView.clearsOnInsertion = true
    notesTextView.text = "Notes"
    notesTextView.textAlignment = .center
    notesTextView.backgroundColor = UIColor.white
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.delegate = self
    notesTextView.resignFirstResponder()
    doneButton.addTarget(self, action: #selector(handleDismiss(sender:)), for: .touchUpInside)
    doneButton.setTitle("DONE", for: .normal)
    doneButton.layer.borderWidth = 2
    doneButton.layer.borderColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1).cgColor
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(jamNameTextfield)
    addSubview(locationtextfield)
    addSubview(notesTextView)
    addSubview(doneButton)
    editJamConstraints()
    layoutIfNeeded()
    doneButton.layer.cornerRadius = doneButton.bounds.height / 2
  }
  
  private func editJamConstraints() {
    jamNameTextfield.leadingAnchor.constraint(equalTo: leadingAnchor,constant:50).isActive = true
    jamNameTextfield.topAnchor.constraint(equalTo: topAnchor,constant:28).isActive = true
    jamNameTextfield.trailingAnchor.constraint(equalTo: trailingAnchor,constant:-50).isActive = true
    jamNameTextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    locationtextfield.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    locationtextfield.topAnchor.constraint(equalTo: jamNameTextfield.bottomAnchor, constant: 18).isActive = true
    locationtextfield.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    locationtextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50).isActive = true
    notesTextView.topAnchor.constraint(equalTo: locationtextfield.bottomAnchor, constant: 18).isActive = true
    notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50).isActive = true
    notesTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    doneButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 100).isActive = true
    doneButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 8).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -100).isActive = true
    doneButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
  @objc func handleEdit(sender:UIButton) {
    prepareForEditJam()
  }
  @objc func handleDismiss(sender:UIButton) {
    prepareForDismissal()
  }
  @objc func handleSwipe(gesture:UISwipeGestureRecognizer) {
    switch gesture.direction {
    case .up:
      prepareForEditJam()
    case .down:
      prepareForDismissal()
    default:
      break
    }
    
  }
  
  private func prepareForEditJam() {
    requestJamDetails()
    gesture.direction = .down
    NotificationCenter.default.addObserver(self, selector: #selector(handleWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
    
    UIView.animate(withDuration: 0.3, animations: {
      self.pinLabel.alpha = 0
      self.messageLabel.alpha = 0
      self.editJamButton.alpha = 0
     
      
    }, completion: {_ in
      
      self.pinLabel.isHidden = true
      self.messageLabel.isHidden = true
      self.editJamButton.isHidden = true
      self.animateToEditjam()
    })
  }
  private func animateToEditjam() {
    
    jamNameTextfield.isHidden = false
    locationtextfield.isHidden = false
    notesTextView.isHidden = false
    doneButton.isHidden = false
    
    UIView.animate(withDuration: 0.5, animations: {
      self.jamNameTextfield.alpha = 1
      self.locationtextfield.alpha = 1
      self.notesTextView.alpha = 1
      self.doneButton.alpha = 1
      
      self.frame = CGRect(x: 0, y:20, width: self.parentView!.bounds.width, height:self.parentView!.bounds.height - 20)
      
    }, completion: {done in
      
    })
  }
  
 private func prepareForDismissal() {
  gesture.direction = .up
    becomeFirstResponder()
    NotificationCenter.default.removeObserver(self)
    UIView.animate(withDuration: 0.3, animations: {
      self.jamNameTextfield.alpha = 0
      self.locationtextfield.alpha = 0
      self.notesTextView.alpha = 0
      
    }, completion: {_ in
      self.jamNameTextfield.isHidden = true
      self.locationtextfield.isHidden = true
      self.notesTextView.isHidden = true
      
      self.animateDismissal()
      
    })
  }
  private func animateDismissal() {
    self.pinLabel.isHidden = false
    self.messageLabel.isHidden = false
    self.editJamButton.isHidden = false
    
    UIView.animate(withDuration: 0.3) {
      self.pinLabel.alpha = 1
      self.messageLabel.alpha = 1
      self.editJamButton.alpha = 1
      self.frame = CGRect(x: 0, y: self.parentView!.bounds.midY + 120, width: self.parentView!.bounds.width, height:self.parentView!.bounds.midY - 120)
    }
  }
}

extension ActivityView:UITextFieldDelegate,UITextViewDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
  
    return true
  }
  func textViewDidBeginEditing(_ textView: UITextView) {
    textView.text = ""
  }
  @objc func handleWillShow(notification:NSNotification) {
    // just in case we need it later for animation or frame calculation
  }
}

extension ActivityView {
  
  func requestJamDetails() {
    
    location.didGetLocation = { location, address in
      self.locationtextfield.text = address.number! + " " + " " + address.street + " " + address.city
      self.notesTextView.text = "Recorded in \(self.locationtextfield.text!)"
    }
    location.requestLocation()
   
  }
}
