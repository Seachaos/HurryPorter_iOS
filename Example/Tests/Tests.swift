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
                let postDict = [
                    "name":"Hurry",
                    "value":"Porter"
                ]
                let porter = HurryPorter()
                porter.makeRequestForTest({
                    (porter)->[String:AnyObject] in
                    return postDict
                }, onSuccess: {
                    (porter, json, raw)->() in
                    NSLog("raw:%@", raw)
                    guard let dict = json else {
                        fail("json is nil")
                        return
                    }
                    let dictStr = HurryPorter.dictToString(dict)
                    expect(dictStr).notTo(beNil())
                    expect(dictStr).notTo(beEmpty())
                    expect(dictStr) == HurryPorter.dictToString(postDict)
                    expect(dictStr) != "empty string"
                }, onFailed: {
                    (porter, raw) -> () in
                    NSLog("failed:%@", raw)
                    fail(raw)
                }, href: "http://www.myandroid.tw/test/post.php")
            }
        }
        
        describe("test else method"){
            it("md5 should correct"){
                let expect_md5 = "da7a4c1171e14afc0744bf2f34d8515f"
                let md5 = HurryPorterOC.MD5("testaaaa")
                expect(expect_md5) == md5
                expect(expect_md5) != "testaaaa"
            }
        }
    }
}
