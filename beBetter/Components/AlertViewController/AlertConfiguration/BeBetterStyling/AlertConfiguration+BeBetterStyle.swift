//
//  AlertConfiguration+BeBetterStyle.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import Foundation



// MARK: beBetter styling
extension AlertConfiguration where Action == DefaultAlertAction {

    enum Kind {
        case normal, error
    }

    init(title: String,
         message: String,
         kind: Kind = .normal,
         defaultActionTitle: String,
         shouldDismissOnBackgoundTap: Bool = true) {
        let action = DefaultAlertAction(title: defaultActionTitle)
        self.init(title: title,
                  message: message,
                  kind: kind,
                  actions: [action],
                  shouldDismissOnBackgoundTap: shouldDismissOnBackgoundTap)
    }

    init(title: String,
         message: String,
         kind: Kind = .normal,
         actions: [Action],
         shouldDismissOnBackgoundTap: Bool = true)  {
        switch kind {
        case .normal:
            titleModifier = BeBetterAlertTextModifier.title
        case .error:
            titleModifier = BeBetterAlertTextModifier.errorTitle
        }
        self.title = title
        self.message = message
        messageModifier = BeBetterAlertTextModifier.message
        self.actions = actions
        self.shouldDismissOnBackgoundTap = shouldDismissOnBackgoundTap
    }
}

