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
    func loadRecordings(request: Files.Request.Request)
}

protocol FilesDataStore {}

class FilesInteractor: FilesBuisnessLogic, FilesDataStore {
    
    var presenter: FilesPresentationLogic?
    var worker: FilesWorker?
    
    //add functions that FileBusinessLogic defines
    func loadRecordings(request: Files.Request.Request) {
        worker = FilesWorker()
      worker?.getUserActivity(completion: {[weak self] (done) in
        //self?.presenter?
      })
    }
}
