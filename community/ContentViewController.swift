//
//  DetailViewController.swift
//  community
//
//  Created by yeop on 2022/01/06.
//

import UIKit
import SnapKit

class ContentViewController: UIViewController{
    
    let serverService = ServerService()
    let tableView = UITableView()
    let commentButton = UIButton()
    var postContent: Post?
    var postComments: DetailComments = []
    let commentNotification: Notification.Name = Notification.Name("commentNotification")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComment()
        tableView.register(TableViewContentDetailCell.self, forCellReuseIdentifier: "TableViewContentDetailCell")
        tableView.register(TableViewCommentCell.self, forCellReuseIdentifier: "TableViewCommentCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(commentButton)
        view.addSubview(tableView)
        
        view.backgroundColor = .white
        
        commentButton.setTitle("댓글쓰기", for: .normal)
        commentButton.setTitleColor(.black, for: .normal)
        commentButton.backgroundColor = .clear
        commentButton.layer.cornerRadius = 10
        commentButton.addTarget(self, action: #selector(commentButtonClicked), for: .touchUpInside)
        commentButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leadingMargin.trailingMargin.equalToSuperview().inset(20)
        }
        
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalTo(commentButton.snp.top)
            make.leadingMargin.trailingMargin.equalToSuperview().inset(20)
        }
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(moreButtonClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.commentNotification(_:)), name: commentNotification, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @objc func commentNotification(_ noti: Notification) {
        getComment()
    }
    
    @objc func commentButtonClicked(){
        let vc = CommentViewController()
        vc.postContent = postContent
        let navigation = UINavigationController(rootViewController: vc)
        navigation.modalPresentationStyle = .fullScreen
        self.present(navigation, animated: true, completion: nil)
    }
    
    @objc func moreButtonClicked(){
        dismiss(animated: true)
    }
    
    @objc func backButtonClicked(){

        self.navigationController?.popViewController(animated: true)
    }
    
    func getComment(){
        guard let postContent = postContent else { return }
        guard let jwt = UserDefaults.standard.string(forKey: "jwt") else { return }
        serverService.requestGetComment(jwt: jwt, post: String(postContent.id)) { data in
            self.postComments = data ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
}

extension ContentViewController: UITableViewDelegate, UITableViewDataSource{

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : postComments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewContentDetailCell") as? TableViewContentDetailCell else { return UITableViewCell() }
            guard let post = postContent else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.nicknameLabel.text = post.user.username
            cell.dateLabel.text = post.created_at
            cell.contentLabel.text = post.text
            cell.commentLabel.text = post.comments.count == 0 ? "댓글" : "댓글 \(postComments.count)"
            return cell
        } else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCommentCell") as? TableViewCommentCell else { return UITableViewCell() }
            let comment = postComments[indexPath.row]
            cell.selectionStyle = .none
            cell.nickNameLabel.text = comment.user.username
            cell.commentLabel.text = comment.comment
            //cell.userButton.addTarget(self, action: #selector(commentUserButtonClicked), for: .touchUpInside)
            return cell
        }
        
    }
    
    
    
}

class TableViewContentDetailCell: UITableViewCell{
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let userDetailStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let userImageView = UIImageView()
    let nicknameLabel = UILabel()
    let dateLabel = UILabel()
    let contentLabel = UILabel()
    let separatorView = UIView()
    
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
        userDetailStackView.addArrangedSubview(nicknameLabel)
        userDetailStackView.addArrangedSubview(dateLabel)
        userStackView.addArrangedSubview(userImageView)
        userStackView.addArrangedSubview(userDetailStackView)
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(contentLabel)
        commentStackView.addArrangedSubview(iconImageView)
        commentStackView.addArrangedSubview(commentLabel)
        stackView.addArrangedSubview(commentStackView)
        stackView.addArrangedSubview(separatorView)
        
        userImageView.image = UIImage(systemName: "person.circle")!
        userImageView.tintColor = .lightGray
        userImageView.snp.makeConstraints { make in
            make.size.equalTo(36)
        }
        
        nicknameLabel.textColor = .black
        nicknameLabel.textAlignment = .left
        
        dateLabel.textAlignment = .left
        dateLabel.textColor = .lightGray
        
        separatorView.backgroundColor = .placeholderText
        separatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = .left
        
        
        iconImageView.image = UIImage(systemName: "bubble.right")!
        iconImageView.tintColor = .lightGray
        iconImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        commentLabel.textColor = .darkGray
        commentLabel.textAlignment = .left
        
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

class TableViewCommentCell: UITableViewCell{
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
        stackView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let userStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    let nickNameLabel = UILabel()
    let userButton = UIButton()
    let commentLabel = UILabel()
    
    func configureUI(){
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        userStackView.addArrangedSubview(nickNameLabel)
        userStackView.addArrangedSubview(userButton)
        stackView.addArrangedSubview(userStackView)
        stackView.addArrangedSubview(commentLabel)
        
        nickNameLabel.font = .boldSystemFont(ofSize: 15)
        nickNameLabel.textAlignment = .left
        
        userButton.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        
        commentLabel.numberOfLines = 0
        commentLabel.textAlignment = .left
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

