//
//  DealerDetailsViewModel.swift
//  Tasks
//
//  Created by Edgar Ramirez on 5/2/25.
//

import Foundation
import Combine

struct GetReviewsDelearResponse: Codable {
    let status: Int?
    let reviews: [DealerReview]?
}

class DealerDetailsViewModel: ObservableObject {
    var cancellables: Set<AnyCancellable> = []
    @Published var response: GetReviewsDelearResponse?
    private let service: DealerDetailsViewModelServiceProtocol
    
    init(
        service: DealerDetailsViewModelServiceProtocol = DealerDetailsViewService(),
        dealerId: Int) {
        self.service = service
        getDelearDetails(dealerId)
    }
    
    func getDelearDetails(_ dealerId: Int) {
        self.service
            .getDealerDetails(dealerId: dealerId)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Publisher completed!")
                case .failure(let failure):
                    print("Publisher error: \(failure)")
                }
            }) { self.response = $0 }
            .store(in: &cancellables)
    }
}

struct DealerReviewViewModel {
    let dealerReview: DealerReview
}

extension DealerDetailsViewModel {
    func dealerReviewViewModel(at index: Int) -> DealerReviewViewModel? {
        guard let reviews = self.response?.reviews, index < reviews.count else {
            return nil
        }
        return DealerReviewViewModel(dealerReview: reviews[index])
    }
    
    func numberOfDealerReviews() -> Int? {
        return self.response?.reviews?.count
    }
}
