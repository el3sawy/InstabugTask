//
//  NetworkModel.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 19/10/2022.
//

import Foundation

public struct NetworkModel {
    
    // MARK: - Properties
    
    // Request Properties
    var method: String
    var url: String
    var requestPayload: String?
    
    // Response Properties
    var statusCode: String?
    var responsePayload: String?
    var errorDomain: String?
    var errorCode: String?
    
    // MARK: - Init
    public init(method: String,
                url: String,
                requestPayload: String? = nil,
                statusCode: String? = nil,
                responsePayload: String? = nil,
                errorDomain: String? = nil,
                errorCode: String? = nil) {
        self.method = method
        self.url = url
        self.requestPayload = requestPayload
        self.statusCode = statusCode
        self.responsePayload = responsePayload
        self.errorDomain = errorDomain
        self.errorCode = errorCode
    }
}
