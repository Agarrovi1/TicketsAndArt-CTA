//
//  SignInVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignInVC: UIViewController {
    
    //MARK: - Properties
    var pickerTitles = ["Ticketmaster","Rijksmuseum"]
    
    //MARK: - Objects
    
     var createLabel: UILabel = {
         let label = UILabel()
         label.numberOfLines = 0
         label.text = "Create An Account"
         label.font = UIFont(name: "Verdana-Bold", size: 30)
         label.textColor = UIColor.black
         label.backgroundColor = .clear
         label.textAlignment = .center
         return label
     }()
    var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Email"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.addTarget(self, action: #selector(enterOnEmailTextField), for: .primaryActionTriggered)
        return textField
    }()
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Password"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.autocorrectionType = .no
        textField.isSecureTextEntry = true
        textField.addTarget(self, action: #selector(submitButtonPressed), for: .primaryActionTriggered)
        return textField
    }()
    var selectLabel: UILabel = {
        let label = UILabel()
        label.text = "Select an API to use for this account"
        return label
    }()
    var apiPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .white
        return picker
    }()
    var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Contraints
    private func setCreateLabelContraints() {
        view.addSubview(createLabel)
        createLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            createLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            createLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)])
    }
    private func setEmailTextFieldConstraints() {
        view.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: createLabel.centerXAnchor),
            emailTextField.topAnchor.constraint(equalTo: createLabel.bottomAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: createLabel.leadingAnchor, constant: 15),
            emailTextField.trailingAnchor.constraint(equalTo: createLabel.trailingAnchor, constant: -15)])
    }
    private func setPasswordTextFieldContraints() {
        view.addSubview(passwordTextField)
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor,constant: 25),
            passwordTextField.leadingAnchor.constraint(equalTo: emailTextField.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: emailTextField.trailingAnchor)])
    }
    private func setSelectLabelConstraints() {
        view.addSubview(selectLabel)
        selectLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 100),
            selectLabel.centerXAnchor.constraint(equalTo: passwordTextField.centerXAnchor)])
    }
    private func setPickerContraints() {
        view.addSubview(apiPicker)
        apiPicker.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            apiPicker.topAnchor.constraint(equalTo: selectLabel.bottomAnchor, constant: 20),
            apiPicker.centerXAnchor.constraint(equalTo: selectLabel.centerXAnchor)])
    }
    private func setButtonConstraints() {
        view.addSubview(submitButton)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: apiPicker.bottomAnchor, constant: 30),
            submitButton.centerXAnchor.constraint(equalTo: apiPicker.centerXAnchor)])
    }
     
    //MARK: - Setup
    private func setupSignInUI() {
        setCreateLabelContraints()
        setEmailTextFieldConstraints()
        setPasswordTextFieldContraints()
        setSelectLabelConstraints()
        setPickerContraints()
        setButtonConstraints()
    }
    private func setDelegates() {
        apiPicker.delegate = self
        apiPicker.dataSource = self
    }
    
    //MARK: - Functions
    @objc func enterOnEmailTextField() {
        emailTextField.resignFirstResponder()
        passwordTextField.becomeFirstResponder()
    }
    @objc func submitButtonPressed() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            makeAlert(with: "Required", and: "Fill both fields")
            return
        }
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { (result) in
            self.handleCreatedUser(result: result)
        }
    }
    
    private func makeAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Handling
    private func handleCreatedUser(result: (Result<User,Error>)) {
        let chosenApi = pickerTitles[apiPicker.selectedRow(inComponent: 0)]
        DispatchQueue.main.async { [weak self] in
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser.init(from: user, apiType: chosenApi)) { [weak self] appUserResponse in
                    self?.handleCreatedAppUserResponse(result: appUserResponse)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func handleCreatedAppUserResponse(result: (Result<(),Error>)) {
        switch result {
        case .success:
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                else {return}
            UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                    window.rootViewController = ItemsTabBarController()
            }, completion: nil)
        case .failure(let error):
            makeAlert(with: "Error", and: "\(error)")
        }
    }

    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupSignInUI()
        setDelegates()

    }
    

}

//MARK: - Extensions



//MARK: Picker Delegates
extension SignInVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTitles.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTitles[row]
    }
    
    
}
