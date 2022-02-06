//
//  RMTableViewCell.swift
//  RMGraphQL
//
//  Created by Yalçın Golayoğlu on 5.02.2022.
//

import UIKit
import SnapKit
import AlamofireImage

class RickyMortyTableViewCell: UITableViewCell {
    private let customImage: UIImageView = {
       let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private let bottomLayer: UIView = UIView()
    private let id: UILabel = UILabel()
    private let name: UILabel = UILabel()
    private let location: UILabel = UILabel()
    private let randomImage: String = "https://picsum.photos/200/300"
    
    enum Identifier: String {
        case custom = "rm"
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(customImage)
        addSubview(bottomLayer)
        bottomLayer.addSubview(name)
        bottomLayer.addSubview(location)
        bottomLayer.addSubview(id)
        
        name.font = .boldSystemFont(ofSize: 16)
        location.font = .boldSystemFont(ofSize: 16)
        bottomLayer.backgroundColor = .white
        bottomLayer.layer.shadowColor = UIColor.black.cgColor.copy(alpha: 0.1)
        bottomLayer.layer.shadowOpacity = 6
        bottomLayer.layer.shadowOffset = CGSize(width: 0, height: 6)
        bottomLayer.layer.shadowRadius = 8
        customImage.layer.cornerRadius = 10
        customImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        bottomLayer.layer.cornerRadius = 10
        bottomLayer.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        constraintsComponents()
        
    }
    func constraintsComponents(){
        customImage.snp.makeConstraints { (make) in
            make.height.equalTo(self).multipliedBy(0.65)
            make.top.equalTo(contentView)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)

        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(customImage.snp.bottom).offset(35)
            make.left.equalTo(customImage.snp.left).offset(14)
        }
        
        id.snp.makeConstraints { make in
            make.top.equalTo(customImage.snp.bottom).offset(8)
            make.right.equalTo(-17)
            make.height.equalTo(20)
        }

        location.snp.makeConstraints { (make) in
            make.top.equalTo(name).offset(8)
            make.right.left.equalTo(name)
            make.bottom.equalToSuperview()
        }
        
        bottomLayer.snp.makeConstraints { make in
            make.top.equalTo(customImage.snp.bottom)
            make.height.equalTo(self).multipliedBy(0.30)
            make.left.equalTo(contentView).offset(24)
            make.right.equalTo(contentView).offset(-24)
        }
    }
    
    
    func saveModel(model: GetCharacterQuery.Data.Character.Result?) {
        name.text = "Name: \(model?.name ?? "noname")"
        id.text = "#id: \(model?.id ?? "no id")"
        location.text = "Location: \(model?.location?.name ?? "no location")"
        customImage.af.setImage(withURL: URL(string: model?.image ?? randomImage) ?? URL(string: randomImage)!)
    }
    
}
