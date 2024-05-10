//
//  SignInViewController.swift
//  TwitterApp
//
//  Created by 김연지 on 5/8/24.
//

import UIKit
import Alamofire

class SignInViewController: UIViewController {
    @IBOutlet weak var txtUserID: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func actSignIn(_ sender: Any){
        guard let userID = txtUserID.text,
              let password = txtPassword.text
        else { return }
        
        let str = "http://localhost:3000/member/sign-in"
        let params:Parameters = ["userID":userID, "password":password]
        AF.request(str, method: .post, parameters: params).responseDecodable(of:SignIn.self) { response in
            switch response.result {
                case .success(let result):
                    if result.success {
                        print("제발...")
                        UserDefaults.standard.setValue(result.token, forKey: "token")
                        UserDefaults.standard.setValue(result.member.userID, forKey: "uid")
                        self.tabBarController?.selectedIndex = 0
                    } else {
                        self.showAlertWithSingleAction(title: "로그인", message: result.message)
                    }
                
            case .failure(let error):
                self.showAlertWithSingleAction(title: "로그인", message: error.localizedDescription)
            
            }
        }
        
    }
}
