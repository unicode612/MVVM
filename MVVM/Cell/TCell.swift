//
//  TCell.swift
//  MVVM
//
//  Created by Harry on 30/12/21.
//

import UIKit

class TCell: UITableViewCell {

    @IBOutlet var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setData(modelList:ListModel){
        lblName.text = modelList.title
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
