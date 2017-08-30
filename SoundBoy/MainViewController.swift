//
//  MainViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol MainDisplayLogic: class
{
  func displaySomething(viewModel: Main.Jam.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic
{
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
  var isPlaying = false
    
  let playPauseView = PlayPauseView()
  let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
  let backLayer = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
    
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
    let interactor = MainInteractor()
    let presenter = MainPresenter()
    let router = MainRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
  
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    setupUI()
  }
  
  // MARK: Do something
  
  func setupUI() {
     playPauseView.translatesAutoresizingMaskIntoConstraints = false
     backLayer.frame = view.frame
     view.addSubview(backLayer)
     backgroundView.frame = view.frame
     view.addSubview(backgroundView)
     view.addSubview(playPauseView)
     playPauseView.didPressedPlayButton = didPressedPlayButton
     uiContraints()
    }
  
    
  func uiContraints() {
     // play pause view  constraints
     playPauseView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
     playPauseView.topAnchor.constraint(equalTo: view.topAnchor,constant:64).isActive = true
     playPauseView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
     NSLayoutConstraint.init(item: playPauseView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/1.7, constant: 0).isActive = true
    }
    
  func doSomething() {
    let request = Main.Jam.Request()
    interactor?.startJam(request: request)
  }
  
  func displaySomething(viewModel: Main.Jam.ViewModel)
  {
    //nameTextField.text = viewModel.name
  }
    
  
}


extension MainViewController {
    
    // callbacks from playpause view
  
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    func  didPressedPlayButton(playPauseView:PlayPauseView, button:UIButton) {
        
        if !isPlaying {
            Recorder.shared.startRecording()
            isPlaying = true
            playPauseView.updatePlayButton(isPlaying: isPlaying)
            
        }else {
            
            Recorder.shared.stopRecording()
            isPlaying = false
            playPauseView.updatePlayButton(isPlaying: isPlaying)
            
        }
        
    }
    
}
