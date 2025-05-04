//
//  DealersTableViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/30/25.
//

import Foundation
import UIKit
import Combine

class DealersTableViewController: UITableViewController {
    private var cancellables: Set<AnyCancellable> = []
    private let dealersListViewModel = DealersListViewModel()
    weak var dismissDelegate: LoginViewControllerDismissDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        dealersListViewModel.objectWillChange
            .receive(on: RunLoop.main)
            .sink(
                receiveValue: { [weak self] in
                    self?.tableView.reloadData()
                })
            .store(in: &cancellables)
    }
}

extension DealersTableViewController {
    @IBAction func logout() {
        self.dismissDelegate?.dismissOtherViewControllerAndLogout?()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailSegue",
           let vc = segue.destination as? DealerDetailsViewController,
           let indexPath = sender as? IndexPath {
            vc.selectedDealer = self.dealersListViewModel.dealerViewModel(at: indexPath.row)
        }
    }
}

extension DealersTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dealersListViewModel.response?.dealers?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as? DealerTableViewCell else {
            fatalError("DealerTableViewCell cannot be created")
        }
        let vm = self.dealersListViewModel.dealerViewModel(at: indexPath.row)
        
        cell.titleLabel?.text = vm?.dealerName ?? "N/A"
        let fullAddress = "\(vm?.address ?? "N/A")\n\(vm?.city ?? "N/A"), \(vm?.state ?? "N/A")\n\(vm?.zip ?? "N/A")"
        cell.descriptionLabel?.text = fullAddress
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: "showDetailSegue", sender: indexPath)
    }
}
