import Foundation
import XCTest
@testable import InAppBrowserTests

class SafariBrowserConfigurationsTests: XCTestCase {
    
    func testBarTintColorParsing_Hexa6() {
        let dic = ["navigationbartintcolor": "#FFFFFF"]
        let target = SafariBrowserConfigurations(dict: dic)
        XCTAssertNotNil(target.barTintColor)
    }
    
    func testControlTintColorParsing_Hexa8() {
        let dic = ["navigationbuttoncolor": "#FFFFFFFF"]
        let target = SafariBrowserConfigurations(dict: dic)
        XCTAssertNotNil(target.controlsTintColor)
    }
    
    func testPresentationParsing() {
        let dic = ["presentationstyle": "test"]
        let target = SafariBrowserConfigurations(dict: dic)
        XCTAssertNotNil(target.presentationStyle)
    }
    
    func testTransitionParsing() {
        let dic = ["transitionstyle": "test"]
        let target = SafariBrowserConfigurations(dict: dic)
        XCTAssertNotNil(target.transitionsStyle)
    }
    
    func testCloseButtonParsing() {
        let dic = ["closebuttoncaption": "test"]
        let target = SafariBrowserConfigurations(dict: dic)
        XCTAssertNotNil(target.closeButtonCaption)
    }
}
