//
//  DetailVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    //MARK: - Objects
    var detailImage: UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
        return image
    }()
    var detailMainDescription: UILabel = {
        let label = UILabel()
        label.text = "Main Description"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .center
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
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .brown
        return textView
    }()
    //MARK: - Setup
    private func setupDetailVC() {
        setDetailImageConstraints()
        setHeartConstraints()
        setMainLabelConstraints()
        setTextViewConstraints()
    }
    //MARK: - Constraints
    private func setDetailImageConstraints() {
        view.addSubview(detailImage)
        detailImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            detailImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            detailImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            detailImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor, constant: -10)])
    }
    private func setMainLabelConstraints() {
        view.addSubview(detailMainDescription)
        detailMainDescription.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailMainDescription.trailingAnchor.constraint(equalTo: heartButton.leadingAnchor),
            detailMainDescription.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor),
            detailMainDescription.centerXAnchor.constraint(equalTo: detailImage.centerXAnchor)])
    }
    private func setHeartConstraints() {
        view.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.trailingAnchor.constraint(equalTo: detailImage.trailingAnchor, constant: -20),
            heartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)])
    }
    private func setTextViewConstraints() {
        view.addSubview(detailTextView)
        detailTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailTextView.topAnchor.constraint(equalTo: heartButton.bottomAnchor, constant: 20),
            detailTextView.leadingAnchor.constraint(equalTo: detailImage.leadingAnchor,constant: 10),
            detailTextView.trailingAnchor.constraint(equalTo: detailImage.trailingAnchor,constant: -10),
            detailTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)])
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        setupDetailVC()
        
    }
    

    

}
