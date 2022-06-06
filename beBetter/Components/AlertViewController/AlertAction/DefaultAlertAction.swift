//
//  DefaultAlertAction.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import Foundation



public struct DefaultAlertAction: AlertActionType {

    public let title: String
    public let style: AlertActionStyle
    public let result = AlertControllerResult.ok

    init(title: String, style: AlertActionStyle = .normal) {
        self.title = title
        self.style = .normal
    }
}

public enum AlertControllerResult {
    case ok
}
