//
//  PostViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class PostViewController: UIViewController{
    let borderView = UIView()
    let postTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "포스팅"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissAction))
        
        setUp()
    }
    
    func setUp(){
        view.addSubview(borderView)
        borderView.addSubview(postTextView)
        
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.placeholderText.cgColor
        borderView.layer.cornerRadius = 10
        borderView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leadingMargin.equalToSuperview().inset(10)
            make.trailingMargin.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        postTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    @objc func saveButtonClicked(){
        dismiss(animated: true)
    }
    
    @objc func dismissAction(){
        dismiss(animated: true)
    }
}
