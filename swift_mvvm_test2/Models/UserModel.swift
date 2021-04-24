//
//  UserModel.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation

// MARK: - User
struct UserModel: Entity {
    let code: Int
    let message: String
    let result: [Result]
}

// MARK: - Result
struct Result: Entity {
    let id: Int
    let name, username, email: String
    let address: Address
    let phone, website: String
    let company: Company
}

// MARK: - Address
struct Address: Entity {
    let street, suite, city, zipcode: String
    let geo: Geo
}

// MARK: - Geo
struct Geo: Entity {
    let lat, lng: String
}

// MARK: - Company
struct Company: Entity {
    let name, catchPhrase, bs: String
}
