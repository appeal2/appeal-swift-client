import Foundation

public class Appeal {
    
    public static func initialize(with configuration: AppealConfiguration) {
        initializedAppeal = Appeal(configuration: configuration)
    }
    
    public let configuration: AppealConfiguration
    
    private init(configuration: AppealConfiguration) {
        self.configuration = configuration
    }
    
    private static var initializedAppeal: Appeal?
    
    public static var shared: Appeal {
        if let initializedAppeal {
           return initializedAppeal
        } else if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            initializedAppeal = .init(configuration: .init(appId: ""))
            return initializedAppeal!
        } else {
            fatalError("Call Appeal.initialize(...) before accessing the shared Appeal instance.")
        }
    }
}

public final class AppealConfiguration {
    
    public let appId: String
    public let persistInDebug: Bool
    
    public init(
        appId: String,
        persistInDebug: Bool = false
    ) {
        self.appId = appId
        self.persistInDebug = persistInDebug
    }
    
}
