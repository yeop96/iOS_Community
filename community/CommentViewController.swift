//
//  CommentViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class CommentViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "포스팅"
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(saveButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
    }
    
    @objc func saveButtonClicked(){
        dismiss(animated: true)
    }
    
    @objc func backButtonClicked(){
        dismiss(animated: true)
    }
}
