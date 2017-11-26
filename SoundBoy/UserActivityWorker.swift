//
//  UserActivityWorker.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 9/15/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreData

final class RecordindsStore:StoreRepresentable{
  func from(data: Data, response: @escaping (Result<Any>) -> ()) {
    let d = Parser().parseToAny(from: data)
    print(d)

    let decoder = JSONDecoder()
    do {
      let res = try decoder.decode([JamResponse].self, from: data)
      
      response(Result.success(data: res))
    }catch {
      print(error)
      response(Result.failed(message: "Cant Decode results", error: error))
    }
  }
  
  let coreData = CoreDataStore(entity: .recordings)

}

final class DetailStore:StoreRepresentable {
  func from(data: Data, response: @escaping (Result<Any>) -> ()) {
     let rs = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)
      
      response(Result.success(data: rs))
//    let decoder = JSONDecoder()
//    do {
//      let res = try decoder.decode(JamDetailResponse.self, from: data)
//      response(Result.success(data: res))
//    }catch {
//      print(error)
//      response(Result.failed(message: "Cant Decode results", error: error))
//    }
//  }
  }
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

class jamDetailsOperation: OperationRepresentable {
  let userId:String
  let jamId:String
  var store: StoreRepresentable {
    return DetailStore()
  }
  
  var request: RequestRepresentable {
    return UserRequest.details(userId: userId, jamId: jamId)
  }
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ result:Result<Any>) -> ()) {
    dispatcher.execute(request: request) { (response) in
      switch response {
       case .error(_, let error):
        result(Result.failed(message: "something when wrong", error: error))
      case .success(let data):
        self.store.from(data: data, response: result)
      }
    }
  }

  init(userId:String,jamId:String) {
    self.userId = userId
    self.jamId = jamId
  }

}


class UserActivityWorker: NSObject {
  let user = UserFether()
  
  let dispatcher = DefaultDispatcher(enviroment: Env().dev)
  func getActivity(completion:@escaping(_ done:Result<Any>)->()) {
    
    user.fetch { (user, error) in
      if user != nil {
        let operation = UserActivityOperation(userId: user!.userId!)
        operation.execute(in: self.dispatcher, result: completion)
      }
    }
  }
  
  func details(jamId:String,completion:@escaping(_ response:Result<Any>)->()) {
    
      self.user.fetch { (user, error) in
        if user != nil {
          let operation = jamDetailsOperation(userId: user!.userId!,jamId: jamId)
          operation.execute(in: self.dispatcher, result: completion)
        }
      }
  }
  
}

struct UserRegistrationOperation: OperationRepresentable {
  let facebookId :String
  let accessToken:String
  
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var store:StoreRepresentable {
    return UserStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ created:Result<Any>) -> ()) {
    
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .success(let data):
        self.store.from(data: data, response: result)
      case .error(_, _):
        
        result(Result.failed(message: "unable to login", error: nil))
        
      }
    }
  }
  
  init(facebookId:String,accessToken:String) {
    self.facebookId = facebookId
    self.accessToken = accessToken
  }
  
  var request: RequestRepresentable {
    return UserRequest.register(facebookId: facebookId, accessToken: accessToken)
  }
  
}
