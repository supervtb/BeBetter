//
//  AlertActionType.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import Foundation


public protocol AlertActionType {

    associatedtype Result

    var title: String { get }
    var style: AlertActionStyle { get }
    var result: Result { get }
}
