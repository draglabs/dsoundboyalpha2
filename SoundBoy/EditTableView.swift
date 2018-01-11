//
//  EditTableView.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 1/1/18.
//  Copyright © 2018 DragLabs. All rights reserved.
//

import UIKit

class EditNameCell: UITableViewCell {
  @IBOutlet weak var textfield:UITextField!
}

class EditLocationCell: UITableViewCell {
  @IBOutlet weak var textfield:UITextField!
}

class EditNotesCell: UITableViewCell {
  @IBOutlet weak var textfield:UITextView!
}

class EditTableView: UITableView {

  override func awakeFromNib() {
    super.awakeFromNib()
    delegate = self
    dataSource = self
  }
  
  func setup() {
    
 }
  
  func customize() {
    
  }
  
}

extension EditTableView:UITableViewDelegate,UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
   return  3
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editName") as! EditNameCell
      return cell
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editLocation") as! EditLocationCell
      return cell
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "editNotes") as! EditNotesCell
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
