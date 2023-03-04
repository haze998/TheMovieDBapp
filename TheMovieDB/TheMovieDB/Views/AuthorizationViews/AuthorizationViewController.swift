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
                    alertLabel.text = "Username / password cannot be empty"
                    return
                } else {
                    if result != true {
                        alertLabel.isHidden = false
                        
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
        loginTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
        passwordTextField.layer.borderColor = UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
    }
    
    func setupUI() {
//        // Superview background color
//        let colorTop = UIColor(red: 0.33, green: 0.04, blue: 0.63, alpha: 1.00).cgColor
//        let colorBot = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.00).cgColor
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = self.bgView.bounds
//        gradientLayer.colors = [colorTop, colorBot]
//        self.bgView.layer.insertSublayer(gradientLayer, at: 0)
        let bgColor = UIColor(red: 0.05, green: 0.04, blue: 0.10, alpha: 1.00)
        self.view.backgroundColor = bgColor
        
        // button gradient
        let gradientButton = CAGradientLayer()
        gradientButton.colors = [
            UIColor(red: 0.247, green: 0.216, blue: 0.498, alpha: 1).cgColor,
            UIColor(red: 0.263, green: 0.659, blue: 0.831, alpha: 1).cgColor
          ]
        gradientButton.locations = [0, 1]
        gradientButton.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradientButton.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradientButton.transform = CATransform3DMakeAffineTransform(CGAffineTransform(a: -1.14, b: 1.43, c: -1.43, d: -87.17, tx: 1.85, ty: 43.16))
        gradientButton.bounds = view.bounds.insetBy(dx: -0.5*view.bounds.size.width, dy: -0.5*view.bounds.size.height)
        gradientButton.position = view.center
        loginButton.layer.insertSublayer(gradientButton, at: 0)
        loginButton.layer.cornerRadius = 20
        loginButton.layer.masksToBounds = true
        loginButton.titleLabel?.font = UIFont(name: "CodecPro-News", size: 20.0)
        
        // text fields
        loginTextField.tintColor = .white
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
        loginTextField.font = UIFont.systemFont(ofSize: 16)
        
        passwordTextField.tintColor = .white
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
        passwordTextField.font = UIFont.systemFont(ofSize: 16)
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

