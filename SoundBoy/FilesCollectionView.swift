//
//  FilesCell.swift
//  dSoundBoy
//
//  Created by Craig on 10/1/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import UIKit

class FilesCell: UICollectionViewCell {
    
    let startTimeLabel = UILabel()
    let startTimeVal = UILabel()
    let endTimeLable = UILabel()
    let endTimeVal = UILabel()
    var jamName = UILabel()
    var collaborators = UILabel()
    var exportButton = UIButton()
  
  func UiSetup() {
    exportButton = UIButton(type: .infoDark)
    //make this a custom button image
    exportButton.addTarget(self, action: #selector(exportButtonPressed(sender:)), for: .touchUpInside)
    startTimeLabel = UILabel(frame: contentView.bounds)
    startTimeLabel.font = UIFont(name:"Avenir-Book", size:16)
    
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
  
  func setsFrames() {
    NSLayoutConstraint.init(item: startTimeLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint.init(item: startTimeLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint.init(item: startTimeLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
    
    NSLayoutConstraint.init(item: startTimeLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50).isActive = true
    
    NSLayoutConstraint.init(item: startTimeVal, attribute: .leading, relatedBy: .equal, toItem: startTimeLabel, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
    
    
  }
  
  
  func setup(with jam:Jam) {
    UiSetup()
    startTime.text = jam.startTime
    endTime.text = jam.endTime
    
  }
  
  override func prepareForReuse() {
    reset()
  }
  func reset() {
    endTime.text = nil
    startTime.text = nil
    
  }
  
  @objc func exportButtonPressed(sender:UIButton) {
    
  }
}


class FilesCollectionView: UIView {

  public var jams:[Jam]{
    didSet {
      collection.reloadData()
    }
  }
  var collection:UICollectionView!
  let layout = UICollectionViewFlowLayout()
  
  override init(frame:CGRect) {
    super.init(frame:frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func configLayout(layout:UICollectionViewFlowLayout) {
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: self.bounds.width, height:200)
    
  }
  
  func setup() {
    configLayout(layout: layout)
    collection = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
    collection.register(FilesCell.self, forCellWithReuseIdentifier:"cell")
    collection.delegate = self
    collection.dataSource = self
  }
}
extension FilesCollectionView:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return jams.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilesCell
    cell.setup(with: jams[indexPath.row])
    return cell
  }
}

