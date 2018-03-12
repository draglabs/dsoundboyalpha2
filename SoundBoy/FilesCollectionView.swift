//
//  FilesCell.swift
//  dSoundBoy
//
//  Created by Craig on 10/1/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import UIKit
protocol FilesCollectionViewDelegate {
  func filesCollectionViewDidSelect(collection:FilesCollectionView, index:Int)
  func shareButtonPressed(collection:FilesCollectionView, index:IndexPath)
  func editButtonPressed(collection:FilesCollectionView, index:IndexPath)
}

class FilesCell: UICollectionViewCell {
  @IBOutlet weak var name:UILabel!
  @IBOutlet weak var exportButton:UIButton!
  @IBOutlet weak var shareButton:UIButton!
  @IBOutlet weak var editButton:UIButton!
  @IBOutlet weak var imageView:UIImageView!
  
    var exportPressed:(()->())?
    var sharePressed:(()->())?
    var editPressed:(()->())?
 
  func setup(with jam:JamResponse) {
    name.text = jam.name!
    exportButton.addTarget(self, action: #selector(exportButtonPressed(sender:)), for: .touchUpInside)
    shareButton.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
    editButton.addTarget(self, action: #selector(editButtonPressed(sender:)), for: .touchUpInside)
    guard let link = jam.link else {return }
    if !link.isEmpty {
      shareButton.isHidden = false
    }
  }
  func displayMapShotter(jam:JamResponse) {
    
  }
  @objc func exportButtonPressed(sender:UIButton) {
    self.exportPressed?()
  }
  @objc func shareButtonPressed(sender:UIButton) {
    self.sharePressed?()
  }
  @objc func editButtonPressed(sender:UIButton) {
    self.editPressed?()
  }
  override func prepareForReuse() {
    super.prepareForReuse()
    shareButton.isHidden = true
  }
}


class FilesCollectionView: UICollectionView {
  var fileDelegate:FilesCollectionViewDelegate?
  public var activity:[JamResponse] = []
  let layout = UICollectionViewFlowLayout()
  var exportPressed:((_ index:Int)->())?

  required init?(coder aDecoder: NSCoder) {
   super.init(coder: aDecoder)
    setup()
  }
  
  
  func display(jams:[JamResponse]){
    activity = jams
    reloadData()
  }
  func setup() {
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: self.bounds.width, height:253)
    collectionViewLayout = layout
    delegate = self
    dataSource = self
    backgroundColor = .clear
  }
}

extension FilesCollectionView:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return activity.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilesCell
    cell.setup(with: activity[indexPath.row])
    cell.exportPressed = { self.exportPressed?(indexPath.row)}
    cell.sharePressed = {self.fileDelegate?.shareButtonPressed(collection: self, index: indexPath)}
    cell.editPressed = {self.fileDelegate?.editButtonPressed(collection: self, index: indexPath)}
    cell.setup(with: activity[indexPath.row])
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //fileDelegate?.filesCollectionViewDidSelect(collection: self, index:indexPath.row)
  }
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//    let translate:CGPoint = collectionView.panGestureRecognizer.translation(in: self)
//    if translate.y < 0 {
//      cell.alpha = 0
//      cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
//      UIView.animate(withDuration: 0.4, animations: { () -> Void in
//        cell.alpha = 1
//        cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
//      })
//    }
    
  }
}


