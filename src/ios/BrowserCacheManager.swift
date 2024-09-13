import WebKit

protocol WebsiteCacheManager {
    func deleteCache(completed: (() -> ())?)
    func deleteSessionCache(completed: (() -> ())?)
    func clearData()
}

extension WebsiteCacheManager {
    
    func deleteCache(completed: (() -> ())? = nil) {
        deleteCache(completed: completed)
    }
    
    func deleteSessionCache(completed: (() -> ())? = nil) {
        deleteSessionCache(completed: completed)
    }
}


struct BrowserCacheManager: WebsiteCacheManager {
    
    let dataStore: WKWebsiteDataStore
    
    func deleteCache(completed: (() -> ())?) {
        if #available(iOS 11.0, *), #available(OSX 10.13, *) {
            let cookieStore = dataStore.httpCookieStore
            cookieStore.getAllCookies {
                let count = $0.count
                var completedCount = 0
                $0.forEach { cookieStore.delete($0) {
                    completedCount += 1
                    if completedCount == count { completed?() }
                }}
            }
        } else {
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) {
                $0.forEach {
                    let dataTypes = $0.dataTypes
                    if dataTypes.contains(WKWebsiteDataTypeCookies) {
                        self.dataStore.removeData(ofTypes: dataTypes, for: [$0]) {}
                    }
                }
                completed?()
            }
        }
    }
    
    func deleteSessionCache(completed: (() -> ())?) {
        if #available(iOS 11.0, *), #available(OSX 10.13, *) {
            let cookieStore = dataStore.httpCookieStore
            cookieStore.getAllCookies {
                let mapped = $0.compactMap { $0.isSessionOnly ? $0 : nil }
                let count = mapped.count
                var completedCount = 0
                mapped.forEach {
                    cookieStore.delete($0) {
                        completedCount += 1
                        if completedCount == count { completed?() }
                }}
            }
        } else {
            print("clearsessioncache not available below iOS 11.0")
        }
    }
    
    func clearData() {
        dataStore.removeData(
            ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
            modifiedSince: .init(timeIntervalSince1970: 0)
        ) {
            print("Removed all data")
        }
    }
}
