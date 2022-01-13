//
//  SignUpViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit
import NotificationBannerSwift

class SignUpViewController: UIViewController, UIGestureRecognizerDelegate{
    
    let serverService = ServerService()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    let logoImageView = UIImageView()
    let emailTextField = UITextField()
    let nickNameTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()
    let signUpButton = UIButton()
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        [emailTextField, nickNameTextField, passwordTextField, passwordConfirmTextField,].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(signUpButton)
        title = "회원가입"
        setUp()
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setUp(){
        view.backgroundColor = .systemBackground
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
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
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        emailTextField.placeholder = "이메일 주소"
        emailTextField.borderStyle = .roundedRect
        
        nickNameTextField.placeholder = "닉네임"
        nickNameTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        passwordConfirmTextField.placeholder = "비밀번호 확인"
        passwordConfirmTextField.borderStyle = .roundedRect
        passwordConfirmTextField.isSecureTextEntry = true
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.systemBackground, for: .normal)
        signUpButton.backgroundColor = .label
        signUpButton.layer.cornerRadius = 10
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpButtonClicked(){
        
        let username = nickNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if passwordTextField.text != passwordConfirmTextField.text{
            let banner = NotificationBanner(subtitle: "비밀번호 확인이 다릅니다.", style: .success)
            banner.titleLabel?.textColor = .label
            banner.duration = 1
            banner.show()
            return
        }
        
        serverService.requestSignUp(username: username, email: email, password: password) { authData in
            
            guard let authData = authData else { return }
            
            UserDefaults.standard.set(authData.jwt, forKey: "jwt")
            UserDefaults.standard.set(authData.user.id, forKey: "id")
            UserDefaults.standard.set(authData.user.username, forKey: "username")
            UserDefaults.standard.set(authData.user.email, forKey: "email")
            UserDefaults.standard.set(password, forKey: "password")
            
            
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let nav = UINavigationController(rootViewController: CommunityListViewController())
                windowScene.windows.first?.rootViewController = nav
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }

        
    }
    
    
    
}
