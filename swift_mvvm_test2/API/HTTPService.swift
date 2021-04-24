//
//  HTTPService.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation
import UIKit

typealias JSON = [String: Any]

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

protocol Entity: Codable {
    /*
     init(from decoder: Decoder) throws {
     try self.init(from: decoder)
     }
     */
}

extension Entity {
    var json: JSON? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}

struct HTTPService{
    func request( path: String, method: HTTPMethod, params: JSON?, completion: @escaping (Data?, Error?) -> Void) -> Void {
        
        if let reachability = Reachability(), !reachability.isConnectedToNetwork() {
            //FIXME:- Generate Custom Error
            return
        }
        let request = URLRequest(baseUrl:API.baseURL, path: path, method: method, params: params)
        let task    = URLSession.shared.dataTask(with: request) { data, response, error in
            if let solidData = data{
                completion(solidData,nil)
            }else if let solidError = error {
                completion(nil,solidError)
            }
        }
        task.resume()
        return
    }
    
}

extension URL {
    init(baseUrl: String, path: String, params: JSON?, method: HTTPMethod) {
        var components = URLComponents(string: baseUrl+path)!
        //components.path += path
        switch method {
            case .get, .delete:
                if components.queryItems?.count != 0 && components.queryItems?.count != nil{
                    (params ?? JSON()).forEach{
                        components.queryItems?.append(URLQueryItem(name: $0.key, value: String(describing: $0.value)))
                    }
                }else {
                    components.queryItems = (params ?? JSON()).map{
                       URLQueryItem(name: $0.key, value: String(describing: $0.value))
                    }
                }
            default:
                break
            }
        print(components.url ?? "")
        self = components.url!
    }
}

extension URLRequest {
    init(baseUrl: String, path: String, method: HTTPMethod, params: JSON?) {
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        httpMethod          = method.rawValue
        timeoutInterval     = 30
        
//        let NST_Key = API.TokenKey
//        let NST_SECRET_Value = API.TokenSecret
//
//        struct MyClaims: Claims {
//            let NST_KEY: String?
//            let iat: Date?
//        }
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        //dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        let dateStr = dateFormatter.string(from: Date())
//        let utcStr = HTTPService.localToUTC(date: dateStr)
//        let date = dateFormatter.date(from: utcStr)
//
//        let myHeader = Header(typ: nil, jku: nil, jwk: nil, kid: nil, x5u: nil, x5c: nil, x5t: nil, x5tS256: nil, cty: nil, crit: nil)
//        let myClaims = MyClaims(NST_KEY: NST_Key, iat: date)
//        let myJwt = JWT(header: myHeader, claims: myClaims)
////        let p256PrivateKey = try? ECPrivateKey.make(for: .prime256v1)
//        //let privateKeyPEM = p256PrivateKey?.pemString
//        let jwtSigner = JWTSigner.hs512(key: Data(NST_SECRET_Value.utf8))
//        //let signedJWT = try myJwt.sign(using: jwtSigner)
//        let jwtEncoder = JWTEncoder(jwtSigner: jwtSigner)
//        let jwtString1 = try! jwtEncoder.encodeToString(myJwt)
//        print(jwtString1)
        
//        if path == API.Auth.refreshToken {
//            addValue("Bearer \(UserDefault.getRefreshToken())", forHTTPHeaderField: "Authorization")
//        }else{
//            if UserDefault.getToken() != "" {
//                addValue("Bearer \(UserDefault.getToken())", forHTTPHeaderField: "Authorization")
//            }
//        }
        
        addValue(UIDevice.current.identifierForVendor!.uuidString, forHTTPHeaderField: "DeviceId")
       // if let token = UserDefaults.standard.value(forKey: "Token") as? String {
            //addValue("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJDdXN0b21lcklkIjoxNCwiZXhwIjoxNjA0ODI2MTU5LjB9.BcOUcxJiBq-g3IcGFmS4jz7JFl5wg9gBxqmmVKSz1PU", forHTTPHeaderField: "Token")
        //}//eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJDdXN0b21lcklkIjoxNCwiZXhwIjoxNjAzNzE5ODA5LjB9.yIn2yaLb35qwV906TeNVPerNh1CT7Wne-7CgfH_8GGE
        //eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJOU1RfS0VZIjoiYm05d1UzUmhkR2x2YmxSdmEyVnUifQ.ijLQ18b5sjlzkJL1K2wX8geEIAFLZIotoagsAfz-qo3_u8yTHWvTmRFOqPLble9Sv4u7LZVbfec-yJLqmhJuAA
        //eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJDdXN0b21lcklkIjoxNCwiZXhwIjoxNjAyOTMwNDE0LjB9.xrxvEvVjW7MlL5kp2fxw1juxI02DtRcnBRhmpp6XzGY
        addValue("application/json", forHTTPHeaderField: "Content-Type")
//        if let token = UserDefaults.standard.string(forKey: "Token"){
//            addValue(token, forHTTPHeaderField: "Token")
//        }
        switch method {
        case .post, .put:
            do{
                 //DEBUG START
                 let jsonData = try JSONSerialization.data(withJSONObject: params ?? JSON(), options: .fragmentsAllowed)
                 let parameters = String(data: jsonData, encoding: .utf8) ?? ""
                 print(parameters)
                 //DEBUG END
                
                 httpBody = try JSONSerialization.data(withJSONObject: params ?? JSON(), options: [])
            }catch{
                //FIXME:- Uncomplete Implementation
            }
        default:
            break
        }
    }
}
