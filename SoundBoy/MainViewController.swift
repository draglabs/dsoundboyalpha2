//
//  ViewController.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/26/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit


protocol MainControllerDelegate {
    
}


class MainViewController: UIViewController {
    let playPauseView = PlayPauseView()
    let bottomView = BottomView()
    let activityView = Activity()
    
    let backgroundView = UIImageView(image: #imageLiteral(resourceName: "background"))
    let backLayer = UIImageView(image: #imageLiteral(resourceName: "backLayer"))
    
    let settingButton = UIButton(type: UIButtonType.system)
    let filesButton = UIButton(type: UIButtonType.system)
    var isPlaying = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}

extension MainViewController {
    
    func setupUI() {
        backLayer.frame = view.frame
        view.addSubview(backLayer)
        backgroundView.frame = view.frame
        view.addSubview(backgroundView)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        playPauseView.translatesAutoresizingMaskIntoConstraints = false
        settingButton.translatesAutoresizingMaskIntoConstraints = false
        filesButton.translatesAutoresizingMaskIntoConstraints = false
        activityView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playPauseView)
        view.addSubview(filesButton)
        view.addSubview(settingButton)
        view.addSubview(activityView)
        
        childViews()
        setupConstraints()
        view.layoutIfNeeded()
        
    }
    
    func childViews() {
        let titleText = UILabel()
        titleText.text = "dSoundBoy"
        titleText.textColor  = UIColor.white
        titleText.font = UIFont(name: "Avenir-Heavy", size: 27)
        titleText.textAlignment = .center
        titleText.frame  = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 64)
        view.addSubview(titleText)
        
        settingButton.setImage(#imageLiteral(resourceName: "settings_icon"), for: .normal)
        settingButton.tintColor = UIColor.white
        
        filesButton.setImage(#imageLiteral(resourceName: "files_icon"), for: .normal)
        filesButton.tintColor = UIColor.white
       
        view.addSubview(bottomView)
        playPauseView.didPressedPlayButton = didPressedPlayButton
        
    }
    
    func setupConstraints() {
        
        // setting button constraints
        settingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant:20).isActive = true
        settingButton.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
        settingButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        settingButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        // files button constraints
        filesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant:-20).isActive = true
        filesButton.topAnchor.constraint(equalTo: view.topAnchor, constant:20).isActive = true
        filesButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        filesButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        
        // play pause view  constraints
        playPauseView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playPauseView.topAnchor.constraint(equalTo: view.topAnchor,constant:64).isActive = true
        playPauseView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        NSLayoutConstraint.init(item: playPauseView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1/1.7, constant: 0).isActive = true
        
        
        // bottomView Constraints
        bottomView.topAnchor.constraint(equalTo: playPauseView.bottomAnchor).isActive = true
        bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        // activityview constraints 
        activityView.topAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
        activityView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        activityView.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        activityView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension MainViewController {
    
    // callbacks from playpause view
    // delegate if you will
    
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




