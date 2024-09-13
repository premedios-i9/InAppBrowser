import SafariServices

class SafariViewController: SFSafariViewController {
    
    init(url: URL, options: SafariBrowserConfigurations) {
        if #available(iOS 11.0, *) {
            let configurations = Configuration()
            configurations.entersReaderIfAvailable = options.readersMode
            configurations.barCollapsingEnabled = options.barCollapsingEnabled
            super.init(url: url, configuration: configurations)
        } else {
            super.init(url: url, entersReaderIfAvailable: options.readersMode)
        }
        configure(options)
    }
    
    private func configure(_ options: SafariBrowserConfigurations) {
        options.presentationStyle.map {
            switch $0 {
            case "pagesheet":
                modalPresentationStyle = .pageSheet
            case "formsheet":
                modalPresentationStyle = .formSheet
            default:
                modalPresentationStyle = .fullScreen
            }
        }
        
        options.transitionsStyle.map {
            switch $0 {
            case "fliphorizontal":
                modalTransitionStyle = .flipHorizontal
            case "crossdissolve":
                modalTransitionStyle = .crossDissolve
            default:
                modalTransitionStyle = .coverVertical
            }
        }
        
        options.barTintColor.map { preferredBarTintColor = $0 }
        options.controlsTintColor.map { preferredControlTintColor = $0 }
        
        if #available(iOS 11.0, *) {
            switch options.closeButtonCaption?.lowercased() {
            case "close":
                dismissButtonStyle = .close
            case "cancel":
                dismissButtonStyle = .cancel
            default:
                dismissButtonStyle = .done
            }
        }
    }
}
