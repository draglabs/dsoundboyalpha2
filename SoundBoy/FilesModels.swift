//
//  FilesModels.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

enum Files
{
    enum Request
    {
        struct Request{}
        struct Response{}
        struct ViewModel
        {
          let jams:[Jam]
        }
    }
    
    enum Listen
    {
        struct Request{}
        struct Response {}
        struct ViewModel {}
    }
}
