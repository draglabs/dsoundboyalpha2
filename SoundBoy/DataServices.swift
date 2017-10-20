//
//  DataServices.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/2/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import CoreData
/* =====================StoreRepresentable====================*/
public protocol StoreRepresentable {
  func from(data:Data, response:@escaping(_ result:Result<Any>)->())
}

/* =====================FetcherRepresentable====================*/
public protocol FetcherRepresentable {
    var coreDataStore:CoreDataStore {get }
    associatedtype A
    func fetch(callback: @escaping (_ result:A?, _ error:Error?) -> ())
    func delete(callback:@escaping(_ deleted:Bool)->())
}
