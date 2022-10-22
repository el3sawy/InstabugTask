//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient

class InstabugNetworkClientTests: XCTestCase {
    
    // MARK: - Properties
    var sut: NetworkClient!
    var session: URLSession!
    var storage: NetworkLoggerStorageSpy!
    var restriction: RestrictionNetworkMock!
    
    override func setUpWithError() throws {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        storage = NetworkLoggerStorageSpy()
        restriction = RestrictionNetworkMock()
        #if TESTING
        sut = NetworkClient(urlSession: session, storage: storage, restriction: restriction)
        #endif
    }

    override func tearDownWithError() throws {
        sut = nil
        session = nil
        MockURLProtocol.responseError = nil
    }
    
    func test_request_get_success_response() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        
        var requests: [NetworkModel] = []
        // When
        sut.get(URLStubs.url) { data in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        storage.fetchRequests { records in
            requests = records
        }
        let request = requests.first
        // Then
        XCTAssertEqual(storage.isSaveCalled, 1, "The method not called or maybe called more than once")
        XCTAssertEqual(requests.count, 1, "Number if items must be only one item")
        
        XCTAssertEqual(request?.method, "GET")
        XCTAssertTrue(((request?.requestPayload?.isEmpty) ?? false))
        XCTAssertNotNil(request?.responsePayload, "Data must not be nil")
        XCTAssertEqual(request?.statusCode, "200")
    }
    
    
    func test_request_post_success_response() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        var requests: [NetworkModel] = []
        // When
        sut.post(URLStubs.url, payload: TodoStubs.getTotoData()) { _ in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        // Then
        storage.fetchRequests { records in
            requests = records
        }
        let request = requests.first
        XCTAssertEqual(request?.method, "POST")
        XCTAssertNotNil(request?.requestPayload)
        XCTAssertNotNil(request?.responsePayload, "Data must not be nil")
        XCTAssertEqual(request?.statusCode, "200")
    }
    
    func test_request_put_success_response() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        var requests: [NetworkModel] = []
        
        // When
        sut.put(URLStubs.url) { _ in expectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        storage.fetchRequests { records in requests = records }
        
        let request = requests.first
        XCTAssertEqual(request?.method, "PUT")
        XCTAssertTrue(((request?.requestPayload?.isEmpty) ?? false))
        XCTAssertNotNil(request?.responsePayload, "Data must not be nil")
        XCTAssertEqual(request?.statusCode, "200")
    }
    
    func test_request_delete_success_response() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        var requests: [NetworkModel] = []
        
        // When
        sut.delete(URLStubs.url) { _ in expectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)
        
        storage.fetchRequests { records in requests = records }
        let request = requests.first
        // Then
        XCTAssertEqual(request?.method, "DELETE")
        XCTAssertTrue(((request?.requestPayload?.isEmpty) ?? false))
        XCTAssertNotNil(request?.responsePayload, "Data must not be nil")
        XCTAssertEqual(request?.statusCode, "200")
    }
    
    
    func test_request_get_failure_response() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = NSError(domain: "Internal server error", code: 500, userInfo: nil)
        MockURLProtocol.simulateSuccessResponseFailure()
        var requests: [NetworkModel] = []
        
        // When
        sut.get(URLStubs.url) { data in expectation.fulfill() }
        waitForExpectations(timeout: 1, handler: nil)
        
        // Then
        storage.fetchRequests { records in requests = records }
        let request = requests.first
        
        XCTAssertEqual(self.storage.isSaveCalled, 1, "The method not called or maybe called more than once ")
        XCTAssertEqual(requests.count, 1, "Number of items must be only one item")
        
        XCTAssertEqual(request?.method, "GET")
        XCTAssertEqual(request?.errorCode, "500")
        XCTAssertEqual(request?.errorDomain, "The operation couldn’t be completed. (Internal server error error 500.)")
    }
    
    func test_request_get_success_tooLongResponse() {
        // Given
        let expectation = expectation(description: "Network call fails")
        MockURLProtocol.responseError = nil
        MockURLProtocol.simulateSuccessResponseWithValidData()
        restriction.isSmallPayload = true
        var requests: [NetworkModel] = []
        // When
        sut.get(URLStubs.url) { data in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        storage.fetchRequests { records in
            requests = records
        }
        let request = requests.first
        // Then
        XCTAssertEqual(request?.responsePayload, Constants.tooLargePayload)
    }
}
