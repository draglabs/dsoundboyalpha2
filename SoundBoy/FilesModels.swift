//
//  FilesModels.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

enum Files {
  struct Request{}
  struct Response{
    let Activity:[JamResponse]
   }
  struct ViewModel{
    let Activity:[JamResponse]
  }
}
