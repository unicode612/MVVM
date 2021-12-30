//
//  List.swift
//  MVVMWithAPISwift
//
//  Created by Pratik Lad on 06/03/18.
//  Copyright © 2018 Pratik Lad. All rights reserved.
//

import UIKit

//class List: Codable {
//    var userId : Int?
//    var id : Int?
//    var title : String?
//    var body : String?
//}

struct ListModel: Codable {
    let userID, id: Int?
    let title, body: String?

    enum CodingKeys: String, CodingKey {
        case userID
        case id, title, body
    }
}

