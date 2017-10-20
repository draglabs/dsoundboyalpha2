//
//  TexfieldsView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/28/17.
//  Copyright © 2017 DragLabs. All rights reserved.

import UIKit

class PlayingView: UIView {
    var isPlaying = false
  
    let colorForOrangeBackground = UIColor(displayP3Red: 160/255, green: 16/255, blue: 33/255, alpha: 0.68)
    let colorForMidOrange = UIColor(displayP3Red: 87/255, green: 2/255, blue: 2/255, alpha: 1)
    let buttonBackgroundColor = UIColor(displayP3Red: 168/255, green: 36/255, blue: 36/255, alpha: 1)
  
    let gradientBackLayer = UIView()
    let midleLayerView = UIView()
    let pausePlayButton = UIButton(type: .system)
    let timeCounter = TimeCounter(direction: .up)
    let recordingTimeLabel = UILabel()
  
  
    var timeLabel = UILabel()
    var didFinishCounting:(()->())?
    var didStartCounting:(()->())?
  
    func setup() {
      
    addSubview(gradientBackLayer)
  
    gradientBackLayer.frame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width - 20, height: UIScreen.main.bounds.width - 20)
       
    gradientBackLayer.backgroundColor = colorForOrangeBackground
    gradientBackLayer.layer.cornerRadius = gradientBackLayer.bounds.height / 2
        
    midleLayerView.frame = CGRect(x: 40, y: 40, width: gradientBackLayer.bounds.width - 80, height: gradientBackLayer.bounds.width - 80)
      
    midleLayerView.backgroundColor = colorForMidOrange
    midleLayerView.layer.cornerRadius = midleLayerView.bounds.height / 2
      
    timeLabel.translatesAutoresizingMaskIntoConstraints = false
    midleLayerView.addSubview(timeLabel)
    gradientBackLayer.addSubview(midleLayerView)
      
    setupPausePlay()
    setupLabels()
      
  }

    func setupPausePlay() {
      
     pausePlayButton.tintColor = UIColor.white
     pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
     pausePlayButton.backgroundColor = buttonBackgroundColor
     pausePlayButton.layer.borderWidth = 12
     pausePlayButton.layer.borderColor = UIColor(displayP3Red: 109/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
      
     pausePlayButton.layer.cornerRadius = 50
     midleLayerView.addSubview(pausePlayButton)
     pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
      setupConstraints()
  }

    func setupLabels() {
      timeLabel.text = "00:00"
      timeLabel.font = UIFont(name: "Avenir-Light", size: 66)
      timeLabel.textAlignment = .center
      timeLabel.textColor = UIColor.white
    }
  
    func setupConstraints() {
        
     // gradientBackLayer
        pausePlayButton.centerXAnchor.constraint(equalTo: midleLayerView.centerXAnchor).isActive = true
        pausePlayButton.topAnchor.constraint(equalTo: midleLayerView.topAnchor, constant:20).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        timeLabel.topAnchor.constraint(equalTo: pausePlayButton.bottomAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: midleLayerView.leadingAnchor).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: midleLayerView.trailingAnchor).isActive = true
  }
    
    @objc func pausePlayButtonPressed(sender:UIButton) {
      if isPlaying {
        isPlaying = false
        didFinishCounting?()
        timeCounter.stopTimeCounter()
        updatePlayButton()
      }
  }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
  }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePlayButton() {
        if isPlaying {
          pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }else {
          pausePlayButton.setImage(UIImage(), for: .normal)
          timeCounter.stopTimeCounter()
        }
  }
  
  func start() {
    isPlaying = true
    updatePlayButton()
    timeCounter.counting = {[unowned self] count in
      self.timeLabel.text = count
    }
    timeCounter.startTimeCounter()
    
  }
  
  func stop() {
    isPlaying = false
    updatePlayButton()
    timeCounter.stopTimeCounter()
    didFinishCounting?()
  }
  
}


