import Foundation
import XCTest
@testable import InAppBrowserTests

class CDVSafariViewControllerIntegrationTests: XCTestCase {
    
    func testConfigurePresentation_PageSheet() {
        let configuration = SafariBrowserConfigurations(presentationStyle: "pagesheet")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalPresentationStyle, .pageSheet)
    }
    
    func testConfigurePresentation_FormSheet() {
        let configuration = SafariBrowserConfigurations(presentationStyle: "formsheet")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalPresentationStyle, .formSheet)
    }
    
    func testConfigurePresentation_Default() {
        let configuration = SafariBrowserConfigurations()
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalPresentationStyle, .fullScreen)
    }
    
    func testConfigurePresentation_Invalid() {
        let configuration = SafariBrowserConfigurations(presentationStyle: "test")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalPresentationStyle, .fullScreen)
    }
    
    func testConfigureTransitions_CrossDissolve() {
        let configuration = SafariBrowserConfigurations(transitionsStyle: "crossdissolve")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalTransitionStyle, .crossDissolve)
    }
    
    func testConfigureTransitions_FlipHorizontal() {
        let configuration = SafariBrowserConfigurations(transitionsStyle: "fliphorizontal")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalTransitionStyle, .flipHorizontal)
    }
    
    func testConfigureTransitions_Default() {
        let configuration = SafariBrowserConfigurations()
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalTransitionStyle, .coverVertical)
    }
    
    func testConfigureTransitions_Invalid() {
        let configuration = SafariBrowserConfigurations(transitionsStyle: "test")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.modalTransitionStyle, .coverVertical)
    }
    
    func testConfigureBarTintColor() {
        let configuration = SafariBrowserConfigurations(barTintColor: .white)
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertNotNil(vc.preferredBarTintColor)
    }
    
    func testConfigureControlTintColor() {
        let configuration = SafariBrowserConfigurations(controlsTintColor: .white)
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertNotNil(vc.preferredControlTintColor)
    }
    
    func testConfigureDismissControlCaption_Done() {
        let configuration = SafariBrowserConfigurations(closeButtonCaption: "Done")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.dismissButtonStyle, .done)
    }
    
    func testConfigureDismissControlCaption_Close() {
        let configuration = SafariBrowserConfigurations(closeButtonCaption: "Close")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.dismissButtonStyle, .close)
    }
    
    func testConfigureDismissControlCaption_Cancel() {
        let configuration = SafariBrowserConfigurations(closeButtonCaption: "Cancel")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.dismissButtonStyle, .cancel)
    }
    
    func testConfigureDismissControlCaption_Default() {
        let configuration = SafariBrowserConfigurations()
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.dismissButtonStyle, .done)
    }
    
    func testConfigureDismissControlCaption_Invalid() {
        let configuration = SafariBrowserConfigurations(closeButtonCaption: "Test")
        let vc = SafariViewController(url: URL(string: "https://www.google.com")!, options: configuration)
        XCTAssertEqual(vc.dismissButtonStyle, .done)
    }
}
