//
//  RegistrationController.swift
//  Simple_vk
//
//  Created by Sergei Dorozhkin on 21.01.2021.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {


    //MARK: Properties

    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.layer.masksToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.imageView?.clipsToBounds = true
        button.addTarget(self, action: #selector(addPhoto), for: .touchUpInside)
        return button
    }()
    private var profileImage: UIImage?
    private let imagePicker = UIImagePickerController()

    private let haveAccount: UIButton = {
        let button = Utilities().attributedButton(first: "Already have an account? ", second: "Sign In")
        button.addTarget(self, action: #selector(haveAccountButton), for: .touchUpInside)
        return button
    }()
    private lazy var mailContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_mail_outline_white_2x-1"),
                textField: mailTextField)
        return view
    }()
    private var mailTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Email")
        return tf
    }()
    private lazy var passContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_lock_outline_white_2x"),
                textField: passTextField)
        return view
    }()
    private var passTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let signUpButton: UIButton = {
        let button = Utilities().loginButton(text: "Sign Up")
        button.addTarget(self, action: #selector(actionButtonSignUp), for: .touchUpInside)
        return button
    }()
    private lazy var fullNameContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_person_outline_white_2x"),
                textField: fnTextField)
        return view
    }()
    private var fnTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Full Name")
        return tf
    }()
    private lazy var userContainerView: UIView = {
        let view = Utilities().inputContainerView(image: UIImage(named: "ic_person_outline_white_2x"),
                textField: userTextField)
        return view
    }()
    private var userTextField: UITextField = {
        let tf = Utilities().textField(placeholder: "Username")
        return tf
    }()
    private var service = FireService()

    //MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        service.delegate = self
    
    }

    //MARK: Helpers
    func configureUI() {
        view.backgroundColor = .black
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 150, height: 150)
        plusPhotoButton.layer.cornerRadius = 150/2

        view.addSubview(haveAccount)
        haveAccount.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                right: view.rightAnchor, paddingLeft: 40, paddingBottom: 0, paddingRight: 40)

        let stack = UIStackView(arrangedSubviews: [mailContainerView, passContainerView, fullNameContainerView, userContainerView, signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor,
                right: view.rightAnchor, paddingTop: 20, paddingLeft: 16, paddingRight: 16)

        let gesture = UITapGestureRecognizer()
        gesture.addTarget(self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gesture)

        imagePicker.delegate = self
        imagePicker.allowsEditing = true

    }

    //MARK: Selectors

    @objc func haveAccountButton() {
        navigationController?.popViewController(animated: true)
    }

    @objc func actionButtonSignUp() {
        
        guard let email = mailTextField.text else {
            return
        }
        guard let pwd = passTextField.text else {
            return
        }
        guard let full = fnTextField.text else {
            return
        }
        guard let user = userTextField.text?.lowercased() else {
            return
        }
        guard let profileImage = profileImage else {
           let alert = Utilities().alert("You should choose image first!")
            present(alert, animated: true, completion: nil)
            return
        }
        let credentials = AuthCredentials(email: email, password: pwd, fullname: full,
                                          username: user, profileImage: profileImage)
        service.registerUser(credentials: credentials) { [weak self](error, ref) in
            if let error = error {
                print(error.localizedDescription)
            }
            self?.dismiss(animated: true)
        }
    }
    
    @objc func addPhoto() {
        show(imagePicker, sender: self)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let profileImage = info[.editedImage] as? UIImage else { return }
        self.profileImage = profileImage
        plusPhotoButton.setImage(profileImage.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        dismiss(animated: true)
    }
}
extension RegistrationController:AlertMassagePopUp {
    func alertMessage(_ massage: String) {
        let alert =  Utilities().alert(massage)
        present(alert, animated: true, completion: nil)
    }
}
