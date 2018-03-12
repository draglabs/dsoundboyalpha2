//
//  ShareViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 1/6/18.
//  Copyright (c) 2018 DragLabs. All rights reserved.
//

import UIKit

protocol ShareDisplayLogic: class
{
  func displaySomething(viewModel: Share.Something.ViewModel)
}

class ShareViewController: UIViewController, ShareDisplayLogic
{
  var interactor: ShareBusinessLogic?
  var router: (NSObjectProtocol & ShareRoutingLogic & ShareDataPassing)?

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
    let interactor = ShareInteractor()
    let presenter = SharePresenter()
    let router = ShareRouter()
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
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = Share.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Share.Something.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
