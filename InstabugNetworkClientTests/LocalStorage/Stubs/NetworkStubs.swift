//
//  NetworkStubs.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation
@testable import InstabugNetworkClient

struct NetworkStubs {
    static func getNetworkModel() -> NetworkModel {
        let payload = "{ name: Insta }"
        return NetworkModel(method: "GET", url: URLStubs.url.absoluteString, requestPayload: nil, statusCode: "200", responsePayload: payload)
    }
}
