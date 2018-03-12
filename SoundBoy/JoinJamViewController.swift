//
//  JoinJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.


import UIKit

protocol JoinJamDisplayLogic: class {
  func displayCommons(viewModel: JoinJam.Commons.ViewModel)
  func displayDidJoin(viewModel:JoinJam.Join.ViewModel)
}

class JoinJamViewController: UIViewController, JoinJamDisplayLogic {
  var interactor: JoinJamBusinessLogic?
  var router: (NSObjectProtocol & JoinJamRoutingLogic & JoinJamDataPassing)?
  let pinTextfield = UITextField()
  let txtLabel = UILabel()
  let cancel = UIButton(type: .custom)
  let doneBuntton = UIButton( type: .system)
  var indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
  var txtfieldLeftAnchor:NSLayoutConstraint!

  // MARK: Object lifecycle
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup
  
  private func setup() {
    let viewController = self
    let interactor = JoinJamInteractor()
    let presenter = JoinJamPresenter()
    let router = JoinJamRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: View lifecycle
  
    
  override func viewDidLoad() {
    super.viewDidLoad()
 
    uiSetup()
    requestCommons()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    txtfieldLeftAnchor.constant -= 400
    UIView.animate(withDuration: 0.5) {
      self.doneBuntton.alpha = 1
      self.txtLabel.alpha = 1
      self.view.layoutIfNeeded()
    }
    
    pinTextfield.becomeFirstResponder()
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    txtLabel.alpha = 0
    doneBuntton.alpha = 0
  }
    
  func displayCommons(viewModel: JoinJam.Commons.ViewModel) {
      pinTextfield.text = viewModel.pinTxt
      doneBuntton.setTitle(viewModel.joinTxt, for: .normal)
      txtLabel.text = viewModel.labelTxt
  }
  func displayDidJoin(viewModel: JoinJam.Join.ViewModel) {
    
    print("from display did join", viewModel.didJoin)
    indicator.stopAnimating()
    indicator.removeFromSuperview()
    if viewModel.didJoin {
      router?.dismiss()
    }else {
      pinTextfield.isEnabled = true
      doneBuntton.isEnabled = true
    }
  }
  
  func requestCommons() {
    let request = JoinJam.Commons.Request()
    interactor?.commons(request: request)
  }
  func uiSetup() {
    
    view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTouch(sender:))))
  
    // commons
    pinTextfield.translatesAutoresizingMaskIntoConstraints = false
    pinTextfield.keyboardType = .numberPad
    pinTextfield.layer.cornerRadius = 4
    pinTextfield.backgroundColor = UIColor.white
    pinTextfield.textAlignment = .center
    pinTextfield.delegate = self
    cancel.translatesAutoresizingMaskIntoConstraints = false
  
    cancel.setImage(#imageLiteral(resourceName: "cancel"), for: .normal)
    cancel.addTarget(self, action: #selector(canceButtonPressed(sender:)), for: .touchUpInside)
   
    
    doneBuntton.translatesAutoresizingMaskIntoConstraints = false
    doneBuntton.backgroundColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1)
    doneBuntton.layer.cornerRadius = 22
    doneBuntton.tintColor = UIColor.white
    doneBuntton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
    txtLabel.translatesAutoresizingMaskIntoConstraints = false
    txtLabel.font = UIFont.init(name: "Avenir-Medium", size: 27)
    txtLabel.textAlignment = .center
    txtLabel.textColor = .white
    
    view.addSubview(pinTextfield)
    view.addSubview(cancel)
    view.addSubview(doneBuntton)
    view.addSubview(txtLabel)
    
    uiConstraints()
  }
  
  @objc func canceButtonPressed(sender:UIButton) {
    router?.dismiss()
  }
  
  @objc func doneButtonPressed(sender:UIButton) {
    if !pinTextfield.text!.isEmpty {
      pinTextfield.isEnabled = false
      doneBuntton.isEnabled = false
      indicator.frame = CGRect(x: view.bounds.width / 2 - 20, y: 120, width: 40, height: 40)
      view.addSubview(indicator)
      indicator.startAnimating()
      let request = JoinJam.Join.Request(pin: pinTextfield.text!)
     interactor?.join(request: request)
      
    }
    
  }
  func uiConstraints() {
    
    cancel.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
    cancel.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-20).isActive = true
    cancel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    cancel.widthAnchor.constraint(equalToConstant: 40).isActive = true
    
    txtLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    txtLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
    txtLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    
    txtfieldLeftAnchor = NSLayoutConstraint(item: pinTextfield,attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 420)
    txtfieldLeftAnchor.isActive = true
    
    pinTextfield.topAnchor.constraint(equalTo: txtLabel.bottomAnchor, constant: 40).isActive = true
    pinTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    pinTextfield.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    doneBuntton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    doneBuntton.topAnchor.constraint(equalTo: pinTextfield.bottomAnchor, constant: 20).isActive = true
    doneBuntton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    doneBuntton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    
  }
}


extension JoinJamViewController:UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    
  }
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    textField.text?.removeAll()
    return true
  }
  @objc func handleTouch(sender:UITapGestureRecognizer) {
    pinTextfield.resignFirstResponder()
  }
}
