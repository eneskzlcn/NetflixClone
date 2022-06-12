//
//  ObservableObject.swift
//  Netflix Clone
//
//  Created by Nazif Enes Kızılcin on 12.06.2022.
//

import Foundation

final class ObservableObject<T> {
    typealias Listener = ((T) -> Void)
    var value : T {
        didSet {
            listeners.forEach{listener in
                listener(value)
            }
        }
    }
    private var listeners: [Listener] = []
    
    init(_ value : T) {
        self.value = value
    }
    func bind(_ listener: @escaping Listener) {
        listener(self.value)
        self.listeners.append(listener)
    }
    
}
