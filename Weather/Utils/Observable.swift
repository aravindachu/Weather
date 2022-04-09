//
//  Observable.swift
//  Weather
//
//  Created by Aravind Vijayan on 01/03/22.
//

import Foundation

class Observable<T> {
    typealias Listener = (T) -> ()
    var listener: Listener?

    func bindAndUpdate(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    func bind(_ listener: Listener?) {
        self.listener = listener
    }

    var value: T {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.listener?(self.value)
            }
        }
    }

    init(_ v: T) {
        value = v
    }
}
