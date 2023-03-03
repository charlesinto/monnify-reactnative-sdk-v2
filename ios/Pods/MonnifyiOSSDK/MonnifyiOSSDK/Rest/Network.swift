import Foundation
import Alamofire
import SwiftyJSON

public class Network {
    
    public static let shared = Network()
    
    func getDefaultHeaders() -> [String: String] {
        let headers = ["Content-Type": "application/json"]
        return headers
    }
    
    private func getFinalHeaders(_ headers: [String: String]) -> [String: String] {
        var finalHeaders = getDefaultHeaders()
        for (key, value) in headers {
            finalHeaders[key] = value
        }
        return finalHeaders
    }
    
    public func request(_ urlString: String,
                        method: HTTPMethod = .get,
                        parameters: Parameters? = nil,
                        headers: [String: String] = [:],
                        successCompletion: @escaping (_ response: JSON) -> Void,
                        _ errorCompletion: @escaping (_ error: Error) -> Void = {_ in }) {
        
        let url = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!

        let header = HTTPHeaders(getFinalHeaders(headers))
        AF.request(URL(string: url)!,
                         method: method,
                         parameters: parameters,
                         encoding: JSONEncoding.default,
                         headers: header)
            .debugLog()
            .responseJSON { (response) in
                
                Logger.log("RESPONSE \(String(describing: response))")
                switch response.result {
                    case .success(let value):
                        let json = JSON(value)
                        successCompletion(json)
                    case .failure(let error):
                        errorCompletion(error)
                        Logger.log(error)
                }
        }
    }
}
