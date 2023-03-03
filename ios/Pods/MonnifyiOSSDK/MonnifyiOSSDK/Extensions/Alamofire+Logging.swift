
import Alamofire

extension DataRequest {
    public func debugLog() -> Self {
        Logger.log(self)
        return self
    }
}
