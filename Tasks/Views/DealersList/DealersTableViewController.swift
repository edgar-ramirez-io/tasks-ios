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

    var filteredDealers: [Dealer] = []
    var isSearching = false
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.hidesBackButton = true
        
        dealersListViewModel.$response
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                    self?.filteredDealers = []
                    self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        dealersListViewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self?.present(alert, animated: true)
            }
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
        return self.isSearching
        ? self.filteredDealers.count
        : self.dealersListViewModel.dealersViewModel()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DealerTableViewCell
        let vm = self.isSearching ? self.filteredDealers[indexPath.row] : self.dealersListViewModel.dealerViewModel(at: indexPath.row)
        
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

extension DealersTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.isSearching = false
        } else {
            self.isSearching = true
            self.filteredDealers = self.dealersListViewModel.dealersViewModel()?.filter({ $0.dealerName?.contains(searchText) ?? false }) ?? []
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.isSearching = false
        self.filteredDealers = []
        self.tableView.reloadData()
    }
}
