//
//  TasksViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/2/25.
//

import UIKit
import Combine

fileprivate let cellId = "cellId"

// Followed MVVM desgin pattern and using Combine to
// subscribe to changes in VM
// Read more: https://livefront.com/writing/creating-a-service-layer-in-swift/

class TasksViewController: UIViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let tasksViewModel = TasksViewControllerViewModel()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Subscription to ObservableObject
        tasksViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] in
                print("Reloading table...")
                self?.updateTasksListUI()
            }
            .store(in: &cancellables)
    }
    
    // A controller action will receive the retrieved data by the ViewModel
    private func updateTasksListUI() {
        self.tableView.reloadData()
    }
}

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksViewModel.tasks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        let task = tasksViewModel.tasks?[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = task?.title ?? "N/A"
        content.secondaryText = task?.description ?? "N/A"
        content.secondaryTextProperties.color = .systemGray
        
        cell.contentConfiguration = content
        
        return cell
    }
}
