//
//  TasksViewControllerViewModelService.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/3/25.
//

import Foundation
import Combine

protocol TasksViewControllerViewModelServiceProtocol {
    func getTasks<T: Codable>() -> AnyPublisher<T, Error>
}

final class TasksViewControllerViewModelService: TasksViewControllerViewModelServiceProtocol {
    func getTasks<T: Codable>() -> AnyPublisher<T, Error> {
        let endpoint = "http://localhost:3000/tasks/"
        
        return APIManager.shared.request<T>(endpoint: endpoint, method: "GET", parameters: nil)
    }
}


