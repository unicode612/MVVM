
import Alamofire
import SVProgressHUD

class APIClient {
    let manager = NetworkReachabilityManager(host: "www.google.com")
    static let shared : APIClient = APIClient()
    
    @discardableResult
    private static func performRequest<T:Decodable>(url: String, param:NSDictionary, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        
        print("Calling API: \(url)")
        print("Calling parameters: \(param)")
        
        let param : Parameters = param as! Parameters
        return AF.request(url, method: .post, parameters: param, encoding: URLEncoding.default, headers: nil) // URLEncoding.httpBody  //URLEncoding.default  //JSONEncoding.default
//            .authenticate(username: Email, password: Password)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
//                print("APIClient=> \(response.result)")
                completion(response.result)
        }
    }
    
    @discardableResult
    private static func performRequestGet<T:Decodable>(url: String, param:NSDictionary, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {
        
        print("Calling API: \(url)")
        print("Calling parameters: \(param)")
        
        let param : Parameters = param as! Parameters
        return AF.request(url, method: .get, parameters: param, encoding: URLEncoding.default, headers: nil) // URLEncoding.httpBody  //URLEncoding.default  //JSONEncoding.default
//            .authenticate(username: Email, password: Password)
            .responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
//                print("APIClient=> \(response.result)")
                completion(response.result)
        }
    }
    
    @discardableResult
    private static func performRequestUpload<T:Decodable>(url: String, param:NSDictionary, image: UIImage!, imageKey:String, decoder: JSONDecoder = JSONDecoder(), completion:@escaping (Result<T, AFError>)->Void) -> DataRequest {

        print("Calling API: \(url)")
        print("Calling parameters: \(param)")

        let imageData = image!.jpegData(compressionQuality: 0.5)
        let headers: HTTPHeaders = ["Content-type": "multipart/form-data","Content-Disposition" : "form-data"]

        let param : Parameters = param as! Parameters
        return AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in param {
                print("\(value) \(key)")
                multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key)
            }
            multipartFormData.append(imageData!, withName: imageKey, fileName: "photo.png", mimeType: "image/png")
        },to: url, usingThreshold: UInt64.init(),
          method: .post,
          headers: headers).uploadProgress(queue: .main, closure: { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
            SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: "Uploading..")
          }).responseDecodable (decoder: decoder){ (response: DataResponse<T, AFError>) in
            print("APIClient=> \(response.result)")
            completion(response.result)
        }
    }
    
   
   
    //MARK: - API Methods
    static func getMovieList(param:NSDictionary, completion:@escaping (Result<[ListModel], AFError>)->Void) {
        performRequestGet(url: BASE_URL.appending(""), param: param, completion: completion)
    }
    
    //MARK: - ProgressView
    class func showProgress(msg:String = "") {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.light)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        if msg != ""{
            SVProgressHUD.show(withStatus: msg)
        }else{
            SVProgressHUD.show()
        }
    }
    
    class func dismissProgress() {
        SVProgressHUD.dismiss()
    }
    
    
    //MARK: - ConnectionObserver
    func startNetworkReachabilityObserver() {
        manager?.startListening(onUpdatePerforming: { status in
            print("Network Status1 Changed: \(status)")
            print("Network Status1 isReachable \(self.manager!.isReachable)")
            
            switch status {
            case .notReachable:
                print("The network is not reachable")
                APIClient.showError(title: "Error", message: "The network is not reachable")
//                AppUtilites.shared.showStatusBarErrorNotification(title: "No internet connection")
            case .unknown :
                print("It is unknown whether the network is reachable")
                APIClient.showError(title: "Error", message: "It is unknown whether the network is reachable")
//                AppUtilites.shared.showStatusBarErrorNotification(title: "No internet connection")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
//                NotificationCenter.default.post(name: .networkError, object: nil, userInfo: nil)
            case .reachable(.cellular):
                print("The network is reachable over the cellular connection")
//                NotificationCenter.default.post(name: .networkError, object: nil, userInfo: nil)
            }
        })
    }
    
    
    func stopNetworkReachabilityObserver() {
        manager?.stopListening()
    }
}

//MARK: - AlertView
extension APIClient{
    @objc class func showError(title: String,message: String, image:UIImage? = nil, color:UIColor = .black) {
        ISMessages.showCardAlert(withTitle: title, message: message, duration: 3, hideOnSwipe: true, hideOnTap: true, alertType: .error, alertPosition: .top, didHide: nil)
    }
    
    @objc class func showSucess(title: String,message: String, image:UIImage? = nil, color:UIColor = .black, duration:Float = 4.0) {
        ISMessages.showCardAlert(withTitle: title, message: message, duration: 3, hideOnSwipe: true, hideOnTap: true, alertType: .success, alertPosition: .top, didHide: nil)
        
    }
}
