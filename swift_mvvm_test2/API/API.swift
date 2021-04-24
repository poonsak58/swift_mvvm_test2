//
//  API.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation

struct API {
//    {
//        "code": 200,
//        "message": "success",
//        "result": [
//            {
//                "id": 1,
//                "name": "Leanne Graham",
//                "username": "Bret",
//                "email": "Sincere@april.biz",
//                "address": {
//                    "street": "Kulas Light",
//                    "suite": "Apt. 556",
//                    "city": "Gwenborough",
//                    "zipcode": "92998-3874",
//                    "geo": {
//                        "lat": "-37.3159",
//                        "lng": "81.1496"
//                    }
//                },
//                "phone": "1-770-736-8031 x56442",
//                "website": "hildegard.org",
//                "company": {
//                    "name": "Romaguera-Crona",
//                    "catchPhrase": "Multi-layered client-server neural-net",
//                    "bs": "harness real-time e-markets"
//                }
//            },
//            ...
//        ]
//    }
    
    static let baseURL = "https://run.mocky.io/v3"

    struct User {
        static let all = "/f04bd27c-a346-4ca3-9d82-3e7885b3b2e5"
    }
    
    func requestForHTTPService<T:Entity>(path:String,
                                          method: HTTPMethod = .get,
                                          params: JSON? = nil,
                                          caching:Bool = false,
                                          responseType:GenericResponseModel<T>.Type,
                                          success: @escaping (GenericResponseModel<T>) ->Void,
                                          failed: @escaping ([String]) -> Void){
        
        HTTPService().request(path: path, method: method, params: params) { (data, error) in
            if let rawData = data{
                do{
                    if caching == true{
                        UserDefaults.standard.set(rawData, forKey: path)
                        UserDefaults.standard.synchronize()
                    }
                //print(String(data: rawData, encoding: .utf8) ?? "")
                    let responseModel = try JSONDecoder().decode(responseType, from: rawData)
                    if responseModel.code! == 444 {
//                        if responseModel.data != nil || responseModel.dataArray != nil {
//                            success(responseModel)
//                        }else{
//
//                        }
                        success(responseModel)
                    }else if let msg = responseModel.message, responseModel.code! > 209 {
                        failed([msg])
                    }else{
                        success(responseModel)
                    }
                }catch{
                    failed(["RESPONSE ERROR"])
                }
                
            }else{
                failed(["RESPONSE ERROR"])
            }
        }
    }
}
