
import Foundation

public class HurryPorter : NSObject{
    
    public class func dictToString(obj:AnyObject)->String?{
        do {
            let data = try NSJSONSerialization.dataWithJSONObject(
                obj,
                options: NSJSONWritingOptions(rawValue: 0))
            if let text = NSString(data: data, encoding: NSUTF8StringEncoding){
                return String(text)
            }
        } catch _{
            return nil
        }
        return nil
    }
    
}