//
//  EditTableView.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 1/1/18.
//  Copyright © 2018 DragLabs. All rights reserved.
//

import UIKit
enum CellType {
  case name
  case location
  case notes
  case base
}
protocol EditingCellDelegate {
  func didEndEditing(cellType:CellType,text:String)
}
class EditCellBase: UITableViewCell {
  var cellType:CellType {
    return .base
  }
  var delegate:EditingCellDelegate?
  var didEnd: (() -> ())?
  @IBOutlet weak var textfield:UITextField!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    textfield.addTarget(self, action: #selector(textfieldDidEndEditing(sender:)), for: .editingDidEnd)
  }
  
  @objc func textfieldDidEndEditing(sender:UITextField) {
    if sender.text != nil{
      delegate?.didEndEditing(cellType: cellType, text: sender.text!)
    }
  }
}

class EditNameCell: EditCellBase {
  override var cellType: CellType {
    return .name
  }
}
class EditLocationCell: EditCellBase {
  override var cellType: CellType {
    return .location
  }
}

class EditNotesCell: UITableViewCell,UITextViewDelegate {
  var delegate:EditingCellDelegate?
  var cellType:CellType {
    return .notes
  }
  @IBOutlet weak var textfield:UITextView!
  override func awakeFromNib() {
    super.awakeFromNib()
    textfield.delegate = self
  }
  
  @objc func textfieldDidEndEditing(sender:UITextView) {
    if sender.text != nil{
      delegate?.didEndEditing(cellType: cellType, text: sender.text!)
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text != nil{
      if !textView.text!.isEmpty{
        delegate?.didEndEditing(cellType: cellType, text: textView.text!)
      }
    }
    
  }
}

class EditTableView: UITableView {
  
  struct Updates {
    var name:String
    var location:String
    var notes:String
  }
  var updates:Updates!
  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
    dataSource = self
  }
  var jamText:[String:String] = [:]
  
  func display(name:String,location:String,notes:String) {
    jamText["name"] = name
    jamText["location"] = location
    jamText["notes"] = notes

    updates = Updates(name: name, location: location, notes: notes)
    DispatchQueue.main.async {
      self.reloadData()
    }
    
 }
  
  func customize() {
    
  }
}

extension EditTableView:UITableViewDelegate,UITableViewDataSource,EditingCellDelegate {
  func didEndEditing(cellType: CellType, text: String) {
    switch cellType {
    case .name:
      updates.name = text
    case .location:
      updates.location = text
    case .notes:
      updates.notes = text
    case .base: break
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
   return  3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editName") as! EditNameCell
      cell.textfield.text = jamText["name"]
      cell.textfield.becomeFirstResponder()
      cell.delegate = self
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editLocation") as! EditLocationCell
      cell.textfield.text = jamText["location"]
      cell.delegate = self
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editNotes") as! EditNotesCell
      cell.textfield.text = jamText["notes"]
      cell.delegate = self
      return cell
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "edit") as! EditNameCell
      return cell
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 || indexPath.row == 1 {
      return 80
    }else {
      return 135
    }
  }
  
  
}
