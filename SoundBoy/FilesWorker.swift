//
//  FilesWorker.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit

class FilesWorker {
  let activityWoker = UserActivityWorker()
  func getUserActivity(completion:@escaping(_ done:Bool)->()) {
    activityWoker.getActivity(completion:completion)
    }
}
