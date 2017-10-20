//
//  UserActivityWorker.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 9/15/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreData

class RecordindsStore:StoreRepresentable{
  func from(data: Data, response: @escaping (Result<Any>) -> ()) {
    
  }
  
  let coreData = CoreDataStore(entity: .recordings)

}



class RecordindsFetcher:FetcherRepresentable {
  var coreDataStore: CoreDataStore {
    return CoreDataStore(entity:.recordings)
  }
  
  func fetch(callback: @escaping ([Recordings]?, Error?) -> ()) {
    let requst:NSFetchRequest = Recordings.fetchRequest()
    let context = coreDataStore.viewContext
    context.perform {
      do {
        let result = try requst.execute()
        if result.count > 0 {
          callback(result, nil)
        }else {
          
        }
      }catch {
        callback(nil,error)
        fatalError("Cant perform fetch for recordins error: \(error)")
      }
    }
  }
  
  func delete(callback: @escaping (_ deleted:Bool) -> ()) {
    fatalError("`func delete()` not implemented")
  }
}

class UserActivityOperation: OperationRepresentable {
  let userId:String
  
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var store:StoreRepresentable{
    return RecordindsStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ created:Result<Any>) -> ()) {
    
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .success(let data):
        self.store.from(data: data, response: result)
      case .error(_, _):
        result(Result.failed(message: "Cant get user activity", error: nil))
      }
    }
  }
  
  init(userId:String) {
    self.userId = userId
  }
  
  var request: RequestRepresentable {
    return UserRequest.activity(userId: userId)
  }
}

class UserActivityWorker: NSObject {
  let user = UserFether()
  let dispatcher = DefaultDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  func getActivity(completion:@escaping(_ done:Result<Any>)->()) {
    
    user.fetch { (user, error) in
      if user != nil {
        let operation = UserActivityOperation(userId: user!.userId!)
        operation.execute(in: self.dispatcher, result: completion)
      }
    }
  }
  
}
