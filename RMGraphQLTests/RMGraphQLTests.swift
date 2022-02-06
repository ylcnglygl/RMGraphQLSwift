//
//  RMGraphQLTests.swift
//  RMGraphQLTests
//
//  Created by Yalçın Golayoğlu on 6.02.2022.
//

import XCTest
@testable import RMGraphQL

class RMGraphQLTests: XCTestCase {
    var viewModel: RMViewModel!
    var filteredData: [GetCharacterQuery.Data.Character.Result?]!
    override func setUp() {
        viewModel = .init()
    }
    func testFilterName(){
        XCTAssertNotNil(viewModel.filterName)
    }
    func testRMNetwork(){
        XCTAssertNotNil(viewModel.rmNetwork)
    }
    
    func testComingDatasAll(){
        viewModel.filterName = ""
        viewModel.pagination = true
        viewModel.fetchItems(newPage: 1)
        XCTAssertNotNil(viewModel.filteredDatas)
    }
    func testComingDatasRick(){
        viewModel.filterName = "rick"
        viewModel.pagination = true
        viewModel.fetchItems(newPage: 1)
        XCTAssertNotNil(viewModel.filteredDatas)
    }
    func testComingDatasMorty(){
        viewModel.filterName = "morty"
        viewModel.pagination = true
        viewModel.fetchItems(newPage: 1)
        XCTAssertNotNil(viewModel.filteredDatas)
    }
   
  

}
