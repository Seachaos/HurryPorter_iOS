
import Foundation

public class HurryPorterHelper : NSObject{
    
    public static let osVersion = (UIDevice.currentDevice().systemVersion as NSString).floatValue
    public static var encoding = NSUTF8StringEncoding
    
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
    
    private class func _stringToObject(str:String)->AnyObject?{
        do{
            if let data = str.dataUsingEncoding(encoding){
                let obj = try NSJSONSerialization.JSONObjectWithData(data, options: [])
                return obj
            }
        }catch _{
        }
        return nil
    }
    
    public class func stringToDict(json:String)->[String:AnyObject]?{
        let obj = _stringToObject(json)
        if let dict = obj as? [String:AnyObject]{
            return dict
        }
        return nil
    }
    
    public class func stringToArray(json:String)->[AnyObject]?{
        let obj = _stringToObject(json)
        if let dict = obj as? [AnyObject]{
            return dict
        }
        return nil
    }
    
    public class func urlEncode(value:String)->String{
        if(osVersion>=9){
            return value.stringByAddingPercentEncodingWithAllowedCharacters(
                NSCharacterSet.URLQueryAllowedCharacterSet()) ?? value
        }else{
            return value.stringByAddingPercentEscapesUsingEncoding(encoding) ?? value
        }
    }
    
}

public class HurryPorter : HurryPorterHelper, NSURLConnectionDataDelegate{
    
    public enum METHOD{
        case POST
    }
    public var timeout = 30
    public var method = METHOD.POST
    
    var callback_success:((porter:HurryPorter, json:[String:AnyObject]?, raw:String)->())?
    var callback_failed:((porter:HurryPorter,  raw:String)->())?
    var busy = false
    var responseData = NSMutableData()
    var responseString = ""
    var osVersion = HurryPorterHelper.osVersion
    
    public func makeRequest(prepare:((porter:HurryPorter)->[String:AnyObject]),
        onSuccess:((porter:HurryPorter, json:[String:AnyObject]?, raw:String)->()),
        onFailed:((porter:HurryPorter,  raw:String)->()),
        href:String
    ){
        busy = true
        callback_success = onSuccess
        callback_failed = onFailed
        let dict = prepare(porter: self)
        
        guard let url = NSURL(string: href) else{
            doCallbackFailed("HP_ERROR:URL Error")
            return;
        }
        let request = NSMutableURLRequest(URL: url)
        
        switch(method){
            case METHOD.POST:
                _preparePost(request, dict:dict)
        }
        
        if(osVersion>=9){
            let session = NSURLSession.sharedSession()
            let sessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
                (odata, req, error) in
                if let e = error{
                    self.doCallbackFailed(e.description)
                    return
                }
                guard let data = odata else{
                    self.doCallbackFailed("HP_ERROR:data empty")
                    return
                }
                self.responseData = NSMutableData(data: data)
                self.doReceiveDataFinish()
            })
            sessionDataTask.resume()
        }else{
            NSURLConnection(request: request, delegate: self)
        }
    }
    
    public func makeRequestForTest(prepare:((porter:HurryPorter)->[String:AnyObject]),
        onSuccess:((porter:HurryPorter, json:[String:AnyObject]?, raw:String)->()),
        onFailed:((porter:HurryPorter,  raw:String)->()),
        href:String
    ){
        makeRequest(prepare, onSuccess: onSuccess, onFailed: onFailed, href:href)
        while(busy){
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
        }
    }
    
    func _preparePost(request:NSMutableURLRequest, dict:[String:AnyObject]){
        let postString = NSMutableString()
        for(name, value) in dict{
            if(postString.length>0){
                postString.appendString("&")
            }
            let pname = HurryPorterHelper.urlEncode(name)
            let pvalue = HurryPorterHelper.urlEncode("\(value)")
            postString.appendString("\(pname)=\(pvalue)")
        }
        request.HTTPMethod = "POST"
        request.HTTPBody = postString.dataUsingEncoding(HurryPorterHelper.encoding)
    }
    
    func doCallbackFailed(msg:String){
        guard let cb = callback_failed else{
            return
        }
        cb(porter: self, raw: msg);
        busy = false
    }
    
    func doReceiveDataFinish(){
        guard let responseString = String(data: responseData, encoding: NSUTF8StringEncoding) else{
            doCallbackFailed("HP_ERROR:responseData error")
            return
        }
        guard let cb = callback_success else{
            doCallbackFailed("HP_ERROR:callback success error")
            return
        }
        let json = HurryPorterHelper.stringToDict(responseString)
        cb(porter: self, json: json, raw: responseString)
        busy = false
    }
    
    // NSURLConnectionDataDelegate
    public func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        // start
        responseData = NSMutableData()
    }
    public func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        // doing
        responseData.appendData(data)
    }
    public func connectionDidFinishLoading(connection: NSURLConnection) {
        // finish
        doReceiveDataFinish()
    }
    public func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        // failed
        doCallbackFailed(error.description)
    }
}