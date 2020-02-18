//
//  SettingVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/5/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    var apiType = "" {
        didSet {
            if apiType == Experience.ticketmaster.rawValue {
                settingPicker.selectRow(0, inComponent: 0, animated: true)
            } else if apiType == Experience.rijksmuseum.rawValue {
                settingPicker.selectRow(1, inComponent: 0, animated: true)
            }
        }
    }
    
    let pickerData = [Experience.ticketmaster.rawValue,Experience.rijksmuseum.rawValue]
    

    
    @IBOutlet weak var settingPicker: UIPickerView!
    
    @IBAction func settingButtonPressed(_ sender: UIButton) {
        let newExperience = pickerData[settingPicker.selectedRow(inComponent: 0)]
        
        FirestoreService.manager.updateAppUser(id: FirebaseAuthService.manager.currentUser?.uid ?? "", newExperience: newExperience) { (result) in
            switch result {
            case .failure:
                self.makeAlert(with: "Problem saving settings", and: "Try again later")
            case .success:
                self.makeAlert(with: "Successfully saved", and: "Yay")
            }
        }
    }
    
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    private func getUserApiType() {
        DispatchQueue.global(qos: .default).async {
            guard let currentUser = FirebaseAuthService.manager.currentUser else {
                return
            }
            FirestoreService.manager.getUserApiType(from: currentUser.uid) { (result) in
                switch result {
                case .success(let currentApiType):
                    self.apiType = currentApiType
                case .failure(let error):
                    self.makeAlert(with: "Error could not load list", and: "\(error)")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingPicker.delegate = self
        settingPicker.dataSource = self
        getUserApiType()

    }

}

extension SettingVC: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
}
