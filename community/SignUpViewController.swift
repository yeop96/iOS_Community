//
//  SignUpViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class SignUpViewController: UIViewController{
    
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
        
        
        //전송할 값
        let username = nickNameTextField.text!
        let email = emailTextField.text!
        let password = passwordTextField.text!
        let param = "username=\(username)&email=\(email)&password=\(password)"
        let paramData = param.data(using: .utf8)
            
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/auth/local/register")
            
        //URLRequest 객체 정의
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = paramData
            
        //request.addValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        //request.setValue(String(paramData!.count), forHTTPHeaderField: "Content-Length")
            
            
        //(응답 메시지(Data), 응답 정보(URLResponse), 오류 정보(Error))
              
        let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
            //서버가 응답이 없거나 통신이 실패
            if let e = error{
                print("e : \(e.localizedDescription)")
                return
            }
           
        //응답 처리 로직
        DispatchQueue.main.async {
                
            do{
                let object = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary
                
                guard let jsonObject = object else { return }
                guard let result = jsonObject["user"] else { return }
                
                print(result)
                
                let navigation = UINavigationController(rootViewController: CommunityListViewController())
                navigation.modalPresentationStyle = .fullScreen
                self.present(navigation, animated: true, completion: nil)
                
                
            }catch let e as NSError{
                print("An error has occured while parsing JSONObject: \(e.localizedDescription)")
            }

        }
     
     }//task - end
            
     //post 전송
     task.resume()
        

        
    }
    
    
    
}
