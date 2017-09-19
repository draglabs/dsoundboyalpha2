//
//  LoginViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 8/29/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.
//


import UIKit

protocol LoginDisplayLogic: class
{
  func displaySomething(viewModel: Login.WelcomeText.ViewModel)
  func displayMainScreen(viewModel:Login.Register.ViewModel)
}

class LoginViewController: UIViewController, LoginDisplayLogic {
  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?
  let backgrundImageView = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
  let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
  let loginButton = UIButton(type: UIButtonType.system)
  let slogan = UILabel()
    
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
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
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
    requestWelcomeText()
    
  }
  
  func requestWelcomeText() {
    let request = Login.WelcomeText.Request()
    interactor?.welcomeText(request: request)
    
  }
    
  func displaySomething(viewModel: Login.WelcomeText.ViewModel)
  {
    slogan.text = viewModel.welcomeText
  }
    
  func displayMainScreen(viewModel: Login.Register.ViewModel) {
    if viewModel.registered {
        router?.routeToMainController(source: self)
        }
    
    }
    
  @objc func loginButtonPressed(sender:UIButton) {
        
    let request = Login.Register.Request()
    interactor?.RegisterUser(request: request)
        
 }
    
    func setupUI() {
        
        backgrundImageView.frame = view.bounds
        view.addSubview(backgrundImageView)
        
        backgroundView.frame = view.bounds
        
        view.addSubview(backgroundView)
        
        slogan.numberOfLines = 0
        slogan.textAlignment = .center
        slogan.font = UIFont(name: "Avenir-Book", size: 30)
        slogan.textColor = UIColor.white
        view.addSubview(slogan)
        loginSetup()
    }
    

    func loginSetup() {
        loginButton.setTitle("Facebook", for: .normal)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.tintColor = UIColor.white
        loginButton.backgroundColor = UIColor(displayP3Red: 59/255, green: 89/255, blue: 152/255, alpha: 1)
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginButtonPressed(sender:)), for: .touchUpInside)
        loginButtonConstraints()
        
        loginButton.layer.cornerRadius = 5
        sloganConstraints()
    }
    
    
    func loginButtonConstraints() {
        
        loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:10).isActive = true
        loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-10).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func sloganConstraints() {
        slogan.translatesAutoresizingMaskIntoConstraints = false
        slogan.bottomAnchor.constraint(equalTo: loginButton.topAnchor,constant:-20).isActive = true
        slogan.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        slogan.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
    }
    
}
