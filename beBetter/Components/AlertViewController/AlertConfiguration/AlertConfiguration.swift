//
//  AlertConfiguration.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit



public struct AlertConfiguration<Action: AlertActionType> {

    let title: String
    let message: String
    let titleModifier: AlertTextModifier
    let messageModifier: AlertTextModifier
    let actions: [Action]
    let shouldDismissOnBackgoundTap: Bool

    var attributedTitle: NSAttributedString {
        titleModifier.makeAttributedString(from: title)
    }

    var attributedMessage: NSAttributedString {
        messageModifier.makeAttributedString(from: message)
    }
}

extension AlertViewController {

    convenience init(configuration: AlertConfiguration<Action>) {
        self.init(attributedTitle: configuration.attributedTitle,
                  attributedMessage: configuration.attributedMessage,
                  actions: configuration.actions)
        shouldDismissOnBackgoundTap = configuration.shouldDismissOnBackgoundTap
    }
}
