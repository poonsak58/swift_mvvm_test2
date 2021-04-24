//
//  Bindable.swift
//  swift_mvvm_test2
//
//  Created by Poonsak Aphidetmongkhon on 22/4/2564 BE.
//

import Foundation

class Bindable<T>{
    init(initialValue:T? = nil) {
        value = initialValue
    }
    var value: T?{
        didSet{
            observers.forEach({$0?(value)})
        }
    }
    fileprivate var observers:[((T?)->())?] = []
    func bind(observer: @escaping (T?)->()){
        self.observers.append(observer)
    }
}
