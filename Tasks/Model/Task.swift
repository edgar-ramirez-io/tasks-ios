//
//  Task.swift
//  Tasks
//
//  Created by Edgar Ramirez on 3/17/25.
//

/*
 [
     {
         "id": "96fd7b25-071b-4496-84a3-8ffe3e156ab2",
         "title": "",
         "description": "",
         "status": "OPEN"
     }
 ]
 */

struct Task: Codable {
    let id: String
    let title: String
    let description: String
    let status: String
}
