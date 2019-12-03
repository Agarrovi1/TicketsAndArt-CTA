//
//  DetailVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    var ticketEvent: Event?
    
    
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
    var detailTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .brown
        return textView
    }()
    //MARK: - Setup
    private func setupDetailVC() {
        setDetailImageConstraints()
        setMainLabelConstraints()
        setHeartConstraints()
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
            detailMainDescription.centerXAnchor.constraint(equalTo: detailImage.centerXAnchor),
            detailMainDescription.widthAnchor.constraint(equalToConstant: 224)])
    }
    private func setHeartConstraints() {
        view.addSubview(heartButton)
        heartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heartButton.leadingAnchor.constraint(equalTo: detailMainDescription.trailingAnchor),
            heartButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            heartButton.widthAnchor.constraint(equalToConstant: heartButton.frame.width),
            heartButton.heightAnchor.constraint(equalToConstant: heartButton.frame.height),
        
            detailMainDescription.centerYAnchor.constraint(equalTo: heartButton.centerYAnchor)])
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
    
    //MARK: Functions
    private func loadTicketInfo() {
        if let event = ticketEvent {
            detailMainDescription.text = event.name
            detailTextView.text = "Start Date:\(event.getFormattedDate())\n\n\(event.url)"
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        setupDetailVC()
        loadTicketInfo()
        
    }
    

    

}
