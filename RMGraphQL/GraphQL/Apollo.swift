//
//  Apollo.swift
//  RMGraphQL
//
//  Created by Yalçın Golayoğlu on 5.02.2022.
//

import Foundation
import Apollo

class Network {
    static let shared = Network()
    private init(){}
    lazy var apollo = ApolloClient(url: URL(string: "https://rickandmortyapi.com/graphql")!)
}
