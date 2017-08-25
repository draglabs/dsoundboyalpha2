//
//  BottomView.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/30/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

protocol BottomViewDelegate {
    func didPressedJoin(bottomView:BottomView,join:UIButton)
    func didPressedJam(bottomView:BottomView,jam:UIButton)
}

class BottomView: UIView {
    var delegate:BottomViewDelegate?
    let joinButton = UIButton()
    let jamButton = UIButton()
    let pinSliderView = PinGenViewSliderView()
    let location = LocationMgr()
    let colorForMidOrange = UIColor(colorLiteralRed: 242/255, green: 241/255, blue: 241/255, alpha: 1)
    fileprivate let borderColor = UIColor(colorLiteralRed: 193/255, green: 18/255, blue: 37/255, alpha: 1).cgColor
    fileprivate let buttonColor = UIColor(colorLiteralRed: 160/255, green: 16/255, blue: 33/255, alpha: 1)
    
    func setup() {
        setupButtons()
    }
    
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func setupButtons() {
        jamButton.translatesAutoresizingMaskIntoConstraints = false
        joinButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(jamButton)
        addSubview(joinButton)
        setupConstraints()
    
    
        // style of buttons
        jamButton.layer.borderColor  = UIColor.white.cgColor
        jamButton.layer.borderWidth = 1
        jamButton.backgroundColor = buttonColor
    
        joinButton.layer.borderColor = UIColor.white.cgColor
        joinButton.layer.borderWidth = 1
        joinButton.backgroundColor = buttonColor
    
    
        // radius on buttons 
        layoutIfNeeded()
        jamButton.layer.cornerRadius = jamButton.bounds.height / 2
        joinButton.layer.cornerRadius = joinButton.bounds.height / 2
    
        // titles and font for buttons 
        jamButton.setTitle("Jam", for: .normal)
        joinButton.setTitle("Join", for: .normal)
        setupConstraints()
        addButtonActions()
    
    }
    
    func setupConstraints() {
        jamButton.leadingAnchor.constraint(equalTo: leadingAnchor,constant:-20).isActive = true
        jamButton.topAnchor.constraint(equalTo: topAnchor, constant:20).isActive = true
        jamButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        jamButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
        joinButton.trailingAnchor.constraint(equalTo: trailingAnchor,constant:20).isActive = true
        joinButton.topAnchor.constraint(equalTo: topAnchor, constant:20).isActive = true
        joinButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        joinButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
    }
    
    // button actions
    func addButtonActions() {
        joinButton.addTarget(self, action: #selector(joinButtonPressed(sender:)), for: .touchUpInside)
        jamButton.addTarget(self, action: #selector(jamButtonPressed(sender:)), for: .touchUpInside)
    }
    
    
}


//MARK:button actions
extension BottomView {
    func joinButtonPressed(sender:UIButton) {
        
    }
    
    func jamButtonPressed(sender:UIButton) {
        // animate and present view
        // sliderView viewModel should generate pin
        location.requestLocation()
        
    }
}
