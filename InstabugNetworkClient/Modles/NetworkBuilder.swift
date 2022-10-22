//
//  NetworkBuilder.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 19/10/2022.
//

import Foundation

class NetworkBuilder {
    
    // MARK: - Properties
    private let request: URLRequest
    private var statusCode: String?
    private var errorCode: String?
    private var responsePayload: String?
    private var errorDomain: String?
    private let restriction: RestrictionNetworkProtocol
    // MARK: - Init
    public init (request: URLRequest, restriction: RestrictionNetworkProtocol) {
        self.request = request
        self.restriction = restriction
    }
    
    private var method: String {
        request.httpMethod ?? ""
    }
    
    private var url: String {
        request.url?.absoluteString ?? ""
    }
    
    private var requestPayload: String? {
        convertDataToString(data: request.httpBody)
    }
    
    // MARK: - Functions
    func setResponsePayload(_ data: Data?) {
        responsePayload = convertDataToString(data: data)
    }
    
    func setErrorDomain(_ errorDomain: Error?) {
        self.errorDomain = errorDomain?.localizedDescription
    }
    
    func setStatusCode(_ code: Int) {
        statusCode = "\(code)"
    }
    
    func setErrorCode(_ code: Int) {
        errorCode = "\(code)"
    }
    
    private func convertDataToString(data: Data?) -> String {
        guard let data = data else {
            return ""
        }
        
        guard data.count <= restriction.maxPayloadSize else {
            return Constants.tooLargePayload
        }
        
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    func build() -> NetworkModel {
        NetworkModel(method: method,
                     url: url,
                     requestPayload: requestPayload,
                     statusCode: statusCode,
                     responsePayload: responsePayload,
                     errorDomain: errorDomain,
                     errorCode: errorCode)
    }
}
