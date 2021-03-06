//
//  cartitem.swift
//  nibm cafe
//
//  Created by Bhanuka Nishen on 2021-03-04.
//

import Foundation

class cartitem{
    
    var Name : String
    var price : Float
    var id : String
    var documentId : String
    var qty: Int
    var singleprice: Float
    var userId: String
    
    
    init(Name:String,price:Float,id:String,documentId:String,qty:Int,singleprice:Float,userId:String) {
        self.Name = Name
        self.price = price
        self.id = id
        self.documentId = documentId
        self.qty = qty
        self.singleprice = singleprice
        self.userId = userId
    }
    
    
}
