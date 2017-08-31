//
//  JoinJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/30/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol JoinJamDisplayLogic: class {
  func displaySomething(viewModel: JoinJam.Something.ViewModel)
}

class JoinJamViewController: UIViewController, JoinJamDisplayLogic {
  var interactor: JoinJamBusinessLogic?
  var router: (NSObjectProtocol & JoinJamRoutingLogic & JoinJamDataPassing)?
  let pinTextfiled = UITextField()
  let doneButton = UIButton(type: .system)
    
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
    doSomething()
  }
  
  // MARK: Do something
  
  func doSomething() {
    let request = JoinJam.Something.Request()
    interactor?.join(request: request)
  }

    
  func displaySomething(viewModel: JoinJam.Something.ViewModel) {
    //nameTextField.text = viewModel.name
  }
    
}
