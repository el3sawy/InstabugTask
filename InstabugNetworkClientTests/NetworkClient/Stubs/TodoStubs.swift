//
//  TodoStubs.swift
//  InstabugNetworkClientTests
//
//  Created by Ahmed Elesawy on 20/10/2022.
//

import Foundation

struct TodoStubs {
    static func createListTodo() -> [TodoModel] {
        let data = getJSON(bundle: Bundle.testBundle, for: "TodoModel")
        let foods = parse(jsonData: data)
        return foods
    }
    
    static func getTotoData() -> Data? {
        let jsonData = try? JSONEncoder().encode(createListTodo())
        return jsonData
    }
    
    private static func parse(jsonData: Data) -> [TodoModel] {
        do {
            let decodedData = try JSONDecoder().decode([TodoModel].self, from: jsonData)
           return decodedData
        } catch {
            print("decode error")
        }
        return []
    }
}
