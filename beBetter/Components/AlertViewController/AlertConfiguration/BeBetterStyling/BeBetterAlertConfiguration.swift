//
//  BeBetterAlertConfiguration.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import Foundation



enum BeBetterAlertConfiguration {

    static func loginError(_ error: String = "") -> AlertConfiguration<DefaultAlertAction> {
        return AlertConfiguration(title: "Error",
                                  message: error,
                                  defaultActionTitle: "OK")
    }
}
