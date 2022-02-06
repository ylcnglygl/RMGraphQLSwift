//
//  ViewController.swift
//  RMGraphQL
//
//  Created by Yalçın Golayoğlu on 5.02.2022.
//

import UIKit
import SnapKit

protocol RMOutput{
    func saveDatas(datas: [GetCharacterQuery.Data.Character.Result?])
}

class ViewController: UIViewController{
    private lazy var filteredDatas: [GetCharacterQuery.Data.Character.Result?] = []
    lazy var viewModel: IRMViewModel = RMViewModel()
    // Labels
    private let headLabelTitle: UILabel = UILabel()
    private let filterLabel: UILabel = {
        let label = UILabel()
        label.text = "Filter"
        label.font = UIFont(name: "Roboto", size: 24)
        label.tintColor = .black
        label.sizeToFit()
        return label
    }()
    private let rickLabel: UILabel = {
        let label = UILabel()
        label.text = "Rick"
        label.font = UIFont(name: "Roboto", size: 24)
        label.tintColor = .black
        label.sizeToFit()
        return label
    }()
    private let mortyLabel: UILabel = {
        let label = UILabel()
        label.text = "Morty"
        label.font = UIFont(name: "Roboto", size: 24)
        label.tintColor = .black
        label.sizeToFit()
        return label
    }()
    
