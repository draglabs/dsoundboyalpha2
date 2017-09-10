//
//  SettingsViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol SettingsDisplayLogic: class {
  func displaySomething(viewModel: Settings.Something.ViewModel)
}

class SettingsViewController: UIViewController, SettingsDisplayLogic {
  var interactor: SettingsBusinessLogic?
  var router: (NSObjectProtocol & SettingsRoutingLogic & SettingsDataPassing)?

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
    let interactor = SettingsInteractor()
    let presenter = SettingsPresenter()
    let router = SettingsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    doSomething()
    uiSetup()
  }
  func uiSetup() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "forward"), style: .plain, target: self, action: #selector(navbarNuttonPressed(sender:)))
      view.backgroundColor = UIColor.white
  }
  func navbarNuttonPressed(sender:UIBarButtonItem) {
    router?.popBack()
  }
  //@IBOutlet weak var nameTextField: UITextField!
  func doSomething() {
    
    let request = Settings.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: Settings.Something.ViewModel) {
    //nameTextField.text = viewModel.name
  }
}
