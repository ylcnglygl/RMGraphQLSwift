
//
//  RMViewModel.swift
//  RMGraphQL
//
//  Created by Yalçın Golayoğlu on 5.02.2022.
//

import Foundation

protocol IRMViewModel{
    var filterName: String{get set}
    func fetchItems(newPage: Int)
    var filteredDatas: [GetCharacterQuery.Data.Character.Result?]{get set}
    var page: Int {get set}
    var pagination: Bool {get set}
    var rmNetwork: Network{get}
    var rmOutput: RMOutput?{get}
    func setDelegate(output: RMOutput)
}

class RMViewModel: IRMViewModel{
    var pagination: Bool = false
    var page: Int = 1
    init(){
        rmNetwork = Network.shared
        
    }
    func fetchItems(newPage: Int) {
        rmNetwork.apollo.fetch(query: GetCharacterQuery(name: filterName, page: newPage)){
            [weak self] result in
            switch result{
            case .success(let graphQLResult):
                if let comingDatas = graphQLResult.data?.characters{
                    DispatchQueue.main.async {
                        if(self?.pagination == true){
                            self?.filteredDatas.append(contentsOf: comingDatas.results ?? [])
                        }else{
                            self?.filteredDatas = comingDatas.results ?? []
                        }
                        self?.rmOutput?.saveDatas(datas: self?.filteredDatas ?? [])
                    }
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    var filterName: String = ""
    
    var filteredDatas: [GetCharacterQuery.Data.Character.Result?] = []
    
    var rmNetwork: Network
    
    var rmOutput: RMOutput?
    
    func setDelegate(output: RMOutput) {
        rmOutput = output
    }
    
    
}
