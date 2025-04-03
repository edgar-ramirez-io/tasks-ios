//
//  TasksViewControllerViewModel.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/3/25.
//

import Combine
import Foundation

class TasksViewControllerViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    @Published var tasks: [Task]?
    
    private let service: TasksViewControllerViewModelServiceProtocol
    
    init(service: TasksViewControllerViewModelServiceProtocol = TasksViewControllerViewModelService()) {
        self.service = service
        getTasks()
    }
    
    func getTasks() {
        self.service.getTasks()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }, receiveValue: { self.tasks = $0 })
            .store(in: &cancellables)
    }
}
