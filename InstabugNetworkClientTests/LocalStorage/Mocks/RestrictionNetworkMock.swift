//
//  RestrictionNetworkMock.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 21/10/2022.
//

import Foundation
@testable import InstabugNetworkClient

class RestrictionNetworkMock: RestrictionNetworkProtocol {
    
    var isSmallPayload = false
    var countRecords: Int {
        5
    }
    
    var maxPayloadSize: Int {
        isSmallPayload ? 10 : 1000
    }
}
