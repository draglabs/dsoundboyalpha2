//
//  UserCoreDataFetch.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class UserFether: FetcherRepresentable {
  
  var coreDataStore: CoreDataStore {
    return CoreDataStore(entity: .jam)
  }
  
  func fetch(callback: @escaping (_ result:User?, _ error:Error?) -> ()) {
    let context = coreDataStore.viewContext
    let jamRequest:NSFetchRequest<User> = User.fetchRequest()
    context.perform {
      do {
        let result = try jamRequest.execute()
        if result.count > 0 {
          let user = result.first!
          callback(user, nil)
        }else {
          callback(nil,nil)
        }
      }catch {
        callback(nil,error)
      }
    }
  }
  
  func delete(callback: @escaping (_ deleted:Bool) -> ()) {
    
  }
}

