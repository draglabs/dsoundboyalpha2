//
//  UserCoreDataSave.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class UserStore: StoreRepresentable {
  let coreDataStore = CoreDataStore(entity: .user)
  var userFetchResult:((_ user:User?,_ error:Error?)->())?
  
  
  func fromData(data: Data, response: @escaping(_ uploaded:Bool)->()) {
    //MARK:TODO finish implementation
  }
  
  func fromJSON(json: JSONDictionary, response: @escaping(_ uploaded:Bool)->()) {
    
    let context = coreDataStore.viewContext
    let user = User(context: context)
    print(json)
    
    guard let userJson = json["user"] as? JSONDictionary,
      let id  = userJson["id"] as? String,
      let name = userJson["first_name"] as? String,
      let lastName = userJson["last_name"] as? String
      else {return}
    user.userId = id
    user.firstName = name
    user.lastName = lastName
    coreDataStore.save(completion: response)
    
  }

  
}
