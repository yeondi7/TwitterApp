//
//  UIViewControllerAlert.swift
//  TwitterApp
//
//  Created by 김연지 on 5/8/24.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlertWithSingleAction(title:String?, message: String?, handler:((_ action:UIAlertAction)->Void)?=nil){
        let alertController = UIAlertController(title:title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}
