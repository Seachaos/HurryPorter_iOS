
import Foundation

public class HurryPorterHelper : NSObject{
    
    public class func dictToString(obj:AnyObject)->String?{
        guard let _ = obj as? [String:AnyObject] else{
            guard let _ = obj as? [AnyObject] else{
                return nil
            }
            return _objectToString(obj)
        }
        return _objectToString(obj)
    }
    private class func _objectToString(obj:AnyObject)->String?{
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(
                obj,
                options: [])
            if let text = NSString(data: data, encoding: NSUTF8StringEncoding){
                return String(text)
            }
        } catch _{
            return nil
        }
        return nil
    }
}

public class HurryPorter : HurryPorterHelper{
    
    public var timeout = 30
    
    var callback_success:((porter:HurryPorter, json:[String:AnyObject], raw:String)->())?
    var callback_failed:((porter:HurryPorter,  raw:String)->())?
    var busy = false
    
    public func makeRequest(prepare:((porter:HurryPorter)->[String:AnyObject]),
        onSuccess:((porter:HurryPorter, json:[String:AnyObject], raw:String)->()),
        onFailed:((porter:HurryPorter,  raw:String)->())
    ){
        busy = true
        callback_success = onSuccess
        callback_failed = onFailed
        let dict = prepare(porter: self)
        
    }
    
    public func makeRequestForTest(prepare:((porter:HurryPorter)->[String:AnyObject]),
        onSuccess:((porter:HurryPorter, json:[String:AnyObject], raw:String)->()),
        onFailed:((porter:HurryPorter,  raw:String)->())
    ){
        makeRequest(prepare, onSuccess: onSuccess, onFailed: onFailed)
        while(busy){
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
        }
    }
}