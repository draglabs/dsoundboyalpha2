//
//  PinGeneratedView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 7/2/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit


protocol PinGeneratorViewDelegate {
    func didPressedDoneButton(settingOverLay:SettingOverLay, button:UIButton)
}

class SettingOverLay: UIView {
    var delegate:PinGeneratorViewDelegate?
    let pinLabel = UILabel()
    let pinInstructions = UILabel()
    let doneButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
  func  doneButtonPressed(sender:UIButton) {
        delegate?.didPressedDoneButton(settingOverLay: self, button: sender)
    }
    
    func setup() {
        backgroundColor = UIColor.redOrange
        
      addChilds()
        
        // common setup 
        doneButton.setTitle("DONE", for: .normal)
        doneButton.backgroundColor = UIColor(colorLiteralRed: 242/255, green: 241/255, blue: 241/255, alpha: 1)
        doneButton.titleLabel!.font = UIFont(name: "Avenir-Light", size: 20)
        pinLabel.font = UIFont(name: "Avenir-Light", size: 64)
        pinLabel.textAlignment = .center
        pinInstructions.textAlignment = .center
        pinInstructions.font = UIFont(name: "Avenir-Light", size: 12)
        pinInstructions.textColor = UIColor.white
        
    }
    
    func addChilds() {
        pinLabel.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        pinInstructions.translatesAutoresizingMaskIntoConstraints = false
        addSubview(pinLabel)
        addSubview(doneButton)
        addSubview(pinInstructions)
        setupConstraints()
    }
    
    func setupConstraints() {
        // done button constraints
        doneButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        // pin label constraints 
        pinLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pinLabel.topAnchor.constraint(equalTo: doneButton.bottomAnchor).isActive = true
        pinLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        
        // pin instructions constraints
        pinInstructions.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        pinInstructions.topAnchor.constraint(equalTo: pinLabel.bottomAnchor).isActive = true
        pinInstructions.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        pinInstructions.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
    }
}
