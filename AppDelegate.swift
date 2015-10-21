//
//  AppDelegate.swift
//  weixin
//
//  Created by 陈天远 on 15/10/15.
//  Copyright © 2015年 BarFox. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, XMPPStreamDelegate {

    var window: UIWindow?
    
    
    //stream
    var xs: XMPPStream?
    //server is open or not
    var isOpen = false
    //pwd
    var pwd = ""
    
    //zhuangtai delegate
    var ztdl:ZtDL?
    
    // message delegate
    var xxdl:XxDL?
    
    //receive message
    func xmppStream(sender: XMPPStream!, didReceiveMessage message: XMPPMessage!) {
        //if chat message
        if message.isChatMessage(){
            var msg = WXMessage()
            // friends is typing
            if message.elementForName("composing") != nil {
                msg.isComposing = true
                
            }
            //is offline msg
            if message.elementForName("delay") != nil {
                msg.isDelay = true
            }
            //msg text
            if let body = message.elementForName("body"){
                
                msg.body = body.stringValue()
            }
            //total user name
            msg.from = message.from().user + "@" + message.from().domain
            
            //add to xxdl
            xxdl?.newMsg(msg)
        }
    }
    
    
    //receive zhuangtai
    func xmppStream(sender: XMPPStream!, didReceivePresence presence: XMPPPresence!) {
        
        let myUser = sender.myJID.user
        
        //friends' userID
        let user = presence.from().user
        
        //users' domain
        let domain = presence.from().domain
        
        //zhuangtai type
        let pType = presence.type()
        
        //if not yourself
        if user != myUser {
            
            var zt = Zhuangtai()
            zt.name = user + "@" + domain
            
            
            
            
            // online
            if pType == "available" {
                zt.isOnline = true
                ztdl?.isOn(zt)
                
                
            }else if pType == "unavailable" {
                ztdl?.isOff(zt)
                
            }
            
            
        }
        
        
    }
    
    //succeed to connect
    func xmppStreamDidConnect(sender: XMPPStream!) {
        isOpen = true
        // check the pwd
        func foo(value: Bool) throws {
            try xs?.authenticateWithPassword(pwd)
        }
    }
    //succeed to authen
    func xmppStreamDidAuthenticate(sender: XMPPStream!) {
        goOnline()
    }
    
    //build up stream
    func buildStream(){
        xs = XMPPStream()
        xs?.addDelegate(self, delegateQueue: dispatch_get_main_queue())
    }
    //send presense state
    func goOnline(){
        var p = XMPPPresence()
        
        xs!.sendElement(p)
    }
    //send unpresense state
    func goOffline(){
        var p = XMPPPresence(type:"unavailable")
        
        xs!.sendElement(p)
    }
    
    //connect to server (CHECK whether server is ready)
    func connect() -> Bool{
        buildStream()
        
        //server is connected
        if xs!.isConnected(){
            return true
        }
        let user = NSUserDefaults.standardUserDefaults().stringForKey("weixinID")
        let password = NSUserDefaults.standardUserDefaults().stringForKey("weixinPwd")
        let server = NSUserDefaults.standardUserDefaults().stringForKey("wxserver")
        
        if (user != nil && password != nil) {
            xs!.myJID = XMPPJID.jidWithString(user!)
            xs!.hostName = server!
            
            //pwd saved
            pwd = password!
            
            func foo(value: Bool) throws {
                try xs!.connectWithTimeout (5000)
            }
            
        }
        
        return false
    }
    
    //disconnect to server
    func disConnect(){
        goOffline()
        xs?.disconnect()
        
    }
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

