//
//  PasswordViewController.swift
//  community
//
//  Created by yeop on 2022/01/09.
//

import UIKit
import SnapKit
import NotificationBannerSwift

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
    let logoImageView = UIImageView()
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
        title = "비밀번호 변경"
        
        view.addSubview(logoImageView)
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
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissButtonClicked))
        
        logoImageView.image = UIImage(named: "pinkCat.png")
        logoImageView.backgroundColor = .clear
        logoImageView.contentMode = .scaleToFill
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logoImageView.snp.bottom).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
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
        changeButton.setTitleColor(.systemBackground, for: .normal)
        changeButton.backgroundColor = .label
        changeButton.layer.cornerRadius = 10
        changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        changeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
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
        
        if newPasswordTextField.text != confirmNewPasswordTextField.text{
            let banner = NotificationBanner(subtitle: "비밀번호 확인이 다릅니다.", style: .success)
            banner.titleLabel?.textColor = .label
            banner.duration = 1
            banner.show()
            return
        }
        
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
