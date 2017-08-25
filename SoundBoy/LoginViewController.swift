//
//  OnboardingViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/11/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit


protocol OnboardingVCDelegate {
    func didLogin()
}

class LoginViewController: UIViewController {
    
    var delegate:OnboardingVCDelegate?
    let backgrundImageView = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
    let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
    let loginButton = UIButton(type: UIButtonType.system)
    let slogan = UILabel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }

    
    func loginButtonPressed(sender:UIButton) {
        Fetcher().facebookApi { (done) in
            if done {
                self.delegate?.didLogin()
            }
        }
    }
    
    
   func setup() {
    
        backgrundImageView.frame = view.bounds
        view.addSubview(backgrundImageView)
    
        backgroundView.frame = view.bounds

        view.addSubview(backgroundView)
    
        slogan.text = "Thank you for using dSoundBoy \n please sign up using"
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
        loginButton.backgroundColor = UIColor(colorLiteralRed: 59/255, green: 89/255, blue: 152/255, alpha: 1)
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
