//
//  LoginController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 21.01.2021.
//

import UIKit

class LoginController: UIViewController {


    //MARK: Properties
    private let logoImageView: UIImageView = {
        let li = UIImageView()
        li.contentMode = .scaleAspectFill
        li.clipsToBounds = true
        li.image = UIImage(named: "549-5493483_hyper-deals-sign-hd-png-download")
        li.backgroundColor = .black
        return li
    }()
    private lazy var emailContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_mail_outline_white_2x-1"),
                textField: emailTextField)
        return view
    }()
    private var emailTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Email")
        return tf
    }()
    private lazy var pwdContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"),
                textField: pwdTextField)
        return view
    }()
    private var pwdTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let loginButton: UIButton = {
        let button = Utilities().loginButton(text: "Log In")
        button.addTarget(self, action: #selector(actionButtonLogin), for: .touchUpInside)
        return button
    }()
    private let noAccount: UIButton = {
        let button = Utilities().attributedButton(first: "Don't have an account? ", second: "Sign Up")
        button.addTarget(self, action: #selector(noAccountButton), for: .touchUpInside)
        return button
    }()


    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .black
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        view.addSubview(logoImageView)
        logoImageView.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        logoImageView.setDimensions(width: 150, height: 150)
        logoImageView.layer.cornerRadius = 30
        let stack = UIStackView(arrangedSubviews: [emailContainerView, pwdContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor,
                right: view.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        view.addSubview(noAccount)
        noAccount.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                right: view.rightAnchor, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)
        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)
    }

    @objc func actionButtonLogin() {
        guard let email = emailTextField.text else {
            return
        }
        guard let pwd = pwdTextField.text else {
            return
        }
        FireService.shared.logUserIn(email: email, pwd: pwd) { [weak self](result, error) in
            if let error = error {
                let alert =  Utilities().alert(error.localizedDescription)
                self?.present(alert, animated: true, completion: nil)
                return
            }
            print("DEBUG: Successful login")
            self?.dismiss(animated: true)
        }

    }

    @objc func noAccountButton() {
        let controller = RegistrationController()
        navigationController?.pushViewController(controller, animated: true)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

