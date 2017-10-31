//
//  ExportJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/26/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol ExportJamDisplayLogic: class
{
  func displayExporting(viewModel: ExportJam.Export.ViewModel)
}

class ExportJamViewController: UIViewController, ExportJamDisplayLogic
{
  var interactor: ExportJamBusinessLogic?
  var router: (NSObjectProtocol & ExportJamRoutingLogic & ExportJamDataPassing)?

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
    let interactor = ExportJamInteractor()
    let presenter = ExportJamPresenter()
    let router = ExportJamRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.export(request: ExportJam.Export.Request())
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
   view.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.9)
    activity.frame = CGRect(x: view.bounds.width/2 - 20, y: view.bounds.height/2 - 20, width: 40, height: 40)
    activity.color = UIColor.white
    message.text = "Exporting.."
    message.textAlignment = .center
    message.font = UIFont(name: "Avenir-Medium", size: 25)
    message.textColor = UIColor.white
    message.frame = CGRect(x: view.bounds.width/2 - 100, y: view.bounds.height/2 - 50, width: 200, height: 50)
    view.addSubview(activity)
    view.addSubview(message)
    activity.startAnimating()
  }
  
  // MARK:Vars
  let activity = UIActivityIndicatorView()
  let message = UILabel()
  
  func displayExporting(viewModel: ExportJam.Export.ViewModel) {
    
    message.text = viewModel.message
    activity.stopAnimating()
    let deadline = DispatchTime.now() + .seconds(1)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      self.router?.dismiss()
    }
  }
}
