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
}
class DottedView: UIView {
  override func draw(_ rect: CGRect) {
   
    
    createOval(frame: CGRect(x: 5, y: 3, width: 20, height: 20))
    createLine(start:CGPoint(x:15, y: 23), end: CGPoint(x:15, y: 43))
    createOval(frame: CGRect(x: 5, y: 43, width: 20, height: 20))
    createLine(start: CGPoint(x:15,y:63), end: CGPoint(x:15,y:86))
    createOval(frame: CGRect(x: 5, y: 86, width: 20, height: 20))
    createLine(start: CGPoint(x:15,y:106), end: CGPoint(x:15,y:127                                                                                                                                                                                                                                                                                                                                                                                                                                  ))
    createOval(frame: CGRect(x: 5, y: 127, width: 20, height: 20))
  }
  
  private func createOval(frame:CGRect){
    let oval = UIBezierPath(ovalIn: frame.insetBy(dx: 0.5, dy: 0.5))
    oval.lineWidth = 1
    UIColor.red.setStroke()
    UIColor.clear.setFill()
    oval.stroke()
    oval.fill()
  }
  
  private func createLine(start:CGPoint, end:CGPoint) {
    let vertLine = UIBezierPath()
    vertLine.move(to: start)
    vertLine.addLine(to: end)
    vertLine.lineWidth = 1
    UIColor.red.setStroke()
    UIColor.clear.setFill()
    vertLine.stroke()
    vertLine.fill()
  }
}


class FilesCell: UICollectionViewCell {
  @IBOutlet weak var name:UILabel!
  @IBOutlet weak var exportButton:UIButton!
  @IBOutlet weak var shareButton:UIButton!
    var exportPressed:(()->())?
    var sharePressed:(()->())?
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  func setup(with jam:JamResponse) {
    name.text = jam.name!
    exportButton.addTarget(self, action: #selector(exportButtonPressed(sender:)), for: .touchUpInside)
    shareButton.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: .touchUpInside)
  }
  
  @objc func exportButtonPressed(sender:UIButton) {
    self.exportPressed?()
  }
  @objc func shareButtonPressed(sender:UIButton) {
    self.sharePressed?()
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
    cell.setup(with: activity[indexPath.row])
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    fileDelegate?.filesCollectionViewDidSelect(collection: self, index:indexPath.row)
  }
  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    let translate:CGPoint = collectionView.panGestureRecognizer.translation(in: self)
    if translate.y < 0 {
      cell.alpha = 0
      cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
      UIView.animate(withDuration: 0.4, animations: { () -> Void in
        cell.alpha = 1
        cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
      })
    }
    
  }
}


