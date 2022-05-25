//
//  PopUpViewController.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 25/05/22.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var popUpImg : UIImageView!
    @IBOutlet weak var avaImg : UIImageView!
    @IBOutlet weak var lblName : UILabel!
    @IBOutlet weak var btnChoose : UIButton!
    
    var model : DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        avaImg.downloaded(from: model.avatar)
        lblName.text = model.first_name + " " + model.last_name
        
        avaImg.layer.masksToBounds = true
        avaImg.layer.cornerRadius = avaImg.bounds.width / 2
    }
    
    init(data : DataModel) {
        self.model = data

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func onChhose(_sender:UIButton, forEvent event:UIEvent){
        UserDefaults.standard.setValue(model.avatar, forKey: "avatar")
        UserDefaults.standard.setValue(model.first_name + " " + model.last_name, forKey: "fullname")
        UserDefaults.standard.setValue(model.email, forKey: "email")
        UserDefaults.standard.setValue("https://suitmedia.com/", forKey: "website")
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
    }
    
    @IBAction func onClose(_sender:UIButton, forEvent event:UIEvent){
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
