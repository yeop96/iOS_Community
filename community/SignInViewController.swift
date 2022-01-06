//
//  SignInViewController.swift
//  community
//
//  Created by yeop on 2022/01/03.
//

import UIKit
import SnapKit

class SignInViewController: UIViewController{
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let idTextField = UITextField()
    let passwordTextField = UITextField()
    let signInButton = UIButton()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "로그인"
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(passwordTextField)
        view.addSubview(signInButton)
        
        setUp()
    }
    
    func setUp(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(100)
        }
        idTextField.placeholder = "이메일"
        idTextField.borderStyle = .roundedRect
        
        passwordTextField.placeholder = "비밀번호"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        
        signInButton.setTitle("로그인", for: .normal)
        signInButton.backgroundColor = .black
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        signInButton.snp.makeConstraints { make in
            make.leadingMargin.equalTo(view)
            make.trailingMargin.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    @objc func backButtonClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signInButtonClicked(){
        
        //전송할 값
        let identifier = idTextField.text!
        let password = passwordTextField.text!
        let param = "identifier=\(identifier)&password=\(password)"
        let paramData = param.data(using: .utf8)
            
        //URL 객체 정의
        let url = URL(string: "http://test.monocoding.com:1231/auth/local")
            
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
