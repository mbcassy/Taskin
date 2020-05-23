//
//  Task.swift
//  Taskin
//
//  Created by Cassy on 5/23/20.
//  Copyright © 2020 Cassy. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var completed: Bool = false
    var inGroup = LinkingObjects(fromType: Group.self, property: "tasks")
}
