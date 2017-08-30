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
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    submitJam()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func submitJam()
  {
    let request = StartJam.Submit.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: StartJam.Submit.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
