//
//  AlertAction.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import Foundation



public struct AlertAction<R>: AlertActionType {

    public typealias Result = R

    public let title: String
    public let style: AlertActionStyle
    public let result: R
}

