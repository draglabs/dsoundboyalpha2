//
//  FilesDetailViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/20/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol FilesDetailDisplayLogic: class
{
  func displaydetail(viewModel: FilesDetail.Detail.ViewModel)
}

class FilesDetailViewController: UIViewController, FilesDetailDisplayLogic {
  var interactor: FilesDetailBusinessLogic?
  var router: (NSObjectProtocol & FilesDetailRoutingLogic & FilesDetailDataPassing)?

  // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    //setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = FilesDetailInteractor()
    let presenter = FilesDetailPresenter()
    let router = FilesDetailRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
    view.backgroundColor = UIColor.white
  }
  
  // MARK: Routing
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
   
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
     requestDetails()
  }
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func requestDetails() {
    let request = FilesDetail.Detail.Request()
    interactor?.detail(request: request)
  }
  
  func displaydetail(viewModel: FilesDetail.Detail.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
}
