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
    
    uiContraints()
    }
    
  
 func setupUI() {
    cancelButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.setTitleColor(UIColor.white, for: .normal)
    
 }
    
 func uiContraints() {
    // cancel button constraints
    cancelButton.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    cancelButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    cancelButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
    
    //
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
