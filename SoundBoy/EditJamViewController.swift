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
  }
  
  // MARK:Properties
  
  let jamNameTextfield = UITextField()
  let locationtextfield = UITextField()
  let notesTextView = UITextView()
  let doneButton = UIButton(type:.system)
  
  
  func currentJam() {
    let request = EditJam.CurrentJam.Request()
    interactor?.currentJam(request: request)
  }
  
  func displayCurrentJam(viewModel: EditJam.CurrentJam.ViewModel) {
    jamNameTextfield.text = viewModel.name
    locationtextfield.text = viewModel.location
    notesTextView.text = viewModel.notes
    
    // NotificationCenter.default.addObserver(self, selector: #selector(handleWillShow(notification:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
  }
  
  
  private func editJamUISetup() {
    jamNameTextfield.placeholder = "Name of the jam"
    jamNameTextfield.clearsOnInsertion = true
    jamNameTextfield.textAlignment = .center
    jamNameTextfield.backgroundColor = UIColor.white
    jamNameTextfield.translatesAutoresizingMaskIntoConstraints = false
    
    jamNameTextfield.delegate = self
    locationtextfield.placeholder = "Location of the Jam"
    locationtextfield.clearsOnInsertion = true
    locationtextfield.textAlignment = .center
    locationtextfield.backgroundColor = UIColor.white
    locationtextfield.translatesAutoresizingMaskIntoConstraints = false
    
    locationtextfield.delegate = self
    notesTextView.clearsOnInsertion = true
    notesTextView.text = "Notes"
    notesTextView.textAlignment = .center
    notesTextView.backgroundColor = UIColor.white
    notesTextView.translatesAutoresizingMaskIntoConstraints = false
    notesTextView.delegate = self
    notesTextView.resignFirstResponder()
    doneButton.addTarget(self, action: #selector(handleDismiss(sender:)), for: .touchUpInside)
    doneButton.setTitle("DONE", for: .normal)
    doneButton.layer.borderWidth = 2
    doneButton.layer.borderColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1).cgColor
    doneButton.setTitleColor(UIColor.white, for: .normal)
    doneButton.translatesAutoresizingMaskIntoConstraints = false
    
    view.addSubview(jamNameTextfield)
    view.addSubview(locationtextfield)
    view.addSubview(notesTextView)
    view.addSubview(doneButton)
    editJamConstraints()
    view.layoutIfNeeded()
    doneButton.layer.cornerRadius = doneButton.bounds.height / 2
  }
  
  private func editJamConstraints() {
    jamNameTextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:50).isActive = true
    jamNameTextfield.topAnchor.constraint(equalTo: view.topAnchor,constant:28).isActive = true
    jamNameTextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-50).isActive = true
    jamNameTextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    locationtextfield.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    locationtextfield.topAnchor.constraint(equalTo: jamNameTextfield.bottomAnchor, constant: 18).isActive = true
    locationtextfield.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    locationtextfield.heightAnchor.constraint(equalToConstant: 35).isActive = true
    
    notesTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
    notesTextView.topAnchor.constraint(equalTo: locationtextfield.bottomAnchor, constant: 18).isActive = true
    notesTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
    notesTextView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    
    doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
    doneButton.topAnchor.constraint(equalTo: notesTextView.bottomAnchor, constant: 8).isActive = true
    doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
    doneButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
  }
  
}

extension EditJamViewController:UITextFieldDelegate,UITextViewDelegate {
  @objc func handleDismiss(sender:UIButton) {
    
  }
}
