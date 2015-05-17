//
//  Config.swift
//  TV
//
//  Created by Francescu on 17/05/15.
//  Copyright (c) 2015 Francescu. All rights reserved.
//

import Foundation

struct App {
    static let Group = "group.francescu"
    
    struct Path {
        static let Docs = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(App.Group)!
        static let Realm = Docs.path!.stringByAppendingPathComponent("db.realm")
    }
}

