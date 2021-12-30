//
//  ViewController.swift
//  MVVM
//
//  Created by Harry on 30/12/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName:"TCell", bundle: nil), forCellReuseIdentifier: "TCell")
        apiCall()
    }
    
    //MARK: - initial page settings
    func apiCall()  {
//        viewModel.getListData()
        viewModel.getListData1(param: ["":""])
        closureSetUp()
    }
    

    //MARK: - closureSetUp
    func closureSetUp()  {
        viewModel.reloadList = { ()  in
            ///UI chnages in main tread
            DispatchQueue.main.async {
                self.tableView.reloadData()
                APIClient.dismissProgress()
            }
        }
        viewModel.errorMessage = { (message)  in
            DispatchQueue.main.async {
                print(message)
                APIClient.dismissProgress()
                APIClient.showError(title: "Error", message: message)
            }
        }
    }
}


//MARK: - UITableView
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing : TCell.self)) as! TCell
        let listObj = viewModel.arrayOfList[indexPath.row]
        cell.setData(modelList: listObj)
        return cell
    }
    
    
}

