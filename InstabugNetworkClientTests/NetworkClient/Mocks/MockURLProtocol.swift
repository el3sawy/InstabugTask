//
//  MockURLProtocol.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
    }
    
    // MARK: - Properties
    private(set) var activeTask: URLSessionTask?
    static var responseType: ResponseType!
    private static var responseData: Data?
    static var responseError: NSError?
    
    private lazy var session: URLSession = {
        let configuration: URLSessionConfiguration = URLSessionConfiguration.ephemeral
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
   
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    override func startLoading() {
        if let error = MockURLProtocol.responseError {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            activeTask = session.dataTask(with: request.url!)
        }
        activeTask?.cancel()
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

// MARK: - URLSession Data Delegate
extension MockURLProtocol: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        switch MockURLProtocol.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            if let data = MockURLProtocol.responseData {
                client?.urlProtocol(self, didLoad: data)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            } else {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
        default:
            break
        }
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension MockURLProtocol {
    enum MockError: Error {
        case none
    }
    
    static func simulateSuccessResponseWithValidData() {
        let response = HTTPURLResponse(url: URLStubs.url, statusCode: 200, httpVersion: nil, headerFields: nil)!
        MockURLProtocol.responseData = TodoStubs.getTotoData()
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(response)
    }
    
    static func simulateSuccessResponseFailure() {
        let response = HTTPURLResponse(url: URLStubs.url, statusCode: 500, httpVersion: nil, headerFields: nil)!
        let html = "<html> <h1> InstaBug  </h1> </html>"
        let data = html.data(using: .utf8)!
        MockURLProtocol.responseData = data
        MockURLProtocol.responseType = MockURLProtocol.ResponseType.success(response)
    }
}
