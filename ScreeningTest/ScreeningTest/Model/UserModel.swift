//
//  UserModel.swift
//  ScreeningTest
//
//  Created by 1-18 Golf on 24/05/22.
//

import Foundation
import MapKit

public struct UserModel : Codable {
    public let page : Int
    public let total : Int
    public let total_pages : Int
    public let data : [DataModel]
}

public struct DataModel : Codable {
    public let id : Int
    public let email : String
    public let first_name : String
    public let last_name : String
    public let avatar : String
    public var location : DataMap?
}

public struct DataMap : Codable {
    public let lat : Double
    public let long : Double
    public let placeName : String
}
