//
//  UserViewModel.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation

class UserViewModel {
    var userAll = Bindable<[Result]>()
    
    private var users: [Result]? {
        didSet{
            userAll.value = users
        }
    }
    
}

extension UserViewModel {
    func fetchUserAll(){
        print("Fetch")
        API().requestForHTTPService(path: API.User.all, method: .get, responseType: GenericResponseModel<Result>.self, success: { (response) in
            self.users = response.dataArray
        }) { (errorMessages) in
            print(errorMessages.joined(separator: "\n"))
            self.users = []
        }
    }
}
