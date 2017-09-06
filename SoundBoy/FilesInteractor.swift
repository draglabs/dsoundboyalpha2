//
//  FilesInteractor.swift
//  SoundBoy
//
//  Created by Craig on 9/3/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import UIKit


protocol FilesBuisnessLogic {
    //add functions Files needs to handle
    func loadRecordings(request: Files.Recordings.Request)
}

protocol FilesDataStore {
    
}

class FilesInteractor: FilesBuisnessLogic, FilesDataStorage {
    
    var presenter: FilesPresentationLogic?
    var worker: FilesWorker?
    
    //add functions that FileBusinessLogic defines
    func loadRecordings(request: Files.Recordings.Request) {
        worker = FilesWorker()
        worker?.doSomeWork()
    }
}
