// https://github.com/Quick/Quick

import Quick
import Nimble
import HurryPorter

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        
        describe("test object to string convert"){
            it("dict to json string"){
                let dict = ["A":"B", "ARRAY":[1,2,3,4,5]]
                if let str = HurryPorter.dictToString(dict) {
                    expect(str) == "{\"ARRAY\":[1,2,3,4,5],\"A\":\"B\"}"
                }else{
                    fail("convert failed")
                }
            }
            it("array to json string"){
                let array = [1,2,3,4,5,6,7]
                if let str = HurryPorter.dictToString(array) {
                    expect(str) == "[1,2,3,4,5,6,7]"
                }else{
                    expect(false) == true
                }
            }
            it("expect json failed"){
                let dict = "TEST"
                if let _ = HurryPorter.dictToString(dict) {
                    fail("can't be string")
                }else{
                    expect(true) == true
                }
            }
        }
        
        describe("make request"){
            it("should get response"){
                let porter = HurryPorter()
                porter.makeRequest({
                    (porter)->[String:AnyObject] in
                    var dict = ["A":"B"]
                    dict["Name"] = "Hurry"
                    return dict
                }, onSuccess: {
                    (porter, json, raw)->() in
                    NSLog("raw:%@", raw)
                }, onFailed: {
                    (porter, raw) -> () in
                    NSLog("failed:%@", raw)
                    fail(raw)
                })
            }
        }
    }
}
