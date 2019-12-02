//
//  LoginVC.swift
//  CTA-Project
//
//  Created by Angela Garrovillas on 12/2/19.
//  Copyright © 2019 Angela Garrovillas. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: IBActions
    @IBAction func loginButtonPressed(_ sender: UIButton) {
    }
    @IBAction func createButtonPressed(_ sender: UIButton) {
        let signInVC = SignInVC()
        present(signInVC, animated: true, completion: nil)
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

}
