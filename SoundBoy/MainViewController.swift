//
//  MainViewController.swift
//  SoundBoy
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.

import UIKit

protocol MainDisplayLogic: class {
  func displayJam(viewModel:Main.Jam.ViewModel)
  func displayJamJoined(viewModel:Main.Join.ViewModel)
  func displayProgress(viewModel:Main.Progress.ViewModel)
  func displayUploadCompleted(viewModel:Main.JamUpload.ViewModel)
 
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

  func didStartRec() {
    recButton.setTitle("Stop", for: .normal)
    timeCounter.reset()
    timeCounter.startTimeCounter()
    pulsor.start()
    animate()
    isRec = true
  }
  
  func didStopRec() {
    recButton.setTitle("Rec", for: .normal)
    timeCounter.stopTimeCounter()
    pulsor.stop()
    animate()
    let endRecordingJamRequest = Main.Jam.Request()
    interactor?.endRecording(request: endRecordingJamRequest)
    activityView.message = "Hang on while we upload your recording"
     isRec = false
  }
  
  @objc func recPressed(sender:UIButton) {
    if !isRec {
      interactor?.rec(request: Main.Jam.Request())
    }else {
      didStopRec()
    }
  }
  @objc func jamPressed(sender:UIButton) {
      interactor?.new(request: Main.Jam.Request())
    }
  
  @objc func joinPressed(sender:UIButton) {
   router?.presentJoinJam()
  }
  
  func displayJam(viewModel: Main.Jam.ViewModel){
    if viewModel.pin == "" {
      activityView.show(title: viewModel.pin,message:"you have join a jam")
      didStartRec()
      return
    }
    activityView.show(title: viewModel.pin,message:"Share this pin for other to join")
    didStartRec()
  }
  func displayJamJoined(viewModel: Main.Join.ViewModel) {
    activityView.show(title:"Jam Join",message: "You have join a Jam")
  }
  
  func displayProgress(viewModel:Main.Progress.ViewModel) {
    activityView.title =  viewModel.progress
  }
  
  func displayUploadCompleted(viewModel: Main.JamUpload.ViewModel) {
    activityView.show(title: "Upload Complete", message: "Will dismiss  in 2 seconds")
    animate()
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
