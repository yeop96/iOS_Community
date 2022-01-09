//
//  CommunityListViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class CommunityListViewController: UIViewController{
    
    let serverService = ServerService()
    var posts = [Post]()
    let tableView = UITableView()
    let dismissNotification: Notification.Name = Notification.Name("dismissNotification")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPost()
        tableView.register(TableViewContentCell.self, forCellReuseIdentifier: "TableViewContentCell")
        
        view.backgroundColor = .white
        title = "커뮤니팅"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leadingMargin.trailingMargin.equalToSuperview().inset(20)
        }
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(settingButtonClicked))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(postButtonClicked))
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissNotification(_:)), name: dismissNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func dismissNotification(_ noti: Notification) {
        getPost()
    }
    
    @objc func settingButtonClicked(){
        let alert = UIAlertController(title: "설정", message: nil, preferredStyle: .actionSheet)
        
        let changePassword = UIAlertAction(title: "비밀번호 변경", style: .default) { (action) in
            let vc = PasswordViewController()
            let navigation = UINavigationController(rootViewController: vc)
            navigation.modalPresentationStyle = .fullScreen
            self.present(navigation, animated: true, completion: nil)
        }
        let logout = UIAlertAction(title: "로그아웃", style: .default){ (action) in
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                let nav = UINavigationController(rootViewController: WelcomeViewController())
                windowScene.windows.first?.rootViewController = nav
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
        let noAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(changePassword)
        alert.addAction(logout)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    @objc func postButtonClicked(){
        let navigation = UINavigationController(rootViewController: PostViewController())
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    func getPost(){
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        serverService.requestGetPost(jwt: jwt) { postData in
            guard let postData = postData else { return }
            self.posts = postData
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}

extension CommunityListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewContentCell") as? TableViewContentCell else { return UITableViewCell() }
        let post = posts[indexPath.row]
        cell.selectionStyle = .none
        cell.nicknameLabel.text = post.user.username
        cell.contentLabel.text = post.text
        cell.dateLabel.text = post.created_at
        cell.commentLabel.text = post.comments.count == 0 ? "댓글쓰기" : "댓글 \(post.comments.count)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ContentViewController()
        vc.postContent = posts[indexPath.row]
        //print(posts[indexPath.row].comments)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class TableViewContentCell: UITableViewCell{
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let nicknameLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let separatorView = UIView()
    let separatorContentView = UIView()
    
    let commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let iconImageView = UIImageView()
    let commentLabel = UILabel()
    
    func configureUI() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        stackView.addArrangedSubview(nicknameLabel)
        stackView.addArrangedSubview(contentLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(separatorView)
        commentStackView.addArrangedSubview(iconImageView)
        commentStackView.addArrangedSubview(commentLabel)
        stackView.addArrangedSubview(commentStackView)
        stackView.addArrangedSubview(separatorContentView)
       
        nicknameLabel.font = .systemFont(ofSize: 15, weight: .regular)
        nicknameLabel.textColor = .lightGray
        nicknameLabel.textAlignment = .left
        

        contentLabel.numberOfLines = 3
        contentLabel.textAlignment = .left
        
        dateLabel.textAlignment = .left
        dateLabel.textColor = .lightGray
        
        separatorView.backgroundColor = .placeholderText
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        iconImageView.image = UIImage(systemName: "bubble.right")!
        iconImageView.tintColor = .lightGray
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        commentLabel.textColor = .darkGray
        commentLabel.textAlignment = .left
        
        separatorContentView.backgroundColor = .placeholderText
        separatorContentView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