    // UIViews
    private let uncheckedViewRick: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isUserInteractionEnabled = true
        return view
    }()
    private let checkedViewRick: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    private let uncheckedViewMorty: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.isUserInteractionEnabled = true
        return view
    }()
    private let checkedViewMorty: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        view.clipsToBounds = true
        return view
    }()
    private let chooseDialogView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        return view
    }()
    private let thinLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 128, green: 128, blue: 128, alpha: 1)
        return view
    }()
    
    // UIImageViews
    private let filterLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "filter")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.setDelegate(output: self)
        viewModel.filterName = ""
        viewModel.fetchItems(newPage: 1)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFilter(tapGestureRecognizer:)))
        filterLogo.addGestureRecognizer(tapGestureRecognizer)
        let tapGestureRecognizerRick = UITapGestureRecognizer(target: self, action: #selector(chooseRick(tapGestureRecognizer:)))
        uncheckedViewRick.addGestureRecognizer(tapGestureRecognizerRick)
        let tapGestureRecognizerMorty = UITapGestureRecognizer(target: self, action: #selector(chooseMorty(tapGestureRecognizer:)))
        uncheckedViewMorty.addGestureRecognizer(tapGestureRecognizerMorty)
        checkedViewRick.isHidden = true
        checkedViewMorty.isHidden = true
        
    }
    
    @objc func addFilter(tapGestureRecognizer: UITapGestureRecognizer){
        chooseDialogView.isHidden = !chooseDialogView.isHidden
    }
    
    @objc func chooseRick(tapGestureRecognizer: UITapGestureRecognizer){
        checkedViewMorty.isHidden = true
        checkedViewRick.isHidden = false
        viewModel.filterName = "Rick"
        viewModel.page = 1
        viewModel.fetchItems(newPage: viewModel.page)
        tableView.reloadData()
        

    }
    @objc func chooseMorty(tapGestureRecognizer: UITapGestureRecognizer){
        checkedViewRick.isHidden = true
        checkedViewMorty.isHidden = false
        viewModel.filterName = "Morty"
        viewModel.page = 1
        viewModel.fetchItems(newPage: viewModel.page)
        tableView.reloadData()
       

        
    }
    func configure(){
        view.addSubview(headLabelTitle)
        view.addSubview(tableView)
        view.addSubview(filterLogo)
        view.addSubview(uncheckedViewRick)
        view.addSubview(uncheckedViewMorty)
        view.addSubview(chooseDialogView)
        // Choose Dialog
        chooseDialogView.addSubview(filterLabel)
        chooseDialogView.addSubview(thinLine)
        chooseDialogView.addSubview(rickLabel)
        chooseDialogView.addSubview(mortyLabel)
        chooseDialogView.addSubview(checkedViewRick)
        chooseDialogView.addSubview(uncheckedViewRick)
        chooseDialogView.addSubview(checkedViewMorty)
        chooseDialogView.addSubview(uncheckedViewMorty)
        uncheckedViewRick.addSubview(checkedViewRick)
        uncheckedViewMorty.addSubview(checkedViewMorty)
        drawDesign()
        setUpLabelTitle()
        setUpFilterLogo()
        setUpTableView()
        
        // Choose Dialog View Style
        
        setUpChooseDialogView()
        setUpFilterLabel()
        setUpThinLine()
        setUpRickLabel()
        setUpMortyLabel()
        setUpCheckedView()
        
    }
    func drawDesign(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(RickyMortyTableViewCell.self, forCellReuseIdentifier: RickyMortyTableViewCell.Identifier.custom.rawValue)
        tableView.rowHeight = view.height/2.5
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        chooseDialogView.layer.zPosition = 1
        chooseDialogView.isHidden = true
        chooseDialogView.layer.cornerRadius = 10
        chooseDialogView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        thinLine.layer.borderWidth = 0.5
        checkedViewRick.layer.cornerRadius = 8
        uncheckedViewRick.layer.cornerRadius = 12
        checkedViewMorty.layer.cornerRadius = 8
        uncheckedViewMorty.layer.cornerRadius = 12
        
        
        DispatchQueue.main.async {
            self.view.backgroundColor = .white
            self.headLabelTitle.text = "Rick and Morty"
            self.headLabelTitle.textColor = .black
            //            self.labelTitle.font = UIFont(name: "Roboto", size: 24)
            self.headLabelTitle.font = .boldSystemFont(ofSize: 24)
            
        }
    }
    
    // View Design
    
    func setUpLabelTitle(){
        headLabelTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalTo(view.center.x)
            make.height.greaterThanOrEqualTo(28)
        }
    }
    func setUpFilterLogo(){
        filterLogo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.right.equalTo(-24)
            make.height.width.equalTo(23)
        }
    }
    
    func setUpTableView(){
        tableView.snp.makeConstraints { make in
            make.top.equalTo(headLabelTitle.snp.bottom).offset(22)
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
    }
    
    // Choose Dialog View Design
    
    func setUpChooseDialogView(){
        chooseDialogView.snp.makeConstraints { make in
            make.center.equalTo(view.center)
            make.right.equalTo(-26)
            make.left.equalTo(22)
            make.height.equalTo(view.height/5)
            make.width.equalTo(view.width)
        }
    }
    
    func setUpFilterLabel(){
        filterLabel.snp.makeConstraints { make in
            make.left.top.equalTo(16)
        }
    }
    func setUpThinLine(){
        thinLine.snp.makeConstraints { make in
            make.top.equalTo(52)
            make.width.equalTo(view.width)
            make.height.equalTo(0.2)
            make.right.equalTo(chooseDialogView.right)
            make.left.equalTo(chooseDialogView.left)
        }
    }
    func setUpRickLabel(){
        rickLabel.snp.makeConstraints { make in
            make.top.equalTo(68)
            make.left.equalTo(16)
        }
    }
    func setUpMortyLabel(){
        mortyLabel.snp.makeConstraints { make in
            make.top.equalTo(112)
            make.left.equalTo(16)
        }
    }
    func setUpCheckedView(){
        uncheckedViewRick.snp.makeConstraints { make in
            make.right.equalTo(chooseDialogView.right).offset(-16)
            make.top.equalTo(68)
            make.height.width.equalTo(24)
        }
        checkedViewRick.snp.makeConstraints { make in
            make.left.equalTo(uncheckedViewRick.left).offset(4)
            make.top.equalTo(uncheckedViewRick.top).offset(4)
            make.height.width.equalTo(16)
        }
        uncheckedViewMorty.snp.makeConstraints { make in
            make.right.equalTo(chooseDialogView.right).offset(-16)
            make.top.equalTo(108)
            make.height.width.equalTo(24)
        }
        checkedViewMorty.snp.makeConstraints { make in
            make.left.equalTo(uncheckedViewMorty.left).offset(4)
            make.top.equalTo(uncheckedViewMorty.top).offset(4)
            make.height.width.equalTo(16)
        }
        
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: RickyMortyTableViewCell = tableView.dequeueReusableCell(withIdentifier: RickyMortyTableViewCell.Identifier.custom.rawValue) as? RickyMortyTableViewCell else {
            return UITableViewCell()
            
        }
        cell.saveModel(model: filteredDatas[indexPath.row])
        return cell
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (tableView.contentSize.height-100-scrollView.frame.size.height){
            viewModel.page = viewModel.page+1
            viewModel.pagination = true
            viewModel.fetchItems(newPage: viewModel.page)
            viewModel.pagination = false
        }
        
    }
    
    
    
}

extension ViewController: RMOutput{
    func saveDatas(datas: [GetCharacterQuery.Data.Character.Result?]) {
        if(viewModel.filterName != ""){
            filteredDatas = datas
        }else{
            filteredDatas.append(contentsOf: datas)
        }
        
        
        tableView.reloadData()
    }
    
    
}
