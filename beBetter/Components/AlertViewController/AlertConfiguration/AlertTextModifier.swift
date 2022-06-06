//
//  AlertTextModifier.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit



protocol AlertTextModifier {

    func makeAttributedString(from: String) -> NSAttributedString
}
