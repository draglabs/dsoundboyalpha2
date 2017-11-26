//
//  MainViewController.swift
//  SoundBoy
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.

import UIKit

protocol MainDisplayLogic: class {
  func displayPin(viewModel:Main.Jam.ViewModel)
  func displayJamJoined(viewModel:Main.Join.ViewModel)
  func displayProgress(viewModel:Main.Progress.ViewModel)
  func displayIsJamActive(viewModel:Main.JamActive.ViewModel)
  func displayUploadCompleted(viewModel:Main.JamUpload.ViewModel)
  func diplayToReroute(viewModel: Main.Join.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic {
  var interactor: MainBusinessLogic?
  var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
 
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
 
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.didJoin(request: Main.Jam.Request())
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    activityView.prepareForEditJam = {
      self.router?.presentEditjam()
    }
    interactor?.checkForActiveJam(request: Main.Jam.Request())
  }
  
  func nav() {
    navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "files_icon"), style: .plain, target: self, action: #selector(navButtonPressed(sender:)))
    navigationItem.leftBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "settings_icon"), style: .plain, target: self, action: #selector(navButtonPressed(sender:)))
    navigationController?.navigationBar.backIndicatorImage = #imageLiteral(resourceName: "back")
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = #imageLiteral(resourceName: "back")
    self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    
  }
  
 private func setupUI() {
    nav()
    recButton.layer.cornerRadius = 73/3
    container.layer.cornerRadius = 203/2
  
    let vs = UIView()
    vs.frame = CGRect(x: 100, y: 120, width: 300, height: 300)
    pulsor.backgroundColor = UIColor.white.cgColor
     pulsor.radius = 203
    container.insertSubview(vs, belowSubview: recButton)
    vs.layer.addSublayer(pulsor)
  
    recButton.addTarget(self, action: #selector(recPressed(sender:)), for: .touchUpInside)
    new.addTarget(self, action: #selector(jamPressed(sender:)), for: .touchUpInside)
    join.addTarget(self, action: #selector(joinPressed(sender:)), for: .touchUpInside)
 
  timeCounter.counting = {[unowned self] count in
    self.time.text = count
  }
}
  
  @IBOutlet weak var bottonConstaint:NSLayoutConstraint!
  @IBOutlet weak var container:UIView!
  @IBOutlet weak var recButton:UIButton!
  @IBOutlet weak var time:UILabel!
  @IBOutlet weak var new:UIButton!
  @IBOutlet weak var join:UIButton!
  @IBOutlet weak var activityView:ActivityView!
  let timeCounter = TimeCounter(direction: .up)
  let pulsor = Pulsator()
  var isRec = false
  
  @objc func navButtonPressed(sender:UIBarButtonItem) {
    if sender == navigationItem.rightBarButtonItem {
      router?.pushFiles()
    }else {
      router?.pushSettings()
    }
  }
  
}

extension MainViewController {

  func didStart() {
    interactor?.startJam(request: Main.Jam.Request())
    recButton.setTitle("Stop", for: .normal)
    timeCounter.reset()
    timeCounter.startTimeCounter()
    pulsor.start()
    animate()
  }
  
  @objc func recPressed(sender:UIButton) {
    if !isRec {
     didStart()
      isRec = true
    }else {
      didStop()
      isRec = false
    }
  }
  
  func didStop() {
    recButton.setTitle("Rec", for: .normal)
    timeCounter.stopTimeCounter()
    pulsor.stop()
    animate()
    let endRecordingJamRequest = Main.Jam.Request()
    interactor?.endRecording(request: endRecordingJamRequest)
    activityView.message = "Hang on while we upload your recording"
  }

  @objc func jamPressed(sender:UIButton) {
      interactor?.startJam(request: Main.Jam.Request())
    }
  
  @objc func joinPressed(sender:UIButton) {
   interactor?.exitOrJoin(request: Main.Jam.Request())
  }
  
  func displayPin(viewModel:Main.Jam.ViewModel) {
    pulsor.start()
   activityView.show(title: viewModel.pin,message:"Share this pin for other to join")
   
  }

  func diplayToReroute(viewModel: Main.Join.ViewModel) {
      router?.presentJoinJam()
    
    }
  
  func displayJamJoined(viewModel: Main.Join.ViewModel) {
    pulsor.start()
    activityView.show(title:"Jam Join",message: "You have join a Jam")
  
  }
  
  func displayIsJamActive(viewModel:Main.JamActive.ViewModel){
   
  }
  
  func displayProgress(viewModel:Main.Progress.ViewModel) {
    activityView.title =  viewModel.progress
  }
  
  func displayUploadCompleted(viewModel: Main.JamUpload.ViewModel) {
    activityView.show(title: "Upload Complete", message: "Will dismiss  in 2 seconds")
    animate()
    interactor?.checkForActiveJam(request: Main.Jam.Request())
    let deadline = DispatchTime.now() + .seconds(2)
    DispatchQueue.main.asyncAfter(deadline: deadline) {
      self.animate()
      
    }
  }
  
  func animate() {
    if !activityView.isShown {
      bottonConstaint.constant -= 112
      UIView.animate(withDuration: 0.5, animations: {
        self.view.layoutIfNeeded()
      })
      activityView.isShown = true
    }else {
      bottonConstaint.constant += 112
      UIView.animate(withDuration: 0.5, animations: {
        self.view.layoutIfNeeded()
      })
      activityView.isShown = false
    }
  }
}
