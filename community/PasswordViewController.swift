//
//  PasswordViewController.swift
//  community
//
//  Created by yeop on 2022/01/09.
//

import UIKit
import SnapKit

class PasswordViewController: UIViewController, UIGestureRecognizerDelegate{
    let serverService = ServerService()
    var userEmail = ""
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let idTextField = UITextField()
    let currentPasswordTextField = UITextField()
    let newPasswordTextField = UITextField()
    let confirmNewPasswordTextField = UITextField()
    let changeButton = UIButton()
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .white
        title = "비밀번호 변경"
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(currentPasswordTextField)
        stackView.addArrangedSubview(newPasswordTextField)
        stackView.addArrangedSubview(confirmNewPasswordTextField)
        view.addSubview(changeButton)
        
        setUp()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setUp(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(100)
        }
        guard let email = UserDefaults.standard.string(forKey: "email") else { return }
        idTextField.text = email
        idTextField.borderStyle = .roundedRect
        idTextField.isEnabled = false
        
        currentPasswordTextField.placeholder = "기존 비밀번호"
        currentPasswordTextField.borderStyle = .roundedRect
        currentPasswordTextField.isSecureTextEntry = true
        
        newPasswordTextField.placeholder = "새로운 비밀번호"
        newPasswordTextField.borderStyle = .roundedRect
        newPasswordTextField.isSecureTextEntry = true
        
        confirmNewPasswordTextField.placeholder = "새로운 비밀번호 확인"
        confirmNewPasswordTextField.borderStyle = .roundedRect
        confirmNewPasswordTextField.isSecureTextEntry = true
        
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.backgroundColor = .black
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        changeButton.snp.makeConstraints { make in
            make.leadingMargin.equalTo(view)
            make.trailingMargin.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc func dismissButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changeButtonClicked(){
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        let currentPassword = currentPasswordTextField.text!
        let newPassword = newPasswordTextField.text!
        let confirmNewPassword = confirmNewPasswordTextField.text!
        
        serverService.requestChangePassword(jwt: jwt, currentPassword: currentPassword, newPassword: newPassword, confirmNewPassword: confirmNewPassword) { data in
            UserDefaults.standard.set(newPassword, forKey: "password")
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let nav = UINavigationController(rootViewController: WelcomeViewController())
                windowScene.windows.first?.rootViewController = nav
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
        
    }
    
    
    
}
