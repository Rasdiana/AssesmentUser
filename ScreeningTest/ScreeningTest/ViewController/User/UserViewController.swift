//
//  UserViewController.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//

import UIKit
import Foundation
import MapKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var userTableView : UITableView!
    @IBOutlet weak var userCellView : UITableViewCell!
    @IBOutlet weak var mapView : MKMapView!
    private var annotations : [MKAnnotation] = []
    
    private var location : [DataMap] = [DataMap(lat: 3.5930011499068213, long: 98.62739037704401, placeName: "Manhattan"),
                                        DataMap(lat: 3.5920559731770907, long: 98.62809463220401, placeName: "SAKA Hotel"),
                                        DataMap(lat: 3.590368116465358, long: 98.62723946277639, placeName: "ACC Medan"),
                                        DataMap(lat: 3.5910780132003386, long: 98.62738854864493, placeName: "Ringroad point"),
                                        DataMap(lat: 3.591514626951969, long: 98.62606895853953, placeName: "Loket bus"),
                                        DataMap(lat: 3.592459429765145, long: 98.62702996437713, placeName: "Waroeng Steak and Shake"),
                                        DataMap(lat: 3.5913599098726494, long: 98.62840542626994, placeName: "Jawara Bakery"),
                                        DataMap(lat: 3.590593014316615, long:  98.62699222113594, placeName: "Kopi Kita"),
                                        DataMap(lat: 3.5917911280398833, long: 98.62591512883412, placeName: "Optik Internasional"),
                                        DataMap(lat: 3.5918537638814434, long: 98.62582093200058, placeName: "Sate Nasi Matang"),
                                        DataMap(lat: 3.592088685206976, long: 98.62751029145839, placeName: "Warung Sate Domba Muda"),
                                        DataMap(lat: 3.5892611733149353, long: 98.62734035604764, placeName: "Ayam Bakar Mingin")]
                                        
    
    private var userModel : [DataModel]?
    private var apiService = APIService()
    private var page = 1
    var isLoadingList : Bool = true
    
    public struct Cells {
        static let userCell = "UserCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Users"
        let pinBtn = UIButton(type: .custom)
        pinBtn.addTarget(self, action: #selector(handlePinBtn), for: .touchUpInside)
        pinBtn.setImage(UIImage(named:"ic_show_map")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pinBtn)
        self.getData(page: self.page)
        // Do any additional setup after loading the view.
        userTableView.delegate = self
        userTableView.dataSource = self
        let cell = UINib(nibName: "UserTableViewCell", bundle: nil)
        
        userTableView.register(cell, forCellReuseIdentifier: "UserCell")
        
        userTableView.refreshControl = UIRefreshControl()
        // add target to UIRefreshControl
        userTableView.refreshControl?.addTarget(self, action: #selector(callPullToRefresh), for: .valueChanged)
        mapView.isHidden = true
        
    }
    
    @objc func handlePinBtn(){
        
        if userModel != nil {
            let listBtn = UIButton(type: .custom)
            listBtn.addTarget(self, action: #selector(handleListBtn), for: .touchUpInside)
            listBtn.setImage(UIImage(named:"btnList")?.withRenderingMode(.alwaysOriginal), for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listBtn)
            
            mapView.delegate = self
            
            var i = 0
            var newUserModel : [DataModel] = []
            for item in userModel! {
                var newModel = item
                newModel.location = location[i]
                newUserModel.append(newModel)
                i += 1
            }
            
            for user in newUserModel {
                let loc = CLLocationCoordinate2D(latitude: user.location!.lat, longitude: user.location!.long)
                setPinUsingMKAnnotation(location: loc, placeName: user.location!.placeName, name: user.first_name + " " + user.last_name, email: user.email, ava: user.avatar)
            }
            
            userTableView.isHidden = true
            mapView.isHidden = false
        } else {
            self.showAlert(content: "There is no data to display in Map")
        }
        
        
    }

    @objc func handleListBtn(){
        
        let pinBtn = UIButton(type: .custom)
        pinBtn.addTarget(self, action: #selector(handlePinBtn), for: .touchUpInside)
        pinBtn.setImage(UIImage(named:"ic_show_map")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: pinBtn)
        
        mapView.removeAnnotations(annotations)
        userTableView.isHidden = false
        mapView.isHidden = true
        
    }
    
    @objc func callPullToRefresh(){
        isLoadingList = true
        self.page = 1
        self.getData(page: self.page)
        }
    
    func getData(page : Int){
//        self.isLoadingList = false
        if InternetConnectionManager.isConnectedToNetwork() {
//            DispatchQueue.main.async {
                self.apiService.requestUserData(params: page) { (response) in
                    switch response {
                    case .success(let result):
                        print(result)
                        if result.data.count != 0 {
                            if self.isLoadingList == false {
                                for item in result.data {
                                    self.userModel?.append(item)
                                }
                            } else {
                                self.userModel = result.data
                            }
                            DispatchQueue.main.async {
                                self.userTableView.reloadData()
                                self.userTableView.refreshControl?.endRefreshing()
                                self.page += 1
                            }
                            
                            
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(content: "No more data")
                            }
                        }
                    case .failure(let error):
                        switch error {
                        case .noInternetConnection:
                            print("No Internet connection")
                        default:
                            print(error.localizedDescription)
                        }
                    }
                    
                }
//            }
        }
    }

    func showAlert(content : String){
        let alert = UIAlertController(title: "Info", message: content, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Oke", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

extension UserViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(userModel)
        if userModel == nil {
            return 0
        } else {
            return userModel!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserTableViewCell

        let user = userModel?[indexPath.row]
        if indexPath.row % 2 == 0 {
            //94.9% red, 94.5% green and 94.5%
            cell.backgroundColor = UIColor.init(red: 0.949, green: 0.945, blue: 0.945, alpha: 1)
        } else if indexPath.row % 2 != 0 {
            cell.backgroundColor = UIColor.white
        }
        cell.set(user: user)
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((userTableView.contentOffset.y + userTableView.frame.size.height) >= userTableView.contentSize.height)
            {
            print(isLoadingList)
                if isLoadingList == true {
                    isLoadingList = false
                } else {
                    DispatchQueue.main.async {
                       self.getData(page: self.page)
                    }
                }
                 
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = userModel![indexPath.row]
        UserDefaults.standard.setValue(data.avatar, forKey: "avatar")
        UserDefaults.standard.setValue(data.first_name + " " + data.last_name, forKey: "fullname")
        UserDefaults.standard.setValue(data.email, forKey: "email")
        UserDefaults.standard.setValue("https://suitmedia.com/", forKey: "website")
        self.navigationController?.popViewController(animated: true)
    }
}

extension UserViewController: MKMapViewDelegate {
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    self.annotations.append(annotation)
      let Identifier = "Pin"
      let annotationView  = mapView.dequeueReusableAnnotationView(withIdentifier: Identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Identifier)
   
      annotationView.canShowCallout = true
      if annotation is MKUserLocation {
         return nil
      } else if annotation is MapPin {
         annotationView.image =  UIImage(imageLiteralResourceName: "ic_pin_point")
         return annotationView
      } else {
         return nil
      }
   }
    
    func setPinUsingMKAnnotation(location: CLLocationCoordinate2D, placeName : String, name : String, email : String, ava : String) {
       let pin1 = MapPin(title: placeName, locationName: placeName, coordinate: location, fullname: name, email: email, avatar: ava)
       let coordinateRegion = MKCoordinateRegion(center: pin1.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
       mapView.setRegion(coordinateRegion, animated: true)
       mapView.addAnnotations([pin1])
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let ann = view.annotation as! MapPin
        var data : DataModel!
        for item in userModel! {
            if item.email == ann.email {
                data = item
            }
        }
        
        DispatchQueue.main.async {
            let popUpController = PopUpViewController(data: data)
            popUpController.modalTransitionStyle = .crossDissolve
            popUpController.modalPresentationStyle = .overCurrentContext
            self.present(popUpController, animated: true, completion: nil)
        }
    }
    
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class MapPin: NSObject, MKAnnotation {
   let title: String?
   let locationName: String
   let coordinate: CLLocationCoordinate2D
    let fullname : String
    let email : String
    let avatar : String
    init(title: String, locationName: String, coordinate: CLLocationCoordinate2D, fullname : String, email : String, avatar : String) {
      self.title = title
      self.locationName = locationName
      self.coordinate = coordinate
        self.fullname = fullname
        self.email = email
        self.avatar = avatar
   }
}
