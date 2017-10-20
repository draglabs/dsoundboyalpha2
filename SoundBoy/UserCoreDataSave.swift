//
//  UserCoreDataSave.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class UserStore: StoreRepresentable {
  func from(data: Data, response: @escaping (Result<Any>) -> ()) {
    let context = coreDataStore.viewContext
    let user = User(context: context)
    let decoder = JSONDecoder()
    let resp = try! decoder.decode(UserResponse.self, from: data)
   
    user.userId = resp.user.id
    user.firstName = resp.user.name
    user.lastName = resp.user.lastName

    context.perform {
      do {
        try context.save()
        response(Result.success(data:user))
      }catch {
        response(Result.failed(message: "Cant save user", error: error))
      }
    }
    
  }
  

  let coreDataStore = CoreDataStore(entity: .user)

}
