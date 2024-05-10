//
//  SignUpViewController.swift
//  TwitterApp
//
//  Created by 김연지 on 5/8/24.
//

import UIKit
import Alamofire
import PhotosUI

class SignUpViewController: UIViewController {

    var camera: UIImagePickerController?
    var picker: PHPickerViewController?
    
    @IBOutlet weak var txtUserPass: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtUserId: UITextField!
    @IBOutlet weak var imgProfile: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        camera = UIImagePickerController()
                
                camera?.sourceType = .camera
                camera?.delegate = self
                
                var config = PHPickerConfiguration()
                config.selectionLimit = 1
                config.filter = .images
                
                picker = PHPickerViewController(configuration: config)
                picker?.delegate = self
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
    @IBAction func actPhoto(_ sender: Any) {
        let sheet = UIAlertController(title: "리소스 선택", message: "이미지 출처를 선택하세요.", preferredStyle: .actionSheet)
                let actionCancel = UIAlertAction(title: "취소", style: .cancel)
                let actionAlbum = UIAlertAction(title: "Album", style: .default) { _ in
                    self.present(self.picker!, animated: true)
                }
                let actionCamera = UIAlertAction(title: "Camera", style: .default) { _ in
                    self.present(self.camera!, animated: true)
                }
                sheet.addAction(actionCancel)
                sheet.addAction(actionAlbum)
                sheet.addAction(actionCamera)
                present(sheet, animated: true)
    }
    
    @IBAction func actSignUp(_ sender: Any) {
        guard let userID = txtUserId.text, 
            let userName = txtUserName.text,
            let password = txtUserPass.text,
            let profile = imgProfile.image
        else { return }
        let str = "http://localhost:3000/member/sign-up"
        let header:HTTPHeaders = ["Content-Type":"multipart/form-data"]
        let params = ["userID":userID, "userName":userName, "password":password]
        AF.upload(multipartFormData: { multipartFormData in
//            for (key, value) in params {
//                multipartFormData.append("\(value)".data(using: .utf8)!, withName: key)
//            }
            multipartFormData.append(userID.data(using: .utf8)!, withName: "userID")
            multipartFormData.append(userName.data(using: .utf8)!, withName: "userName")
            multipartFormData.append(password.data(using: .utf8)!, withName: "password")
            multipartFormData.append(profile.pngData()!, withName: "image", fileName: "profile.png", mimeType: "image/png")
        }, to: str, headers: header).responseDecodable(of: SignUp.self){
            response in
            switch response.result {
            case .success(let result):
                if result.success {
                    self.showAlertWithSingleAction(title: "회원가입", message: result.message) { action in
                        self.dismiss(animated: true)
                    }
                } else {
                    self.showAlertWithSingleAction(title: "회원가입", message: result.message)
                }
                    
            case .failure(let error):
                self.showAlertWithSingleAction(title: "회원가입", message: error.localizedDescription)
            }
        }

    }
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imgProfile.image = image
        dismiss(animated: true)
    }
    
}

extension SignUpViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }
        itemProvider.loadObject(ofClass: UIImage.self) { result, error in
            if let image = result as? UIImage {
                DispatchQueue.main.async {
                    self.imgProfile.image = image
                }
            }
        }
        picker.dismiss(animated: true)
    }
    
    
}
