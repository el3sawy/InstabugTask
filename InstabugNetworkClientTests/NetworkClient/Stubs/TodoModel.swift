//
//  TodoModel.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation

struct TodoModel: Codable {
    let userID, id: Int?
    let title: String?
    let completed: Bool?

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
