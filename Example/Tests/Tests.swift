// https://github.com/Quick/Quick

import Quick
import Nimble
import HurryPorter

class TableOfContentsSpec: QuickSpec {
    override func spec() {
        
        describe("test json to string convert"){
            it("dict to json string"){
                let dict = ["A":"B", "ARRAY":[1,2,3,4,5]]
                if let str = HurryPorter.dictToString(dict) {
                    expect(str) == "{\"ARRAY\":[1,2,3,4,5],\"A\":\"B\"}"
                }else{
                    expect(false) == true
                }
            }
            it("expect json failed"){
                let dict = "TEST"
                if let _ = HurryPorter.dictToString(dict) {
                    expect(false) == true
                }else{
                    expect(true) == true
                }
            }
        }
        
    }
}
