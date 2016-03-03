//
//  ViewController.swift
//  HurryPorter
//
//  Created by Seachaos on 02/25/2016.
//  Copyright (c) 2016 Seachaos. All rights reserved.
//

import UIKit

class HookTestCheckResponse : HurryPorterHookDelegateCheckResponse{
    func verifyData(porter: HurryPorter, json: [String : AnyObject]?, raw: String) -> Bool {
        NSLog("on hook.verifyData:" + raw)
        guard let dict = json else{
            return false
        }
        if let status = dict["status"] as? NSNumber{
            let code = status.integerValue
            if code == 1000 {
                return true
            }
        }
        if let status = dict["status"] as? String{
            if status == "1000"{
                return true
            }
        }
        return false
    }
    
    func errorMessage(porter: HurryPorter, json: [String : AnyObject]?, raw: String) -> String? {
        return "Just Error"
    }
}

class HookTestPrepare : HurryPorterHookDelegatePrepareData{
    func willBeSent(porter: HurryPorter, json: [String : AnyObject]) -> [String : AnyObject] {
        var dict = json
        dict["status"] = 1000
        return dict
    }
}

class ViewController: UIViewController {
    
    let checker = HookTestCheckResponse()
    let prepare = HookTestPrepare()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HurryPorterHook.global.prepareData = prepare
        HurryPorterHook.global.checkResponse = checker
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let uobjc = UsingInOBJC()
        
        self.view.backgroundColor = UIColor.grayColor()
        appendButton("[Test Request]", action:"doRequestTest", y:50)
        appendButton("[Test HOOK]", action:"doRequestHookTest", y:120)
        appendButton("[HOOK and Prepare]", action:"doRequestHookAndPrepareTest", y:190)
        appendButton("[Test Request RM HOOK]", action:"doRequestRemoveHookTest", y:260)
        
        
    }
    
    func appendButton(name:String, action:String, y:CGFloat){
        let btn = UIButton()
        btn.setTitle(name, forState: UIControlState.Normal)
        btn.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        btn.addTarget(self, action: Selector(action), forControlEvents: UIControlEvents.TouchUpInside)
        btn.backgroundColor = UIColor.whiteColor()
        btn.frame = CGRectMake(50, y, 200, 50)
        
        self.view.addSubview(btn)
    }
    
    func doRequestRemoveHookTest(){
        let dialog = UIAlertView()
        dialog.title = "Busy"
        dialog.show()
        let porter = HurryPorter()
        porter.makeRequest( {
            (porter)->[String:AnyObject] in
            var dict = [String:AnyObject]()
            dict["name"] = "Hurry"
            dict["value"] = "Porter"
            porter.checkResponse = nil
            porter.prepareData = nil
            return dict
            }, onSuccess: {
                (porter, json, raw) in
                NSLog("success:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, onFailed: {
                (porter, raw, status) in
                NSLog("failed:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, href: "http://www.myandroid.tw/test/post.php");
    }
    
    func doRequestTest(){
        let dialog = UIAlertView()
        dialog.title = "Busy"
        dialog.show()
        let porter = HurryPorter()
        porter.prepareData = nil
        porter.makeRequest( {
            (porter)->[String:AnyObject] in
                var dict = [String:AnyObject]()
                dict["name"] = "Hurry"
                dict["value"] = "Porter"
                return dict
            }, onSuccess: {
                (porter, json, raw) in
                NSLog("success:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, onFailed: {
                (porter, raw, status) in
                NSLog("failed:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, href: "http://www.myandroid.tw/test/post.php");
    }

    
    func doRequestHookTest(){
        let dialog = UIAlertView()
        dialog.title = "Busy"
        dialog.show()
        let porter = HurryPorter()
        porter.checkResponse = self.checker
        porter.makeRequest( {
            (porter)->[String:AnyObject] in
            var dict = [String:AnyObject]()
            dict["name"] = "Hurry"
            dict["value"] = "Porter"
            return dict
            }, onSuccess: {
                (porter, json, raw) in
                NSLog("success:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, onFailed: {
                (porter, raw, status) in
                NSLog("failed:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, href: "http://www.myandroid.tw/test/post.php");
    }
    
    
    func doRequestHookAndPrepareTest(){
        let dialog = UIAlertView()
        dialog.title = "Busy"
        dialog.show()
        let porter = HurryPorter()
        porter.makeRequest( {
            (porter)->[String:AnyObject] in
                porter.prepareData = self.prepare
                var dict = [String:AnyObject]()
                dict["name"] = "Hurry"
                dict["value"] = "Porter"
                return dict
            }, onSuccess: {
                (porter, json, raw) in
                NSLog("success:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, onFailed: {
                (porter, raw, status) in
                NSLog("failed:" + raw)
                dialog.dismissWithClickedButtonIndex(0, animated: true)
            }, href: "http://www.myandroid.tw/test/post.php");
    }
    
}

