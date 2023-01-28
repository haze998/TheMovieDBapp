//
//  AuthorizationViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import UIKit

class AuthorizationViewController: UIViewController  {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
            loginTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
            passwordTextField.delegate = self
        }
    }

    let viewModel = AuthorizationViewModel()
    var username = ""
    var password = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        viewModel.userInfo(userName: loginTextField.text ?? "", pass: passwordTextField.text ?? "") {
            if self.viewModel.isLogin {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "GenresViewController") as? GenresViewController else { return }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    func setupUI() {
        //background gradient
        let colorTop =  UIColor(red: 0.5, green: 0, blue: 1, alpha: 1).cgColor
        let colorBot = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bgView.bounds
        gradientLayer.colors = [colorTop, colorBot]
        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
        
        // button gradient
        let gradientButton = CAGradientLayer()
        gradientButton.colors = [
            UIColor(red: 0.5, green: 0, blue: 1, alpha: 1).cgColor,
            UIColor(red: 0.329, green: 0.043, blue: 0.631, alpha: 1).cgColor
        ]
        gradientButton.frame = loginButton.bounds
        loginButton.layer.insertSublayer(gradientButton, at: 0)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = UIFont(name: "CodecPro-News", size: 20.0)
        
        // text fields
        loginTextField.borderStyle = .roundedRect
        loginTextField.layer.cornerRadius = 20
        loginTextField.clipsToBounds = true
        loginTextField.setGradient(startColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0), endColor: UIColor(red: 0.5, green: 0, blue: 1, alpha: 1))
        loginTextField.layer.borderColor = UIColor(red: 0.5, green: 0, blue: 1, alpha: 1).cgColor
        loginTextField.layer.borderWidth = 1.0
        loginTextField.attributedPlaceholder = NSAttributedString(
            string: "Login",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        passwordTextField.setGradient(startColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0), endColor: UIColor(red: 0.5, green: 0, blue: 1, alpha: 1))
        passwordTextField.layer.borderColor = UIColor(red: 0.5, green: 0, blue: 1, alpha: 1).cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
        
    }
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
                self.password = pass
            }
        default:
            break
        }
    }
}

extension UITextField {
    func setGradient(startColor:UIColor,endColor:UIColor) {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
}

