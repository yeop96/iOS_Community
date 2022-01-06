//
//  WelcomeViewController.swift
//  community
//
//  Created by yeop on 2022/01/03.
//

import UIKit
import SnapKit

class WelcomeViewController: UIViewController{
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let logoImageView = UIImageView()
    let startButton = UIButton()
    let signInButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [titleLabel, detailLabel, logoImageView, startButton, signInButton].forEach {
            view.addSubview($0)
        }
        setUp()
    }
    
    
    func setUp(){
        view.backgroundColor = .white
        
        titleLabel.text = "커뮤니티ing"
        titleLabel.font = .boldSystemFont(ofSize: 20)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        detailLabel.text = "커뮤니티와 함께 하자\n드가자"
        detailLabel.numberOfLines = 0
        detailLabel.textAlignment = .center
        detailLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        logoImageView.image = UIImage(named: "pinkCat.png")
        logoImageView.backgroundColor = .clear
        logoImageView.contentMode = .scaleToFill
        logoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.height.equalTo(150)
            make.width.equalTo(150)
        }
        
        startButton.setTitle("시작하기", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.backgroundColor = .black
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        startButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-200)
        }
        
        signInButton.setTitle("이미 계정이 있나요? 로그인", for: .normal)
        signInButton.setTitleColor(.placeholderText, for: .normal)
        signInButton.backgroundColor = .clear
        signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(view.snp.bottom).offset(-100)
        }
        
    }
    
    @objc func startButtonClicked(){
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func signInButtonClicked(){
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}
