//
//  AccountViewModel.swift
//  beBetter
//
//  Created by Альберт Чубаков on 9.06.22.
//

import Combine

final class AccountViewModel: BaseViewModel {

    let accountManagerProvider: AccountManagerType

    let userDefaultsProvider: UserDefaultsManager

    let handleLogoutAction = PassthroughSubject<Void, Never>()

    let didLogout = PassthroughSubject<Void, Never>()

    init(accountProvider: AccountManagerType, userDefaultsProvider: UserDefaultsManager ) {
        self.accountManagerProvider = accountProvider
        self.userDefaultsProvider = userDefaultsProvider
        super.init()
        self.setObservers()
    }

    private func setObservers() {
        handleLogoutAction.sink { [weak self] _ in
            self?.userDefaultsProvider.updateLoginState(isLogged: false)
            self?.didLogout.send()
        }.store(in: &bag)
    }
}
