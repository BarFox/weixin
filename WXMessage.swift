//
//  WXMessage.swift
//  weixin
//
//  Created by 陈天远 on 15/10/16.
//  Copyright © 2015年 BarFox. All rights reserved.
//

import Foundation


//friend list strucuture
struct WXMessage {
    var body = ""
    var from = ""
    var isComposing = false
    var isDelay = false
    var isMe = false

}


//zhuangtai struct
struct Zhuangtai {
    var name:String
    var isOnline:Bool
    
    init(){
         name = ""
        isOnline = false
    }
}