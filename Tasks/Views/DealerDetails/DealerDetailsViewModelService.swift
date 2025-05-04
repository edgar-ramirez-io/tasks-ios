//
//  DealerDetailsViewModelService.swift
//  Tasks
//
//  Created by Edgar Ramirez on 5/2/25.
//

import Foundation
import Combine

protocol DealerDetailsViewModelServiceProtocol {
    func getDealerDetails<T: Codable>(delearId: Int) -> AnyPublisher<T, Error>
}

final class DealerDetailsViewService: DealerDetailsViewModelServiceProtocol {
    func getDealerDetails<T: Codable>(delearId: Int) -> AnyPublisher<T, Error> {
        return APIManager.shared.request(endpoint: "http://localhost:8000/djangoapp/reviews/dealer/\(delearId)", method: "GET", parameters: nil)
    }
}
