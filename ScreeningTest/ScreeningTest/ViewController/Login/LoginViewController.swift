//
//  LoginViewController.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 23/05/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var textName : UITextField!
    @IBOutlet weak var textPalindome : UITextField!
    private var username = ""
//    private var isLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func onCheck(_sender:UIButton, forEvent event:UIEvent){
        if isPalindome() {
            self.showAlert(content: "Congrats, It's polindrome")
        } else {
            self.showAlert(content: "Sorry, It's not polindrome. Try again!")
        }
    }
    
    @IBAction func onNext(_sender:UIButton, forEvent event:UIEvent){
        let isPalindrome = isPalindome()
        if textName.text != "" && isPalindrome {
            UserDefaults.standard.setValue(textName.text!, forKey: "username")
            UserDefaults.standard.setValue(false, forKey: "isChoosen")
            DispatchQueue.main.async {
                let navigationController = UINavigationController(rootViewController: MainViewController())
                if #available(iOS 13.0, *) {
                    let scene = UIApplication.shared.connectedScenes.first
                    if let sd : SceneDelegate = (scene?.delegate as? SceneDelegate) {
                        sd.window?.rootViewController = navigationController
                        sd.window?.makeKeyAndVisible()
                    }
                } else {
                    let appdelegate = UIApplication.shared.delegate as! AppDelegate
                    appdelegate.window!.rootViewController = navigationController
                    appdelegate.window?.makeKeyAndVisible()
                    // Fallback on earlier versions\
                }
            }
        } else {
            self.showAlert(content: "Name is empty OR the word is not palindrome")
        }
    }
    
    func isPalindome() -> Bool {
        var result = false
        let strPalindrome = textPalindome.text
        
        if strPalindrome != "" {
            let strPalindromeReverse = strPalindrome?.reversed()
            var pReverseWord = ""
            for item in strPalindromeReverse! {
                pReverseWord.append(item)
            }
            
            if strPalindrome == pReverseWord {
                result = true
            }
        }
        return result
    }
    
    func showAlert(content : String){
        let alert = UIAlertController(title: "Info", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
