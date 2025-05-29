//
//  DealerDetailsViewController.swift
//  Tasks
//
//  Created by Edgar Ramirez on 5/2/25.
//

import Foundation
import UIKit
import Combine

class DealerDetailsViewController: UITableViewController {
    private var cancellables: Set<AnyCancellable> = []
    var selectedDealer: Dealer?
    private var viewModel: DealerDetailsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "DealerDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "cellId")
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCellId")
               
        guard let dealer = selectedDealer, let dealerId = dealer.id else {
            let alert = UIAlertController(title: "Error", message: "An error has ocurrect while retrieving data. Try again later.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
            
            return
        }
        self.viewModel = DealerDetailsViewModel(dealerId: dealerId)
        
        self.viewModel?.objectWillChange
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("data changed in DealerDetailsViewModel")
                case .failure(let failure):
                    print("DealerDetailsViewModel error: \(failure)")
                }
            }, receiveValue: { [weak self] in
                self?.tableView.reloadData()
            })
            .store(in: &cancellables)
    }
}

extension DealerDetailsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if let count = self.viewModel?.numberOfDealerReviews(), count > 0 {
                return count
            } else {
                return 1 // "No reviews"
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "headerCellId")
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = "Dealer name"
            configuration.secondaryText = "Dealer description"
            
            cell.contentConfiguration = configuration
            
            // TODO: Add button to present Add Review modal
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! DealerDetailsTableViewCell
            
            if self.viewModel?.numberOfDealerReviews() ?? 0 == 0 {
                cell.titleLabel?.text = "No reviews yet"
                cell.subtitleLabel?.text = ""
            } else {
                guard let reviewViewModel = self.viewModel?.dealerReviewViewModel(at: indexPath.row) else {
                    fatalError("Review viewModel cannot be retrieved")
                }
                
                cell.titleLabel?.text = "Reviewer: \(reviewViewModel.dealerReview.name ?? "N/A") on \(reviewViewModel.dealerReview.purchaseDate ?? "N/A")"
                cell.subtitleLabel?.text = reviewViewModel.dealerReview.review
            }
            
            return cell
        }
    }
}
