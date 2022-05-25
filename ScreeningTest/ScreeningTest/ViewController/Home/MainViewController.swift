//
//  MainViewController.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 23/05/22.
//

import UIKit
import WebKit

class MainViewController: UIViewController {

    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var lblSelect : UILabel!
    @IBOutlet weak var lblFullname : UILabel!
    @IBOutlet weak var btnWebsite : UIButton!
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    private var username = ""
    private var isChoosen = false
    private var fullname = ""
    private var avatar = ""
    private var website = ""
    private var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Home"
        
        lblFullname.isHidden = true
        lblEmail.isHidden = true
        btnWebsite.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getData()
    }

    func getData(){
        let _username = UserDefaults.standard.object(forKey: "username")
        if _username != nil {
            self.username = _username as! String
            
            lblName.text = self.username
        }
        
        let _isChoosen = UserDefaults.standard.object(forKey: "isChoosen")
        if _isChoosen != nil {
            self.isChoosen = _isChoosen as! Bool
        }
        
        
        //selected user
        let _fullname = UserDefaults.standard.object(forKey: "fullname")
        let _avatar = UserDefaults.standard.object(forKey: "avatar")
        let _website = UserDefaults.standard.object(forKey: "website")
        let _email = UserDefaults.standard.object(forKey: "email")
        
        if _fullname != nil {
            lblSelect.isHidden = true
            fullname = _fullname as! String
            lblFullname.isHidden = false
            lblFullname.text = fullname
        }
        
        if _website != nil {
            website = _website as! String
            btnWebsite.isHidden = false
            btnWebsite.setTitle(website, for: .normal)
        }
        
        if _email != nil {
            email = _email as! String
            lblEmail.isHidden = false
            lblEmail.text = email
        }
        
        if _avatar != nil {
            avatar = _avatar as! String
            imgUser.downloaded(from: avatar)
            imgUser.layer.masksToBounds = true
            imgUser.layer.cornerRadius = imgUser.bounds.width / 2
        }
    }
    
    @IBAction func onChoose(_sender:UIButton, forEvent event:UIEvent){
        self.navigationController?.pushViewController(UserViewController(), animated: true)
    }
    
    @IBAction func onWebsite(_sender:UIButton, forEvent event:UIEvent){
        self.navigationController?.pushViewController(WebViewController(), animated: true)
    }
}
