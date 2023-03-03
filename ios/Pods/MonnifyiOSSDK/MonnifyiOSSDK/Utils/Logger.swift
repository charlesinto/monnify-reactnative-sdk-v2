import Foundation

public class Logger {
    
    private init(){}
    
    public static func log(_ items: Any...) {
        // Log only in DEBUG mode
        if Monnify.shared.loggingEnabed {
            debugPrint(items)
        }
    }
}
