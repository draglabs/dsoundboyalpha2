//
//  SettingsViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.


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
    uiSetup()
  }
  func uiSetup() {
    title = "INSTRUCTIONS"
    navigationItem.rightBarButtonItem = UIBarButtonItem(image:#imageLiteral(resourceName: "forward"), style: .plain, target: self, action: #selector(navbarNuttonPressed(sender:)))
    let titleDict: [NSAttributedStringKey : Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue):UIFont(name:"Avenir-Book", size:14)!,NSAttributedStringKey(rawValue: NSAttributedStringKey.foregroundColor.rawValue): UIColor.white]
    navigationController?.navigationBar.titleTextAttributes = titleDict
  
    
    view.backgroundColor = UIColor(displayP3Red: 33, green: 66, blue: 99, alpha: 0.5)
    let imageView = UIImageView(image: #imageLiteral(resourceName: "Instructions"))
    imageView.frame = view.frame
    view.addSubview(imageView)
    
    feedBack()
   // logOutUI()
    }
    
    func feedBack() {
      //  let url = NSURL(string: "http://www.google.com") as! URL
        let button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: view.bounds.height - 120, width: view.bounds.width, height: 54)
        button.backgroundColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1)
        button.setTitle("FEEDBACK", for: .normal)
        button.tintColor = UIColor.white
        view.addSubview(button)
        button.addTarget(self, action:#selector(goToFeedback(sender:)), for: .allEvents)
    print(view.bounds.height)
        //  logOut()
        

            
        }
    
        @objc func goToFeedback(sender:UIButton){
            let url = NSURL(string: "http://goo.gl/PjRQRg")! as URL
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    func logOutUI() {
//        let button = UIButton(type: .system)
//        button.frame = CGRect(x: 0, y: view.bounds.height / 2 + 150, width: view.bounds.width, height: 44)
//        button.backgroundColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1)
//        button.setTitle("LOGOUT", for: .normal)
//        button.tintColor = UIColor.white
//        view.addSubview(button)
      //  logOut()
        

        
    }


  @objc func navbarNuttonPressed(sender:UIBarButtonItem) {
    router?.popBack()
  }
  func displaySomething(viewModel: Settings.Something.ViewModel) {
    //nameTextField.text = viewModel.name
  }
}
