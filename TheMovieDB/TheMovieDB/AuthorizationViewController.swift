//
//  AuthorizationViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import UIKit

class AuthorizationViewController: UIViewController  {
    
//    var networkManager = AuthNetworkManager()
    let viewmodel = AuthorizationViewModel()
    var username = ""
    var pass = ""
    
    private lazy var usertextField: UITextField = {
        let usertextField = UITextField()
        usertextField.tag = 0
        return usertextField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usertextField.delegate = self
        
    }
    
    //add action
    //viewmodel.userInfo(userName: self.username, pass: self.pass)
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag {
        case 0 :
            if let username = textField.text {
                self.username = username
            }
        case 1:
            if let pass = textField.text {
                self.pass = pass
            }
        default:
            break
        }
       
        
        
        
    }
}
