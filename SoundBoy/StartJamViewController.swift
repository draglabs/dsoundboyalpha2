//
//  StartJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol StartJamDisplayLogic: class
{
  func displaySomething(viewModel: StartJam.Submit.ViewModel)
}

class StartJamViewController: UIViewController, StartJamDisplayLogic
{
  var interactor: StartJamBusinessLogic?
  var router: (NSObjectProtocol & StartJamRoutingLogic & StartJamDataPassing)?
    
  let cancelButton = UIButton(type: .system)
  let doneButton = UIButton(type: .system)
  let locationNameTextfield = UITextField()
  let jamNameTextfield = UITextField()
   
    override var prefersStatusBarHidden: Bool {
        return true
    }
  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = StartJamInteractor()
    let presenter = StartJamPresenter()
    let router = StartJamRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing

  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupCommonsUI()
    submitJam()
  }
  
 override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    }
    
 func setupCommonsUI() {
    view.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.7)
    cancelButton.translatesAutoresizingMaskIntoConstraints = false
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    locationNameTextfield.translatesAutoresizingMaskIntoConstraints = false
    jamNameTextfield.translatesAutoresizingMaskIntoConstraints = false
    cancelButton.addTarget(self, action: #selector(cancelButtonPressed(sender:)), for: .touchUpInside)
    doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
    
    view.addSubview(cancelButton)
    view.addSubview(doneButton)
    view.addSubview(locationNameTextfield)
    view.addSubview(jamNameTextfield)
    setupUI()
    uiContraints()
    
    }
    
  
 func setupUI() {
    cancelButton.setTitleColor(UIColor.white, for: .normal)
    cancelButton.titleLabel!.font = UIFont(name: "Avenir-Book", size: 17)
    
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.titleLabel!.font = UIFont(name: "Avenir-Book", size: 17)
    doneButton.layer.cornerRadius = 22
    doneButton.backgroundColor = UIColor(colorLiteralRed: 168/255, green: 36/255, blue: 36/266, alpha: 1.0)
    jamNameTextfield.backgroundColor = UIColor.white
    jamNameTextfield.layer.cornerRadius = 4
    
    locationNameTextfield.backgroundColor = UIColor.white
    locationNameTextfield.layer.cornerRadius = 4
 }
    
 func uiContraints() {
    // cancel button constraints
    cancelButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    //jam name constraints 
    jamNameTextfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 115).isActive = true
    jamNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:12).isActive = true
    jamNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-12).isActive = true
    jamNameTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    // jam location constraints 
    locationNameTextfield.topAnchor.constraint(equalTo: jamNameTextfield.bottomAnchor,constant:15).isActive = true
    locationNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12).isActive = true
    locationNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12).isActive = true
    locationNameTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
    //done button contraints 
    doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    doneButton.topAnchor.constraint(equalTo: locationNameTextfield.bottomAnchor, constant: 25).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    doneButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
  }
    
  func submitJam() {
    let request = StartJam.Submit.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: StartJam.Submit.ViewModel) {
   locationNameTextfield.text = viewModel.locationName
   jamNameTextfield.text = viewModel.jamName
   cancelButton.setTitle(viewModel.close, for: .normal)
   doneButton.setTitle(viewModel.done, for: .normal)
  }
    
    func cancelButtonPressed(sender:UIButton) {
        self.router?.dismiss()
    }
    func doneButtonPressed(sender:UIButton) {
        router?.dismiss()
    }
}
