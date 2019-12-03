//
//  ListCell.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class ListCell: UITableViewCell {
    
    enum HeartStatus {
        case filled
        case notFilled
    }
    var heartStatus: HeartStatus = .notFilled

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setImageConstraints()
        setMainDescriptionContraints()
        setHeartButtonContraints()
        setAdditionalLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Objects
    var listImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .blue
        var newFrame = image.frame.size
        newFrame.width = 110
        newFrame.height = 110
        image.frame.size = newFrame
        return image
    }()
    var mainDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Main Description"
        label.numberOfLines = 2
        return label
    }()
    var additionalInfo: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.text = "Additional Info"
        label.numberOfLines = 2
        return label
    }()
    var heartButton: UIButton = {
        let button = UIButton()
        
        let config = UIImage.SymbolConfiguration(pointSize: 40, weight: UIImage.SymbolWeight.medium)
        let heart = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(heart, for: .normal)
        //heart.fill
        
        var newFrame = button.frame.size
        newFrame.width = 70
        newFrame.height = 70
        button.frame.size = newFrame
        
        button.tintColor = .red
        return button
    }()
    
    //MARK: Constraints
    func setImageConstraints() {
        contentView.addSubview(listImage)
        listImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            listImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            listImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            listImage.widthAnchor.constraint(equalToConstant: listImage.frame.width),
            listImage.heightAnchor.constraint(equalToConstant: listImage.frame.height)
            ])
    }
    func setHeartButtonContraints() {
        contentView.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.leadingAnchor.constraint(equalTo: mainDescriptionLabel.trailingAnchor,constant: 15),
            heartButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)])
    }
    func setMainDescriptionContraints() {
        contentView.addSubview(mainDescriptionLabel)
        mainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainDescriptionLabel.topAnchor.constraint(equalTo: listImage.topAnchor),
            mainDescriptionLabel.leadingAnchor.constraint(equalTo: listImage.trailingAnchor, constant: 15),
            mainDescriptionLabel.widthAnchor.constraint(equalToConstant: 175),
            mainDescriptionLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    func setAdditionalLabelConstraints() {
        contentView.addSubview(additionalInfo)
        additionalInfo.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            additionalInfo.leadingAnchor.constraint(equalTo: mainDescriptionLabel.leadingAnchor),
            additionalInfo.topAnchor.constraint(equalTo: mainDescriptionLabel.bottomAnchor, constant: 20),
            additionalInfo.trailingAnchor.constraint(equalTo: mainDescriptionLabel.trailingAnchor),
            additionalInfo.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)])
    }
    
    
}
