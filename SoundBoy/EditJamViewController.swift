//
//  EditJamViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/31/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol EditJamDisplayLogic: class
{
  func displayCurrentJam(viewModel: EditJam.CurrentJam.ViewModel)
  func displayUpdated(viewMode:EditJam.Update.ViewModel)
}

class EditJamViewController: UIViewController, EditJamDisplayLogic
{
  var interactor: EditJamBusinessLogic?
  var router: (NSObjectProtocol & EditJamRoutingLogic & EditJamDataPassing)?

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
  
  // MARK: Routing

  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentJam()
    editJamUISetup()
  }
  
  // MARK:Properties
  
  @IBOutlet weak var  jamNameTextfield:UITextField!
  @IBOutlet weak var  locationtextfield:UITextField!
  @IBOutlet weak var  notesText:UITextField!
  @IBOutlet weak var  doneButton:UIButton!
  
  let swipeGesture = UISwipeGestureRecognizer()
  
  func currentJam() {
    let request = EditJam.CurrentJam.Request()
    interactor?.currentJam(request: request)
  }
  
  func displayCurrentJam(viewModel: EditJam.CurrentJam.ViewModel) {
    jamNameTextfield.text = viewModel.name
    locationtextfield.text = viewModel.location
    notesText.text = viewModel.notes
    
  }
  func displayUpdated(viewMode:EditJam.Update.ViewModel){
    router?.dismiss()
  }
  
  private func editJamUISetup() {
    view.backgroundColor = UIColor(displayP3Red: 33/255, green: 47/255, blue: 62/255, alpha: 1)
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
    swipeGesture.addTarget(self, action: #selector(handleSwipe(sender:)))
    swipeGesture.direction = .down
    view.addGestureRecognizer(swipeGesture)
    jamNameTextfield.placeholder = "Name of the jam"
    jamNameTextfield.clearsOnInsertion = true
    jamNameTextfield.textAlignment = .center
    jamNameTextfield.backgroundColor = UIColor.white
   
    
    jamNameTextfield.delegate = self
    locationtextfield.placeholder = "Location of the Jam"
    locationtextfield.clearsOnInsertion = true
    locationtextfield.textAlignment = .center
    locationtextfield.backgroundColor = UIColor.white
    
    
    locationtextfield.delegate = self
  
    notesText.delegate = self
    notesText.resignFirstResponder()
    doneButton.addTarget(self, action: #selector(handleDismiss(sender:)), for: .touchUpInside)

    doneButton.layer.cornerRadius = doneButton.bounds.height / 2
  }

}

extension EditJamViewController:UITextFieldDelegate,UITextViewDelegate {
  @objc func handleDismiss(sender:UIButton) {
    view.endEditing(true)
    if valid() {
      let request = EditJam.Update.Request(name: jamNameTextfield.text!, location: locationtextfield.text!
      , notes: notesText.text!)
    interactor?.update(request: request)
    }
  }
  @objc func handleTap(sender:UISwipeGestureRecognizer) {
      view.endEditing(true)
  }
  @objc func handleSwipe(sender:UISwipeGestureRecognizer) {
    router?.dismiss()
  }
 func valid() -> Bool {
  return  locationtextfield.text != nil || jamNameTextfield.text != nil || notesText.text != nil ? true : false
  }
  
  //MARK:Delegates
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    view.endEditing(true)
    return true
  }
}
