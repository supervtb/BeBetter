//
//  AlertView.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit

final class AlertView: UIView {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let stackView: UIStackView = {
        let vStack = UIStackView()
        vStack.isLayoutMarginsRelativeArrangement = true
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.layoutMargins = UIEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        vStack.distribution = .fill
        vStack.alignment = .fill
        return vStack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setupSubviews()
        updateContent()
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = UIColor(.totalyWhite)
        layer.cornerRadius = 10
        clipsToBounds = true
    }

    private func setupSubviews() {
        addSubview(stackView, constraints: [
            equal(\.leadingAnchor),
            equal(\.topAnchor),
            equal(\.trailingAnchor, priority: .defaultHigh),
            equal(\.bottomAnchor, priority: .defaultHigh)
        ])
    }

    private func updateContent() {
        [titleLabel, messageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        stackView.setCustomSpacing(32, after: messageLabel)
    }
}

