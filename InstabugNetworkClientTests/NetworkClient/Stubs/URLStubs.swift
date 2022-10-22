//
//  URLStubs.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation

enum URLStubs {
    static var url: URL { URL(string: "//any.com/")! }
    static var urlRequest: URLRequest { URLRequest(url: url) }
}
