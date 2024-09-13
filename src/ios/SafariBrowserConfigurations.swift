import UIKit

struct SafariBrowserConfigurations {
    
    let presentationStyle: String?
    let transitionsStyle: String?
    let closeButtonCaption: String?
    let clearCache: Bool
    let clearSessionCache: Bool
    let clearData: Bool
    let hidden: Bool
    let barCollapsingEnabled: Bool
    let readersMode: Bool
    let controlsTintColor: UIColor?
    let barTintColor: UIColor?
    
    init(dict: [String: String]) {
        self.presentationStyle = dict["presentationstyle"]
        self.transitionsStyle = dict["transitionstyle"]
        self.closeButtonCaption = dict["closebuttoncaption"]
        self.clearCache = dict["clearcache"]?.bool() ?? false
        self.clearSessionCache = dict["clearsessioncache"]?.bool() ?? false
        self.clearData = dict["cleardata"]?.bool() ?? false
        self.hidden = dict["hidden"]?.bool() ?? false
        self.barCollapsingEnabled = dict["barscollapsing"]?.bool() ?? false
        self.readersMode = dict["readersmode"]?.bool() ?? false
        self.barTintColor = dict["navigationbartintcolor"].flatMap { UIColor(hex: $0) }
        self.controlsTintColor = dict["navigationbuttoncolor"].flatMap { UIColor(hex: $0) }
    }
    
    init(
        presentationStyle: String? = nil,
        transitionsStyle: String? = nil,
        closeButtonCaption: String? = nil,
        clearCache: Bool = false,
        clearSessionCache: Bool = false,
        clearData: Bool = false,
        hidden: Bool = false,
        barCollapsingEnabled: Bool = false,
        readersMode: Bool = false,
        controlsTintColor: UIColor? = nil,
        barTintColor: UIColor? = nil
    ) {
        self.presentationStyle = presentationStyle
        self.transitionsStyle = transitionsStyle
        self.closeButtonCaption = closeButtonCaption
        self.clearCache = clearCache
        self.clearSessionCache = clearSessionCache
        self.clearData = clearData
        self.hidden = hidden
        self.barCollapsingEnabled = barCollapsingEnabled
        self.readersMode = readersMode
        self.controlsTintColor = controlsTintColor
        self.barTintColor = barTintColor
    }
}

private extension String {
    
    func bool() -> Bool {
        self.lowercased() == "yes" ? true : false
    }
}

private extension UIColor {

    convenience init?(hex: String) {
        let r, g, b, a: CGFloat

        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0

            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = hexColor.count == 8 ? CGFloat(hexNumber & 0x000000ff) / 255 : 1

                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        return nil
    }
}
