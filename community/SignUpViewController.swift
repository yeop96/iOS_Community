//
//  SignUpViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController{
    
    let serverService = ServerService()
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    let emailTextField = UITextField()
    let nickNameTextField = UITextField()
    let passwordTextField = UITextField()
    let passwordConfirmTextField = UITextField()
    let signUpButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        [emailTextField, nickNameTextField, passwordTextField, passwordConfirmTextField,].forEach {
            stackView.addArrangedSubview($0)
        }
        view.addSubview(signUpButton)
        view.backgroundColor = .white
        title = "회원가입"
        setUp()
        
    }
    
    func setUp(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(400)
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
        signUpButton.backgroundColor = .black
        signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
        signUpButton.snp.makeConstraints { make in
            make.leadingMargin.equalTo(view)
            make.trailingMargin.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            //make.height.equalTo(view).multipliedBy(0.1)
        }
    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signUpButtonClicked(){
        
        let username = nickNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
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
