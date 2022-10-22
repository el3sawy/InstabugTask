//
//  LimitationNetwork.swift
//  InstabugNetworkClient
//
//  Created by Ahmed Elesawy on 21/10/2022.
//

import Foundation

protocol RestrictionNetworkProtocol {
    var countRecords: Int { get }
    var maxPayloadSize: Int { get }
}

struct RestrictionNetwork: RestrictionNetworkProtocol {
    var countRecords: Int {
        return Constants.numberRecords
    }
    
    var maxPayloadSize: Int {
        return Constants.maxPayloadSize
    }
}
