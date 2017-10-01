//
//  FilesCell.swift
//  dSoundBoy
//
//  Created by Craig on 10/1/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import UIKit

class FilesCell: UITableViewCell {
    
    var startTime = UILabel();
    var endTime = UILabel();
    var jamName = UILabel();
    var collaborators = UILabel();
    var exportButton = UIButton();
    
 override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Do your cell set up

    exportButton = UIButton(type: .infoDark)
    //make this a custom button image
    
    startTime = UILabel(frame: contentView.bounds)
    startTime.font = UIFont(name:"Avenir-Book", size:16)
 
    endTime = UILabel(frame: contentView.bounds)
    endTime.font = UIFont(name:"Avenir-Book", size:16)
    
    jamName = UILabel(frame: contentView.bounds)
    jamName.font = UIFont(name:"Avenir-Book", size:16)
    
    collaborators = UILabel(frame: contentView.bounds)
    collaborators.font = UIFont(name:"Avenir-Book", size:16)
   
    contentView.addSubview(exportButton)
    contentView.addSubview(startTime)
    contentView.addSubview(endTime)
    contentView.addSubview(jamName)
    contentView.addSubview(collaborators)
    
    
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
}
