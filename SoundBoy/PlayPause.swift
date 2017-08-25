//
//  TexfieldsView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/28/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

// future protocol for play pause action
// i might not use it but is nice to have it 

protocol PlayPauseDelegates {
    func didPressedPlayButton(playPauseView:PlayPauseView, button:UIButton)
    
}


class PlayPauseView: UIView {

    let gradientBackLayer = UIView()
    let midleLayerView = UIView()
    let pausePlayButton = UIButton()
    let timeCounter = TimeCounter(direction: .up)
    let recordingTimeLabel = UILabel()
    var timeLabel = UILabel()
    var  didPressedPlayButton:((_ playPauseView:PlayPauseView, _ button:UIButton) ->())?
    let colorForOrangeBackground = UIColor(colorLiteralRed: 160/255, green: 16/255, blue: 33/255, alpha: 0.68)
    let colorForMidOrange = UIColor(colorLiteralRed: 87/255, green: 2/255, blue: 2/255, alpha: 1)
    let buttonBackgroundColor = UIColor(colorLiteralRed: 168/255, green: 36/255, blue: 36/255, alpha: 1)
    
    var delegate:PlayPauseDelegates?
    
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
        //pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        pausePlayButton.translatesAutoresizingMaskIntoConstraints = false
        pausePlayButton.backgroundColor = buttonBackgroundColor
        pausePlayButton.layer.borderWidth = 12
        pausePlayButton.layer.borderColor = UIColor(colorLiteralRed: 109/255, green: 0/255, blue: 0/255, alpha: 1).cgColor
        pausePlayButton.layer.cornerRadius = 50
        midleLayerView.addSubview(pausePlayButton)
        
        setupConstraints()
        pausePlayButton.addTarget(self, action: #selector(pausePlayButtonPressed(sender:)), for: .touchUpInside)
        
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
    
    func pausePlayButtonPressed(sender:UIButton) {
        timeCounter.counting = { count in
            self.timeLabel.text = count
        }
        timeCounter.startTimeCounter()
        delegate?.didPressedPlayButton(playPauseView: self, button: sender)
         didPressedPlayButton?(self, sender)
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
    
    func updatePlayButton(isPlaying:Bool) {
        if isPlaying {
               // pausePlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
                
            }else {
              //  pausePlayButton.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            timeCounter.stopTimeCounter()
        }
    }
    
}

extension PlayPauseView {
  
}
