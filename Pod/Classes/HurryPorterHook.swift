//
//  HurryPorterHook.swift
//  Pods
//
//  Created by 葉建胤 on 2016/3/3.
//
//


import Foundation

public protocol HurryPorterHookDelegatePrepareData{
    func willBeSent(porter:HurryPorter, json:[String:AnyObject])->[String:AnyObject]
}
public protocol HurryPorterHookDelegateCheckResponse{
    func verifyData(porter:HurryPorter, json:[String:AnyObject]?, raw:String)->Bool
    func errorMessage(porter:HurryPorter, json:[String:AnyObject]?, raw:String)->String?
}

public class HurryPorterHook: NSObject {
    public struct global{
        public static var prepareData:HurryPorterHookDelegatePrepareData?
        public static var checkResponse:HurryPorterHookDelegateCheckResponse?
    }
    
}
