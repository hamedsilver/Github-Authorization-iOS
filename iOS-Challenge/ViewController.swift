//
//  ViewController.swift
//  iOS-Challenge
//
//  Created by Farshad Mousalou on 1/28/20.
//  Copyright © 2020 Farshad Mousalou. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

//let clientId = "your-clientId"
let clientId = "04860a64b85b7438bf91"
let clientSecret = "13342aaf3eb01b5498fc16b1bad90e1ab0e64a28"
let redirect_url = "challenge://app/callback"

class ViewController: UIViewController {

    @IBOutlet weak var accessTokenLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func loginDidPress(_ sender: Any?) {
                
        guard let url = URL(string:"https://github.com/login/oauth/authorize") else {
            return
        }
        
        guard let urlRequest = try? URLRequest(url: url, method: .get) else {
            return
        }
        
        let parameters = ["client_id": clientId,
                          "redirect_uri": redirect_url,
                          "scope": "repo user",
                          "state": 0] as [String:Any]
        
        guard let requestURL = (try? URLEncoding.default.encode(urlRequest, with:parameters))?.url else {
            return
        }
        

        UIApplication.shared.open(requestURL,
                                  options: [:]) { (result) in
                                    print(result)
        }
        
    }

    func getAuthentication(with code: String?) {
        
        guard let code = code else { return }
        
        guard let url = URL(string:"https://github.com/login/oauth/access_token") else {
            return
        }
        
        let parameters = ["client_id": clientId,
                          "redirect_uri": redirect_url,
                          "client_secret": clientSecret,
                          "code": code,
                          "state": 0] as [String:Any]
        
        Alamofire.request(url, method: .post,
                          parameters: parameters, encoding: JSONEncoding.prettyPrinted,
                          headers: ["Accept":"application/json"])
            .validate()
            .responseDecodable {[weak self] (response : DataResponse<AccessTokenResponse>) in
                switch response.result {
                case .success(let accessToken):
                    self?.accessTokenLabel.text = accessToken.accessToken
                case .failure(let error):
                    print(error)
                }
        }
        
        
    }

}



