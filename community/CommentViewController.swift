//
//  CommentViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class CommentViewController: UIViewController{
    let serverService = ServerService()
    var postContent: Post?
    var editBool = false
    var editComment: DetailComment?
    let borderView = UIView()
    let commentTextView = UITextView()
    let commentNotification: Notification.Name = Notification.Name("commentNotification")


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
        borderView.addSubview(commentTextView)
        borderView.layer.borderWidth = 1
        borderView.layer.borderColor = UIColor.placeholderText.cgColor
        borderView.layer.cornerRadius = 10
        borderView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leadingMargin.trailingMargin.equalToSuperview().inset(10)
            make.height.equalToSuperview().multipliedBy(0.5)
        }
        commentTextView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(20)
        }
    }
    
    @objc func saveButtonClicked(){
        guard let postContent = postContent else { return }
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        
        serverService.requestPostComment(jwt: jwt, comment: commentTextView.text, post: String(postContent.id)) { data in
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: self.commentNotification, object: nil, userInfo: nil)
                self.dismiss(animated: true)
            }
        }
    }
    
    
    @objc func dismissAction(){
        dismiss(animated: true)
    }
}
