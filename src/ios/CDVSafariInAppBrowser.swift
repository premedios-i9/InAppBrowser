import SafariServices

private enum Target: String {
    case ownSelf = "_self"
    case blank = "_blank"
    case system = "_system"
}

protocol CDVInAppBrowserPlugin {
    var cordovaWebViewEngine: CDVWebViewEngineProtocol? { get }
}

extension CDVInAppBrowserPlugin {
    
    func openInSystem(url: URL, notificationCenter: NotificationCenter = NotificationCenter.default) {
        if UIApplication.shared.canOpenURL(url) {
            notificationCenter.post(name: NSNotification.Name.CDVPluginHandleOpenURL, object: url)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func openInCordovaWebView(url: URL) {
        cordovaWebViewEngine?.load(URLRequest(url: url))
    }
}

@objc(CDVSafariInAppBrowser)
class CDVSafariInAppBrowser: CDVPlugin, CDVInAppBrowserPlugin {
    
    static let shared = CDVSafariInAppBrowser()
    
    var cordovaWebViewEngine: CDVWebViewEngineProtocol?
    private var plugin: SafariBrowserPlugin?
    private var callbackId: String?

    static func getInstance() -> CDVSafariInAppBrowser {
        return shared
    }
    
    override func pluginInitialize() {
        self.cordovaWebViewEngine = self.webViewEngine
        self.plugin = SafariBrowserPlugin(cacheManager: BrowserCacheManager(dataStore: .default()))
    }
    
    override func onReset() {
        plugin?.closeBrowser()
    }
    
    @objc(open:)
    func open(command: CDVInvokedUrlCommand) {
        guard let cordovaWebViewEngine = cordovaWebViewEngine else { return }
        
        let baseURL = cordovaWebViewEngine.url()
        let url = command.argument(at: 0) as? String
        let target = (command.argument(at: 1) as? String) ?? Target.ownSelf.rawValue
        let options = command.argument(at: 2, withDefault: "", andClass: NSString.self) as? String
        
        callbackId = command.callbackId
        
        if
            let url = url,
            let options = options,
            let absoluteURL = URL(string: url, relativeTo: baseURL)
        {
            let parsedOptions = CDVArgumentsParser().parseOptions(options)
            let browserOptions = SafariBrowserConfigurations(dict: parsedOptions)
            var targetAux = Target(rawValue: target) ?? .ownSelf
            
            if absoluteURL.isSystemURL() {
                targetAux = .system
            }
            
            plugin?.setupCommonConfigurations(configurations: browserOptions)
            
            switch targetAux {
            case .blank:
                openInCordovaWebView(url: absoluteURL)
            case .system:
                openInSystem(url: absoluteURL)
            default:
                plugin?.openInInAppBrowser(url: absoluteURL, options: browserOptions)
            }
            
            let pluginResult = CDVPluginResult(status: .ok)
            commandDelegate.send(pluginResult, callbackId: command.callbackId)
        } else {
            let pluginResult = CDVPluginResult(status: .error, messageAs: "incorrect number of arguments")
            commandDelegate.send(pluginResult, callbackId: command.callbackId)
        }
    }
    
    @objc(show:)
    func show(command: CDVInvokedUrlCommand) {
        plugin?.showBrowser()
    }
    
    @objc(close:)
    func close(command: CDVInvokedUrlCommand) {
        plugin?.closeBrowser()
    }
    
    @objc(hide:)
    func hide(command: CDVInvokedUrlCommand) {
        plugin?.hideBrowser()
    }
}

struct CDVArgumentsParser {
    
    func parseOptions(_ options: String) -> [String: String] {
        let arrayOptions = options.components(separatedBy: ",")
            .compactMap { $0.isEmpty ? nil : $0 }
            .map { pair -> (String, String)? in
                let keyValue = pair.components(separatedBy: "=")
                return keyValue.count == 2 ? (keyValue[0], keyValue[1]) : nil
            }
            .compactMap { $0 }
        return Dictionary(arrayOptions) { $1 }
    }
}

private extension URL {
    
    func isSystemURL() -> Bool {
        return host == "itunes.apple.com"
    }
}
