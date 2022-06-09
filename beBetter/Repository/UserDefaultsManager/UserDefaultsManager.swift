//
//  UserDefaultsManager.swift
//  beBetter
//
//  Created by Альберт Чубаков on 9.06.22.
//

import Combine
import Foundation



public protocol UserDefaultsManager: Any {

    var isLogged: CurrentValueSubject<Bool?, Never> { get }

    func updateLoginState(isLogged: Bool)
}

final class UserDefaultsManagerImpl: UserDefaultsManager {

    var isLogged = CurrentValueSubject<Bool?, Never>(UserDefaults.standard.bool(forKey: "user"))

    var bag = Set<AnyCancellable>()

    func updateLoginState(isLogged: Bool) {
        UserDefaults.standard.set(isLogged, forKey: "user")
        UserDefaults.standard.synchronize()
    }

}
