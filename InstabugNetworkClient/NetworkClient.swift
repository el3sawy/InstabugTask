//
//  NetworkClient.swift
//  InstabugNetworkClient
//
//  Created by Yousef Hamza on 1/13/21.
//

import Foundation

public protocol NetworkClientProtocol {
    func get(_ url: URL, completionHandler: @escaping (Data?) -> Void)
    func post(_ url: URL, payload: Data?, completionHandler: @escaping (Data?) -> Void)
    func put(_ url: URL, payload: Data?, completionHandler: @escaping (Data?) -> Void)
    func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void)
    func allNetworkRequests(completion: (([NetworkModel]) -> Void))
}

public class NetworkClient {
    
    //MARK: - Properties
    private let urlSession: URLSession
    private let storage: NetworkLoggerStorageProtocol
    public static var shared = NetworkClient()
    private let restriction: RestrictionNetworkProtocol
    
    #if TESTING
    //MARK: - Init
    init(urlSession: URLSession,
         storage: NetworkLoggerStorageProtocol,
         restriction: RestrictionNetworkProtocol) {
        self.urlSession = urlSession
        self.storage = storage
        self.restriction = restriction
    }
   #else
   private init(urlSession: URLSession, storage: NetworkLoggerStorageProtocol, restriction: RestrictionNetworkProtocol) {
        self.urlSession = urlSession
        self.storage = storage
       self.restriction = restriction
    }
   #endif
    private convenience init() {
        self.init(urlSession: URLSession.shared, storage: NetworkLoggerStorage(), restriction: RestrictionNetwork())
    }
    
    // MARK: - Network requests
    func executeRequest(_ url: URL, method: String, payload: Data?, completionHandler: @escaping (Data?) -> Void) {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = payload
        
        urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.handleResponse(request: urlRequest , response: response, data: data, error: error)
                completionHandler(data)
            }
        }.resume()
    }
    
    private func handleResponse(request: URLRequest,
                                response: URLResponse?,
                                data: Data?,
                                error: Error?) {
        let networkBuilder = NetworkBuilder(request: request, restriction: restriction)
       
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            networkBuilder.setStatusCode(statusCode)
            networkBuilder.setResponsePayload(data)
        }
        
        if let errorCode = (error as NSError?)?.code {
            networkBuilder.setErrorCode(errorCode)
            networkBuilder.setErrorDomain(error)
        }
       
        let networkModel = networkBuilder.build()
        storage.save(networkModel, completion: nil)
    }
}

// MARK: - Extension
extension NetworkClient: NetworkClientProtocol {
    
    public func allNetworkRequests(completion: (([NetworkModel]) -> Void)) {
        storage.fetchRequests(completion: completion)
    }
    
    public func get(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "GET", payload: nil, completionHandler: completionHandler)
    }
    
    public func post(_ url: URL, payload: Data? = nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "POSt", payload: payload, completionHandler: completionHandler)
    }
    
    public func put(_ url: URL, payload: Data? = nil, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "PUT", payload: payload, completionHandler: completionHandler)
    }
    
    public func delete(_ url: URL, completionHandler: @escaping (Data?) -> Void) {
        executeRequest(url, method: "DELETE", payload: nil, completionHandler: completionHandler)
    }
}
