//
//  ViewController.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 21/4/2564 BE.
//

import UIKit

class ViewController: UIViewController {
    
    let userViewModel = UserViewModel()
    var userModel : UserModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        self.userViewModel.fetchUserAll()
    }

    
    private func setupBindings(){
        self.userViewModel.userAll.bind { (userModel) in
            print("---- Data ----")
            print(userModel![0].address)
        }
    }

}

