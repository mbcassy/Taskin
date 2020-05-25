//
//  Group.swift
//  Taskin
//
//  Created by Cassy on 5/23/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object {
    @objc dynamic var name: String = ""
    let tasks = List<Task>()
}
