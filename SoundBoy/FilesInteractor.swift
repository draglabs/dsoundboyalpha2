//
//  FilesInteractor.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Modified by Marlon on 9/15/17
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit


protocol FilesBuisnessLogic {
    //add functions Files needs to handle
    func loadRecordings(request: Files.Request)
}

protocol FilesDataStore {
  var activity:[JamResponse]? { get }
}

class FilesInteractor: FilesBuisnessLogic, FilesDataStore {  
    var activity: [JamResponse]?
    var presenter: FilesPresentationLogic?
    var worker: FilesWorker?
    
    //add functions that FileBusinessLogic defines
    func loadRecordings(request: Files.Request) {
        worker = FilesWorker()
      worker?.getUserActivity(completion: {[weak self] (result) in
        switch result {
        case .success(let data):
          let jams = data as! [JamResponse]
          self?.activity = jams
          self?.presenter?.presentJams(response: Files.Response(Activity: jams))
        default:
          break
        }
      })
    }
}
