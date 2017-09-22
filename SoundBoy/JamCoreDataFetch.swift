//
//  JamCoreDataFetch.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/4/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData

class JamFetcher: FetcherRepresentable {
  
  var coreDataStore: CoreDataStore {
    return CoreDataStore(entity: .jam)
  }
  
  func fetch(callback: @escaping (_ result:Jam?, _ error:Error?) -> ()) {
    let context = coreDataStore.viewContext
    let jamRequest:NSFetchRequest<Jam> = Jam.fetchRequest()
    context.perform {
      do {
        let result = try jamRequest.execute()
        if result.count > 0 {
          print("number of jams from JamFetcher",result.count)
          let jam = result.first!
          callback(jam, nil)
        }else {
          callback(nil,nil)
        }
      }catch {
        callback(nil,error)
      }
    }
  }
  
  func delete(callback: @escaping (_ deleted:Bool) -> ()) {
    let context = coreDataStore.viewContext
    let request:NSFetchRequest<Jam> = Jam.fetchRequest()
    if let result = try? context.fetch(request) {
      result.forEach({ (jam) in
        context.delete(jam)
      })
     try! context.save()
      callback(true)
    }else {
      callback(false)
    }
 
  }
}

