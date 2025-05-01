//
//  DealersListViewModelService.swift
//  Tasks
//
//  Created by Edgar Ramirez on 4/30/25.
//

import Foundation
import Combine

protocol DealersListViewModelServiceProtocol {
    func getDealers<T: Codable>() -> AnyPublisher<T, Error>
}

final class DealersListViewModelService: DealersListViewModelServiceProtocol {

    func getDealers<T: Codable>() -> AnyPublisher<T, Error> {
        return APIManager.shared.request<T>(endpoint: "http://localhost:8000/djangoapp/get_dealers", method: "GET", parameters: nil)
    }

}
