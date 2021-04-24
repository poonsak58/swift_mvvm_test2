//
//  GenericResponseModel.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation

struct GenericResponseModel<T:Entity>: Entity {
    
    var data: T?
    var dataArray:[T]?
    var message: String?
    var code: Int?
    var errorList: [String]?
    enum CodingKeys: String, CodingKey {
        case data = "result"
        case message = "message"
        case errorList = "error"
        case code = "code"
    }
    
    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
        do { data       = try container.decode(T?.self, forKey: .data)              }catch{}
        do { dataArray  = try container.decode([T]?.self, forKey: .data)            }catch{}
        do { message    = try container.decode(String?.self, forKey: .message)      }catch{}
        do { errorList  = try container.decode([String]?.self, forKey: .errorList)  }catch{}
        do { code       = try container.decode(Int?.self, forKey: .code)            }catch{}
    }
}
