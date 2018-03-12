//
//  FilesDetailInteractor.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 10/20/17.
//  Copyright (c) 2017 DragLabs. All rights reserved.


import UIKit

protocol FilesDetailBusinessLogic {
  func detail(request: FilesDetail.Detail.Request)
}

protocol FilesDetailDataStore {
  var jamId: String! { get set}
}

class FilesDetailInteractor: FilesDetailBusinessLogic, FilesDetailDataStore {
  var presenter: FilesDetailPresentationLogic?
  var worker: FilesDetailWorker?
  let detailsWorker = UserActivityWorker()
  var jamId: String!
  
  // MARK: Do something
  
  func detail(request: FilesDetail.Detail.Request) {
    
    detailsWorker.details(jamId:jamId) { (result) in
      
    }
  }
}
