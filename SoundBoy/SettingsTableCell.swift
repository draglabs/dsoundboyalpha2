//
//  SettingsTableViewCell.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/9/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

  override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

  func setup() {
    backgroundColor = UIColor(displayP3Red: 67/355, green: 36/255, blue: 36/255, alpha: 1)
  }
}
