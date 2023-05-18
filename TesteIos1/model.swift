//
//  model.swift
//  TesteIos1
//
//  Created by userext on 16/05/23.
//

import Foundation

struct Task: Codable, Equatable{
    var id: Int
    var title: String
    var descript: String
    var topic: String
    
}

struct TaskList: Codable{
    var task: [Task]
}
