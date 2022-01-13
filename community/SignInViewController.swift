//
//  SignInViewController.swift
//  community
//
//  Created by yeop on 2022/01/03.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController, UIGestureRecognizerDelegate{
    
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
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let signInButton = UIButton()
    let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
        title = "로그인"
        view.addSubview(logoImageView)
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(passwordTextField)
        view.addSubview(signInButton)
        
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
        
        idTextField.placeholder = "이메일"
        idTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        signInButton.setTitle("로그인", for: .normal)
        signInButton.setTitleColor(.systemBackground, for: .normal)
        signInButton.backgroundColor = .label
        signInButton.layer.cornerRadius = 10
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(50)
        }
        
    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signInButtonClicked(){
        
        let identifier = idTextField.text!
        let password = passwordTextField.text!
        
        serverService.requestSignIn(identifier: identifier, password: password) { authData in
            
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
