//
//  Wave.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 6/29/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class Activity: UIView {
   
    private let titleLabel   = UILabel()
    private let messageLabel = UILabel()
    
    var message = String() {
        didSet {
            messageLabel.text = message
        }
    }
    var title = String() {
        didSet {
            titleLabel.text = title
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init() {
        self.init(frame: .zero)
        setup()
    }
    func setup() {
        self.backgroundColor = UIColor(colorLiteralRed: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        setupViews()
    }
    
    private func  setupViews() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(titleLabel)
        addSubview(messageLabel)
        constrains()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func displayJamStart() {
        
    }
    
    func constrains() {
       titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
       titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
       messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
       messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
       messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
    
}
