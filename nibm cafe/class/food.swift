//
//  food.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-02.
//

import Foundation
import UIKit

class food {
    var Name : String
    var discription : String
    var price : Float
    var discount : Int
    var id : String
    var documentId : String
   
    
    init(Name : String,discription : String,price : Float,discount:Int,id:String,documentId:String) {
        
        self.Name = Name
        self.discription = discription
        self.price = price
        self.discount = discount
        self.id = id
        self.documentId = documentId
        
        
    }
}
