//
//  DataServices.swift
//  SoundBoy
//
//  Created by Marlon Monroy on 9/2/17.
//  Copyright © 2017 DragLabs. All rights reserved.
//

import Foundation
import CoreData
/* =====================StoreRepresentable====================*/
public protocol StoreRepresentable {
    func fromJSON(json:JSONDictionary, response:@escaping(_ result:Bool)->())
    func fromData(data:Data, response:@escaping(_ result:Bool)->())
    
}

/* =====================FetcherRepresentable====================*/
public protocol FetcherRepresentable {
    var coreDataStore:CoreDataStore {get}
    associatedtype A
    func fetch(callback: @escaping (_ result:A?, _ error:Error?) -> ())
}
