//
//  LoginController.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 14/12/22.
//

import UIKit
import SwiftUI

class LoginController: UIViewController {
    // -MARK: Properties
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(imageLiteralResourceName: "TwitterLogo")
        
        return iv
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_mail_outline_white_2x-1")
        let view = Utils().inputContainerView(withImage: image, textField: emailTextField)
        
        return view
    }()
    
    private lazy var passContrainerView: UIView = {
        let image = UIImage(imageLiteralResourceName: "ic_lock_outline_white_2x")
        let view = Utils().inputContainerView(withImage: image, textField: passTextField)
        return view
    }()
    
    private let emailTextField: UITextField = {
        let tf = Utils().customTextField(withPlaceholder: "Email", color: .white)
        return tf
    }()
    
    private let passTextField: UITextField = {
        let tf = Utils().customTextField(withPlaceholder: "Password", color: .white)
        tf.isSecureTextEntry = true 
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.addTarget(self, action: #selector(handleLogIn), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utils().customButton("Don't have an account ?", " Sign Up")
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    
    // -MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // -MARK: Selector
    @objc func handleLogIn(){
        guard let email = emailTextField.text else { return }
        guard let password = passTextField.text else { return }
        
        AuthService.shared.logUserIn(withEmail: email, pasword: password) { result, error in
            if let error = error {
                print("DEBUG: Error Log In \(error.localizedDescription)")
                return
            }
            
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else { return }
            guard let tab = window.rootViewController as? MainTabController else { return }
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleSignUp(){
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // -MARK: Helpers
    func configureUI() {
        view.backgroundColor = UIColor.twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [emailContainerView, passContrainerView, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        
        
        view.addSubview(stackView)
        stackView.anchor(top: logoImageView.bottomAnchor, left:view.leftAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40, paddingRight: 40)
    }
}


struct LogIn_View: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        //leave this empty
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        LoginController()
    }
}

struct LogIn_Previews: PreviewProvider {
    static var previews: some View {
        LogIn_View()
    }
}
