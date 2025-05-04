//
//  DealersListViewModel.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/30/25.
//

import Foundation
import Combine

// FIXME: look at "dealers" from response
struct GetDealersResponse: Codable {
    let status: Int
    let dealers: [Dealer]?
}

class DealersListViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    @Published var response: GetDealersResponse?
    private let service: DealersListViewModelServiceProtocol
    
    init(service: DealersListViewModelServiceProtocol = DealersListViewModelService()) {
        self.service = service
        getDealers()
    }
    
    func getDealers() {
        self.service.getDealers()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Publisher completed successfully.")
                    case .failure(let error):
                        print("Publisher error: \(error)")
                    }
                },
                receiveValue: { self.response = $0 })
            .store(in: &cancellables)
    }
}

extension DealersListViewModel {
    
    func dealerViewModel(at index: Int) -> Dealer? {
        guard let dealers = self.response?.dealers, index < dealers.count else {
            return nil
        }
        return dealers[index]
    }
}

struct DealerViewModel {
    let dealer: Dealer?
}

extension DealerViewModel {
    var dealerName: String? {
        return self.dealer?.dealerName
    }
    
    var city: String? {
        return self.dealer?.city
    }
}

struct Dealer: Codable {
    let id: Int?
    let dealerName: String?
    let city: String?
    let address: String?
    let zip: String?
    let state: String?
    let lat: String?
    let long: String?
    let shortName: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case dealerName = "full_name"
        case city
        case address
        case zip
        case state
        case lat
        case long
        case shortName = "short_name"
    }
}
