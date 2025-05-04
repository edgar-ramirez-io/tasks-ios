//
//  DelearReview.swift
//  Tasks
//
//  Created by Edgar Ramirez on 5/2/25.
//

import Foundation

/*
 {
       "_id": "681155fad1e8f1be8058d91c",
       "id": 2,
       "name": "Gwenora Zettoi",
       "dealership": 23,
       "review": "Future-proofed foreground capability",
       "purchase": true,
       "purchase_date": "09/17/2020",
       "car_make": "Pontiac",
       "car_model": "Firebird",
       "car_year": 1995,
       "__v": 0,
       "sentiment": null
     }
 */
struct DealerReview: Codable {
    let id: Int?
    let name: String?
    let dealership: Int?
    let review: String?
    let purchase: Bool?
    let purchaseDate: String?
    let carMake: String?
    let carModel: String?
    let carYear: Int?
    let sentiment: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case dealership
        case review
        case purchase
        case purchaseDate = "purchase_date"
        case carMake = "car_make"
        case carModel = "car_model"
        case carYear = "car_year"
        case sentiment
    }
}
