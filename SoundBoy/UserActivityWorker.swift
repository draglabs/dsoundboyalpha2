//
//  UserActivityWorker.swift
//  dSoundBoy
//
//  Created by Marlon Monroy on 9/15/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreData

class RecordindsStore:StoreRepresentable {
  let coreData = CoreDataStore(entity: .recordings)
  var didSaveRecordings:((_ saved:Bool)->()) = { _ in   }
  var didSaveJam:((_ saved:Bool)->()) = {_ in }
  
  var response:((Bool) -> ())?
  func fromData(data: Data, response: @escaping (Bool) -> ()) {fatalError("Function not implemented")}
  func fromJSON(json: JSONDictionary, response: @escaping (Bool) -> ()) {
    self.response = response
    guard let recordings = json["recordings"] as? [JSONDictionary] else {response(false); return }
    saveRecordings(recordings: recordings)
    guard let jams = json["jams"] as? [JSONDictionary] else {response(false);return}
    saveJams(jams: jams)
  }
  
  
  private func saveRecordings(recordings:[JSONDictionary]) {
    let context = coreData.viewContext
    let recording = Recordings(context: context)
    
    coreData.save(completion: didSaveRecordings)
  }
  
 private func saveJams(jams:[JSONDictionary]) {
    let context = coreData.viewContext
    let jam = Jam(context: context)
    coreData.save(completion: didSaveJam)
  
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
}

class UserActivityOperation: OperationRepresentable {
  let userId:String
  
  var responseError:((_ code:Int?, _ error:Error?)->())?
  
  var store:StoreRepresentable {
    return RecordindsStore()
  }
  
  func execute(in dispatcher: DispatcherRepresentable, result: @escaping (_ created:Bool) -> ()) {
    
    dispatcher.execute(request: request) { (response) in
      
      switch response {
      case .data(let data):
        self.store.fromData(data: data, response: result)
      case .json(let json):
        self.store.fromJSON(json: json, response: result)
      case .error(let statusCode, let error):
        self.responseError?(statusCode, error)
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
  let dispatcher = NetworkDispatcher(enviroment: Enviroment("production", host: "https://api.draglabs.com/v1.01"))
  func getActivity(completion:@escaping(_ done:Bool)->()) {
    
    user.fetch { (user, error) in
      if user != nil {
        let operation = UserActivityOperation(userId: user!.userId!)
        operation.execute(in: self.dispatcher, result: completion)
      }
    }
  }
  
}
