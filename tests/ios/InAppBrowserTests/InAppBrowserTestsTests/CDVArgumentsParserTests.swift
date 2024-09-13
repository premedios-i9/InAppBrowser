import Foundation
import XCTest
@testable import InAppBrowserTests

class CDVArgumentsParserTests: XCTestCase {
    
    func testValidString() {
        let valid = "test1=value1,test2=value2"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertEqual(parsedDic["test1"], "value1")
        XCTAssertEqual(parsedDic["test2"], "value2")
    }
    
    func testInvalidString_NoValueArgument() {
        let valid = "test1"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertTrue(parsedDic.isEmpty)
    }
    
    func testInvalidArgument_With_ValidArgument() {
        let valid = "test1,test2=value2"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertEqual(parsedDic["test2"], "value2")
        XCTAssertNil(parsedDic["test1"])
    }
    
    func testInvalidString_ArgumentSeparationChar() {
        let valid = "test1=value1_test2=value2"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertTrue(parsedDic.isEmpty)
    }
    
    func testInvalidString_ArgumentSeparationSpace() {
        let valid = "test1=value1 test2=value2"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertTrue(parsedDic.isEmpty)
    }
    
    func testInvalidString_ArgumentNoSeparation() {
        let valid = "test1=value1test2=value2"
        let parsedDic = CDVArgumentsParser().parseOptions(valid)
        XCTAssertTrue(parsedDic.isEmpty)
    }
}
