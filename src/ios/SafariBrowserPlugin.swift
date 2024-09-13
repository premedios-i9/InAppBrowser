import SafariServices

class SafariBrowserPlugin: NSObject, SFSafariViewControllerDelegate {
    
    private let cacheManager: WebsiteCacheManager
    private var inAppBrowserViewController: SafariViewController?
    private var window: UIWindow?
    
    init(cacheManager: WebsiteCacheManager) {
        self.cacheManager = cacheManager
        super.init()
    }
    
    func setupCommonConfigurations(configurations: SafariBrowserConfigurations) {
        if configurations.clearData { cacheManager.clearData() }
        if configurations.clearCache { cacheManager.deleteCache() }
        if configurations.clearSessionCache { cacheManager.deleteSessionCache() }
    }
    
    func openInInAppBrowser(url: URL, options: SafariBrowserConfigurations) {
        if inAppBrowserViewController == nil {
            self.inAppBrowserViewController = SafariViewController(url: url, options: options)
            self.inAppBrowserViewController?.delegate = self
        }

        if !options.hidden {
            showBrowser()
        }
    }
    
    func showBrowser(animated: Bool = true, hidden: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard let inAppBrowserViewController = self.inAppBrowserViewController else {
                print("Browser not open yet or already closed")
                return
            }
            if self.window == nil {
                let window = UIWindow(frame: UIScreen.main.bounds)
                let tmpController = UIViewController()
                window.rootViewController = tmpController
                window.windowLevel = .normal
                self.window = window
            }
            if !hidden { self.window?.makeKeyAndVisible() }
            if inAppBrowserViewController.presentingViewController == nil {
                self.window?.rootViewController?.present(inAppBrowserViewController, animated: animated, completion: nil)
            }
        }
    }
    
    func closeBrowser(animated: Bool = true) {
        guard self.inAppBrowserViewController != nil else {
            print("Plugin already closed")
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            guard
                let vc = self?.inAppBrowserViewController
            else { return }
            
            vc.dismiss(animated: animated, completion: {
                self?.window?.resignKey()
                self?.window?.removeFromSuperview()
                self?.window = nil
                self?.inAppBrowserViewController = nil
            })
        }
    }
    
    func hideBrowser() {
        guard self.inAppBrowserViewController != nil else {
            print("Plugin already closed")
            return
        }
        
        window?.isHidden = true
        window?.resignKey()
    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        closeBrowser()
    }
}
