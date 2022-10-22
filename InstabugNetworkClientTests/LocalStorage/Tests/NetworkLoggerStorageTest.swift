//
//  InstabugNetworkClientTests.swift
//  InstabugNetworkClientTests
//
//  Created by Yousef Hamza on 1/13/21.
//

import XCTest
@testable import InstabugNetworkClient

class NetworkLoggerStorageTest: XCTestCase {
    
    // MARK: - Properties
    var sut: NetworkLoggerStorage!
    var storage: CoreDataStorageMock!
    var restriction: RestrictionNetworkMock!
    
    override func setUpWithError() throws {
        restriction = RestrictionNetworkMock()
        #if TESTING
        storage = CoreDataStorageMock()
        sut = NetworkLoggerStorage(coreDataStorage: storage, restriction: restriction)
        #endif
    }
    
    override func tearDownWithError() throws {
        sut = nil
        storage = nil
        restriction = nil
    }
    
    func test_saveRecord_success_expectedCountOneItem() {
        // Given
        let model = NetworkStubs.getNetworkModel()
        
        // When
        sut.save(model)
        sut.fetchRequests { records in
            // Then
            XCTAssertEqual(records.count, 1)
        }
    }
    
    func test_deleteOneRecord_success_expectedCountZeroItem() {
        // Given
        let model = NetworkStubs.getNetworkModel()
        
        // When
         sut.save(model) { record in
            self.sut.delete(record: record)
        }
        sut.fetchRequests { records in
            // Then
            XCTAssertEqual(records.count, 0)
        }
    }
    
    func test_saveSevenRecords_success_expectedFiveRecords() {
        // Given
        let model = NetworkStubs.getNetworkModel()
        
        // Then
        for _ in 1...7 {
            sut.save(model)
        }
        
        sut.fetchRequests { records in
            // Then
            XCTAssertEqual(records.count, 5)
        }
    }
}
