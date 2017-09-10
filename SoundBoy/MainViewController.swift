//
//  MainViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.

import UIKit

protocol MainDisplayLogic: class {
  func displayPin(viewModel:Main.Jam.ViewModel)
  func displayProgress(progress:Float)
}

class MainViewController: UIViewController, MainDisplayLogic {
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
  var isPlaying = false
    
  let playPauseView = PlayPauseView()
  let startJoinJamView = JoinStartJamView()
  let pulsor = Pulsator()
  let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
  let backLayer = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
  let pinView = PinView()
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder){
    super.init(coder: aDecoder)
    setup()
  }
  

  private func setup() {
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  func nav() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "files_icon"), style: .plain, target: self, action: #selector(navButtonPressed(sender:)))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "settings_icon"), style: .plain, target: self, action: #selector(navButtonPressed(sender:)))
    navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
  }
  
  func setupUI() {
    view.backgroundColor = UIColor.white
    nav()
     playPauseView.translatesAutoresizingMaskIntoConstraints = false
     startJoinJamView.translatesAutoresizingMaskIntoConstraints = false
     backLayer.frame = view.frame
     view.addSubview(backLayer)
     backgroundView.frame = view.frame
     view.addSubview(backgroundView)
     view.addSubview(playPauseView)
     view.addSubview(startJoinJamView)
     playPauseView.didPressedPlayButton = didPressedPlayButton
     startJoinJamView.didPressedJam = jamPressed
    startJoinJamView.didPressedJoin = didPreseJoin
     uiContraints()
    
    let vs = UIView()
    vs.frame = CGRect(x: view.bounds.width / 2, y: 120, width: 300, height: 300)
    pulsor.backgroundColor = UIColor.white.cgColor
    playPauseView.insertSubview(vs, belowSubview: playPauseView.pausePlayButton)
    vs.layer.addSublayer(pulsor)
    
    }
  
    
  func uiContraints() {
     // play pause view  constraints
     playPauseView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
     playPauseView.topAnchor.constraint(equalTo: view.topAnchor,constant:64).isActive = true
     playPauseView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
     NSLayoutConstraint.init(item: playPauseView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/1.7, constant: 0).isActive = true
    
    //Start Join Jam view constraints
    startJoinJamView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    startJoinJamView.topAnchor.constraint(equalTo: playPauseView.bottomAnchor).isActive = true
    startJoinJamView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    startJoinJamView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    
    }
  

  func displayPin(viewModel:Main.Jam.ViewModel) {
    pinView.parentView = view
    pinView.animateShow()
  }
  
  
  func displayProgress(progress: Float) {
    
  }
  
  func navButtonPressed(sender:UIBarButtonItem) {
    if sender == navigationItem.rightBarButtonItem {
      router?.pushFiles()
    }else {
      router?.pushSettings()
    }
  }
}
extension MainViewController {
    
    // callbacks from views
    
    func  didPressedPlayButton(playPauseView:PlayPauseView, button:UIButton) {
        
        if !isPlaying {
            pulsor.start()
            Recorder.shared.startRecording()
            isPlaying = true
            playPauseView.updatePlayButton(isPlaying: isPlaying)
            
        }else {
            pulsor.stop()
          Recorder.shared.didFinishRecording = { url in
            let uploadRequest = Main.JamUpload.Request(fileURL: url)
            self.interactor?.uploadJam(request: uploadRequest)
          }
            Recorder.shared.stopRecording()
            isPlaying = false
            playPauseView.updatePlayButton(isPlaying: isPlaying)
        }
        
    }
    
    func jamPressed(view:JoinStartJamView, button:UIButton) {
        
        playPauseView.start()
      let request = Main.Jam.Request()
      interactor?.startJam(request: request)
    }
  
  func didPreseJoin(bottomView:JoinStartJamView,sender:UIButton) {
      router?.presentJoinJam()
  }
}
