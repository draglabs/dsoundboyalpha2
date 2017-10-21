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
    fileprivate let valColor = UIColor(displayP3Red: 245/255, green: 145/255, blue: 32/1255, alpha: 1)
    fileprivate let labelFont = UIFont(name:"Avenir-Medium", size:16)
    let startTimeLabel = UILabel()
    let startTimeVal = UILabel()
    let endTimeLabel = UILabel()
    let endTimeVal = UILabel()
    let jamNameLabel = UILabel()
    let jamNameVal = UILabel()
    let locationLabel = UILabel()
    let locationVal = UILabel()
    let collaboratorsLabel = UILabel()
    let collaboratorsVal = UILabel()
    let exportButton = UIButton()
    let separotor = UIView()
  
  func uiSetup() {
    backgroundColor = UIColor.white
    separotor.backgroundColor = UIColor.lightGray
    setMasking()
    
    exportButton.addTarget(self, action: #selector(exportButtonPressed(sender:)), for: .touchUpInside)
    startTimeLabel.font = labelFont
    endTimeLabel.font = labelFont
    jamNameLabel.font = labelFont
    locationLabel.font = labelFont
    collaboratorsLabel.font = labelFont
    jamNameVal.textAlignment = .center
    exportButton.setTitle("Export", for: .normal)
    exportButton.backgroundColor = UIColor.red
    separotor.frame = CGRect(x: 40, y: 40, width: bounds.width - 80, height: 1)
    
    contentView.addSubview(exportButton)
    contentView.addSubview(startTimeLabel)
    contentView.addSubview(startTimeVal)
    contentView.addSubview(endTimeLabel)
    contentView.addSubview(endTimeVal)
    contentView.addSubview(jamNameLabel)
    contentView.addSubview(jamNameVal)
    contentView.addSubview(locationLabel)
    contentView.addSubview(locationVal)
    contentView.addSubview(collaboratorsLabel)
    contentView.addSubview(separotor)
    
    let dots = DottedView(frame: CGRect(x: 0, y: 50, width: 40, height: bounds.height))
    dots.backgroundColor = UIColor.clear
    contentView.addSubview(dots)
    setConstraints()
    
  }
  
  private func valColors() {
    jamNameVal.textColor = valColor
    startTimeVal.textColor = valColor
    endTimeVal.textColor = valColor
    collaboratorsVal.textColor = valColor
    locationVal.textColor = valColor
    exportButton.setTitleColor(valColor, for: .normal)
  }
  private func setMasking() {
    startTimeVal.translatesAutoresizingMaskIntoConstraints = false
    startTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    endTimeLabel.translatesAutoresizingMaskIntoConstraints = false
    endTimeVal.translatesAutoresizingMaskIntoConstraints = false
    jamNameLabel.translatesAutoresizingMaskIntoConstraints = false
    jamNameVal.translatesAutoresizingMaskIntoConstraints = false
    locationLabel.translatesAutoresizingMaskIntoConstraints = false
    locationVal.translatesAutoresizingMaskIntoConstraints = false
    collaboratorsLabel.translatesAutoresizingMaskIntoConstraints = false
    collaboratorsVal.translatesAutoresizingMaskIntoConstraints = false
    exportButton.translatesAutoresizingMaskIntoConstraints = false
    
  }
  
  
  func setConstraints() {
    jamNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant:40).isActive = true
    jamNameLabel.topAnchor.constraint(equalTo: topAnchor,constant:10).isActive = true
    jamNameLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    jamNameVal.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    jamNameVal.topAnchor.constraint(equalTo: topAnchor,constant:10).isActive = true
    jamNameVal.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
  
    startTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
    startTimeLabel.topAnchor.constraint(equalTo: jamNameVal.bottomAnchor, constant: 20).isActive = true
    startTimeLabel.trailingAnchor.constraint(equalTo:centerXAnchor).isActive = true
    
    startTimeVal.leadingAnchor.constraint(equalTo:centerXAnchor).isActive = true
    startTimeVal.topAnchor.constraint(equalTo: jamNameVal.bottomAnchor, constant: 20).isActive = true
    startTimeVal.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
    endTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
    endTimeLabel.topAnchor.constraint(equalTo: startTimeLabel.bottomAnchor,constant:20).isActive = true
    endTimeLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    endTimeVal.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    endTimeVal.topAnchor.constraint(equalTo: startTimeVal.bottomAnchor,constant:20).isActive = true
    endTimeVal.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
    locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
    locationLabel.topAnchor.constraint(equalTo: endTimeLabel.bottomAnchor, constant: 20).isActive = true
    locationLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    locationVal.leadingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    locationVal.topAnchor.constraint(equalTo: endTimeVal.bottomAnchor, constant: 20).isActive = true
    locationVal.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    
    collaboratorsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40).isActive = true
    collaboratorsLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20).isActive = true
    collaboratorsLabel.trailingAnchor.constraint(equalTo: centerXAnchor).isActive = true
    
    exportButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
    exportButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    exportButton.heightAnchor.constraint(equalToConstant: 35).isActive = true
    exportButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
  }
  
  private func populateVals(with jam:Jams) {
    jamNameVal.text = jam.name
    collaboratorsVal.text = "\(jam.collaboratorCount)"
    startTimeVal.text = jam.startTime
    endTimeVal.text = jam.endTime
    poplulateLabels()
    valColors()
  }
  private func poplulateLabels() {
    jamNameLabel.text   = "Jam Name"
    startTimeLabel.text = "Start Time"
    endTimeLabel.text   = "End Time"
    locationLabel.text  = "Location"
    collaboratorsLabel.text = "Collaborators"
    
  }
  func setup(with jam:Jams) {
    uiSetup()
    populateVals(with: jam)
    
  }
  
  override func prepareForReuse() {
    // reset labels
  }
 
  @objc func exportButtonPressed(sender:UIButton) {
    
  }
}


class FilesCollectionView: UIView {
  var delegate:FilesCollectionViewDelegate?
  public var activity:UserActivityResponse!
  var collection:UICollectionView!
  let layout = UICollectionViewFlowLayout()
  
  override init(frame: CGRect) {
   super.init(frame: frame)
    
  }
  convenience init(frame:CGRect,activity:UserActivityResponse) {
     self.init(frame: frame)
     self.activity = activity
     setup()
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func configLayout(layout:UICollectionViewFlowLayout) {
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: self.bounds.width, height:210)
    
  }
  
  func setup() {
    configLayout(layout: layout)
    collection = UICollectionView(frame: bounds, collectionViewLayout: layout)
    collection.register(FilesCell.self, forCellWithReuseIdentifier:"cell")
    collection.delegate = self
    collection.dataSource = self
    addSubview(collection)
  }
}
extension FilesCollectionView:UICollectionViewDelegate,UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return activity.jams.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collection.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FilesCell
    cell.setup(with: activity.jams[indexPath.row])
    return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    print("selected:\(indexPath.row)")
    delegate?.filesCollectionViewDidSelect(collection: self, index:indexPath.row)
  }
}

