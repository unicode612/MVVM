//
//  ListViewModel.swift
//  MVVMWithAPISwift
//
//  Created by Pratik Lad on 06/03/18.
//  Copyright © 2018 Pratik Lad. All rights reserved.
//

import UIKit
class ListViewModel {
    
    ///closure use for notifi
    var reloadList = {() -> () in }
    var errorMessage = {(message : String) -> () in }
    
     var arrayOfList : [ListModel] = []{
        didSet{
            reloadList()
        }
    }
    
    ///get data from api
    func getListData()  {
        guard let listURL = URL(string: BASE_URL)else {
            return
        }
        URLSession.shared.dataTask(with: listURL){
            (data,response,error) in
            guard let jsonData = data else { return }
            do {
                ///Using Decodable data parse
                let decoder = JSONDecoder()
                self.arrayOfList = try decoder.decode([ListModel].self, from: jsonData)
            } catch let error {
                self.errorMessage(error.localizedDescription)
            }
        }.resume()
    }
    
    //using almofire
    func getListData1(param : NSDictionary) {
        APIClient.showProgress()
        APIClient.getMovieList(param: param) { result in
            APIClient.dismissProgress()
            switch result {
            case .success(let data):
                self.arrayOfList = data
            case .failure(let error):
                self.errorMessage(error.localizedDescription)
            }
        }
    }
    
}
