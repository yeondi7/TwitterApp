//
//  PostsViewController.swift
//  TwitterApp
//
//  Created by 김연지 on 5/8/24.
//

import UIKit
import Alamofire

class PostsViewController: UIViewController {

    @IBOutlet weak var txtContent: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblUserID: UILabel!
    var posts:[Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        if let _ = UserDefaults.standard.string(forKey: "token"){
            getPosts()
        
        }
    }
    

    @IBAction func actSend(_ sender: Any) {
        guard let content = txtContent.text else { return }
        let str = "http://localhost:3000/posts"
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
        let params: Parameters = ["content":content]
        AF.request(str, method: .post, parameters: params, headers: header).responseDecodable(of:Posts.self) { response in
            switch response.result {
            case .success(let result):
                if result.success {
                    self.getPosts()
                } else {
                    self.showAlertWithSingleAction(title: "게시물", message: result.message)
                }
            case .failure(let error):
                self.showAlertWithSingleAction(title: "게시물", message: error.localizedDescription)
            }
        }
    }
        func getPosts(){
            let str = "http://localhost:3000/posts"
            guard let token = UserDefaults.standard.string(forKey: "token") else { return }
            let header:HTTPHeaders = ["Authorization": "Bearer \(token)"]
            AF.request(str, method: .get, headers: header).responseDecodable(of:Posts.self) {
                response in
                switch response.result {
                case .success(let result):
                    if result.success {
                        self.posts = result.documents
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        self.showAlertWithSingleAction(title: "게시물", message: result.message)
                    }
                case .failure(let error):
                    self.showAlertWithSingleAction(title: "게시물", message: error.localizedDescription)
                }
            }
        }
    }



extension PostsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath);
        guard let post = posts?[indexPath.row] else { return cell }
        
        let lblUserID = cell.viewWithTag(1) as? UILabel
        let lblContent = cell.viewWithTag(2) as? UILabel
        
        lblUserID?.text = post.userID
        lblContent?.text = post.content
    
        return cell
    }
}
