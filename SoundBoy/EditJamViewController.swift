//
//  EditJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol EditJamDisplayLogic: class {
  func displayCurrentJam(viewModel: EditJam.CurrentJam.ViewModel)
  func displayUpdated(viewMode:EditJam.Update.ViewModel)
}

class EditJamViewController: UIViewController, EditJamDisplayLogic {
  var interactor: EditJamBusinessLogic?
  var router: (NSObjectProtocol & EditJamRoutingLogic & EditJamDataPassing)?

  // MARK: Object lifecycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  private func setup() {
    let viewController = self
    let interactor = EditJamInteractor()
    let presenter = EditJamPresenter()
    let router = EditJamRouter()
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
    currentJam()
    editJamUISetup()
  }
  // MARK:Properties
  let swipeGesture = UISwipeGestureRecognizer()
  @IBOutlet weak var ediTableView:EditTableView!
  @IBOutlet weak var doneButton:UIButton!
  func currentJam() {
    let request = EditJam.CurrentJam.Request()
    interactor?.currentJam(request: request)
  }
  
  func displayCurrentJam(viewModel: EditJam.CurrentJam.ViewModel) {
    ediTableView.display(name: viewModel.name, location: viewModel.location, notes: viewModel.notes)
  }
  func displayUpdated(viewMode:EditJam.Update.ViewModel){
    router?.dismiss()
  }
  
  private func editJamUISetup() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    doneButton.addTarget(self, action: #selector(doneButtonPressed(sender:)), for: .touchUpInside)
    swipeGesture.addTarget(self, action: #selector(handleSwipe(sender:)))
    swipeGesture.direction = .down
    view.addGestureRecognizer(swipeGesture)
   }
  
  @objc func doneButtonPressed(sender:UIButton) {
    router?.dismiss()
    if valid() {
      print("should update")
            let request = EditJam.Update.Request(name:ediTableView.updates.name, location:ediTableView.updates.location
            , notes: ediTableView.updates.notes)
          interactor?.update(request: request)
    }else {
      print("no update")
    }
  }
}

extension EditJamViewController:UITextFieldDelegate,UITextViewDelegate {
  @objc func handleDismiss(sender:UIButton) {
    view.endEditing(true)
    if valid() {
      print("should update")
      let request = EditJam.Update.Request(name:ediTableView.updates.name, location:ediTableView.updates.location
      , notes: ediTableView.updates.notes)
    interactor?.update(request: request)
    }else {
      print("no update")
    }
  }
  
  @objc func handleTap(sender:UISwipeGestureRecognizer) {
      view.endEditing(true)
  }
  @objc func handleSwipe(sender:UISwipeGestureRecognizer) {
    router?.dismiss()
  }

 func valid() -> Bool {
  if ediTableView.updates.name != "" && ediTableView.updates.location != ""
    && ediTableView.updates.notes != "" {
    return true
  }
  return false
  }
  
  //MARK:Delegates
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}
