//
//  ViewController.swift
//  RMGraphQL
//
//  Created by Yalçın Golayoğlu on 5.02.2022.
//

import UIKit

class ViewController: UIViewController{
    var datas: [GetDatasQuery.Data.Character.Result?] = []
    var tableView: UITableView = UITableView()


    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        getData()
        tableView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
               tableView.dataSource = self
               tableView.delegate = self
        self.view.addSubview(tableView)
       
        
        
    }
    func getData(){
        Network.shaared.apollo.fetch(query: GetDatasQuery()){
            result in
            switch result {
            case .success(let graphQLResult):
                if let comingDatas = graphQLResult.data?.characters{
                    DispatchQueue.main.async {
                        self.datas = comingDatas.results!
                        self.tableView.reloadData()
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(self.datas.count)
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = datas[indexPath.row]?.name
        return cell
    }
    
    
}

