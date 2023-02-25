//
//  AuthorizationViewController.swift
//  TheMovieDB
//
//  Created by Evgeniy Docenko on 22.01.2023.
//

import UIKit

// MARK: - AuthorizationViewController
class AuthorizationViewController: UIViewController  {
    
    @IBOutlet var bgView: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTextField: UITextField! {
        didSet {
           // loginTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField! {
        didSet {
           // passwordTextField.delegate = self
        }
    }
    @IBOutlet weak var alertLabel: UILabel!
    
    let viewModel = AuthorizationViewModel()
//    private var username: String? {
//        return loginTextField.text
//    }
//
//    private var password: String? {
//        return passwordTextField.text
//    }
//    private var username: String?
//    private var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = loginTextField.text, let password = passwordTextField.text else { return }
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { [self] _ in
            viewModel.userAuthentication(username: username, password: password) { [self] result in
                if username.isEmpty || password.isEmpty {
                    alertLabel.isHidden = false
                    loginTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
                    passwordTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
                    self.shakeButton()
                    alertLabel.text = "Username / password cannot be blank"
                    return
                } else {
                    if result != true {
                        alertLabel.isHidden = false
                        loginTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
                        passwordTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
                        self.shakeButton()
                        alertLabel.text = "Incorrect username / password"
                    } else {
                        if let sessionID = StorageSecure.keychain["sessionID"] {
                            viewModel.getAccountID(sessionID)
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerId")
                            self.view.window?.rootViewController = vc
                            self.view.window?.makeKeyAndVisible()
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func guestButtonPressed(_ sender: UIButton) {
        viewModel.getGuestSessionID()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerId")
        self.view.window?.rootViewController = vc
        self.view.window?.makeKeyAndVisible()
//                let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                let vc = storyboard.instantiateViewController(withIdentifier: "NavControllerId")
//                vc.modalPresentationStyle = .fullScreen
//                vc.modalTransitionStyle = .flipHorizontal
//                self.present(vc, animated: true)
    }
    
    private func shakeButton() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: loginButton.center.x - 10, y: loginButton.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: loginButton.center.x + 10, y: loginButton.center.y))

        loginButton.layer.add(animation, forKey: "position")
    }
    
    func setupUI() {
        //background gradient
        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
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
        loginTextField.backgroundColor = .clear
        loginTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        loginTextField.layer.borderWidth = 1.0
        loginTextField.attributedPlaceholder = NSAttributedString(
            string: "Login",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.layer.cornerRadius = 20
        passwordTextField.clipsToBounds = true
        passwordTextField.backgroundColor = .clear
        passwordTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
        passwordTextField.layer.borderWidth = 1.0
        passwordTextField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        passwordTextField.isSecureTextEntry = true
        
        
        alertLabel.isHidden = true
    }
}

extension AuthorizationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTextField.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
//        switch textField.tag {
//        case 0 :
//            if let username = textField.text {
//                self.username = username
//            }
//        case 1:
//            if let pass = textField.text {
//                self.password = pass
//            }
//        default:
//            break
//        }
    }
   
}

//extension UITextField {
//    func setGradient(startColor:UIColor,endColor:UIColor) {
//        let gradient:CAGradientLayer = CAGradientLayer()
//        gradient.colors = [startColor.cgColor, endColor.cgColor]
//        gradient.locations = [0.0 , 1.0]
//        gradient.startPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
//        gradient.frame = self.bounds
//        self.layer.addSublayer(gradient)
//    }
//}

