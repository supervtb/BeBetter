//
//  AlertViewController.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit
import Combine
import CloudKit



open class AlertViewController<Action: AlertActionType>: UIViewController, UIGestureRecognizerDelegate {

    // MARK: Public properties

    public var attributedTitleText: NSAttributedString? {
        set { alertView.titleLabel.attributedText = newValue }
        get { alertView.titleLabel.attributedText }
    }

    public var attributedMessageText: NSAttributedString? {
        set { alertView.messageLabel.attributedText = newValue }
        get { alertView.messageLabel.attributedText }
    }

    public var shouldDismissOnBackgoundTap = true

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public lazy var actionSelected = actions.last().sink(receiveValue: { res in
        self.dismiss(animated: true, completion: nil)
    }).store(in: &bag)


    // MARK: Private properties

    private var bag = Set<AnyCancellable>()

    private let actions = PassthroughSubject<Action.Result, Never>()

    private let alertView = AlertView()

    private lazy var transitionDelegate: AlertTransition = AlertTransition()

    // MARK: - Init

    public init(attributedTitle: NSAttributedString,
                                    attributedMessage: NSAttributedString,
                                    actions: [Action]) {
            super.init(nibName: nil, bundle: nil)
            commonInit()
            updateActions(actions: actions)
            self.attributedTitleText = attributedTitle
            self.attributedMessageText = attributedMessage
    }

    @available(*, unavailable, message: "Please use one of the provided AlertController initializers")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:bundle:) isn't supported")
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) hasn't been implemented")
    }

    private func commonInit() {
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitionDelegate
        setupLayout()
        addBackgroundTapHandler()
    }

    // MARK: - Implementation

    private func setupLayout() {
        view.addSubview(alertView, constraints: [
            equal(\.centerYAnchor),
            equal(\.leadingAnchor,
                  \.layoutMarginsGuide.leadingAnchor),
            equal(\.trailingAnchor,
                  \.layoutMarginsGuide.trailingAnchor),
            greaterThanOrEqualTo(\.topAnchor,
                                 \.layoutMarginsGuide.topAnchor),
            lessThanOrEqualTo(\.bottomAnchor,
                              \.layoutMarginsGuide.bottomAnchor)
        ])
    }

    /// Should be called ones to add all buttons to AlertView
    private func updateActions<T: AlertActionType>(actions: [T]) where Action.Result == T.Result {
        actions.map { action -> UIButton in
            // if new button types will appear
            // here is the place for configuration
            let button = PrimaryButton(type: .system)
            button.updateTitle(action.title)

            button.addAction(UIAction(handler: {  val in
                self.actions.send(action.result)
                // FIXME:
                self.dismiss(animated: true, completion: nil)
            }), for: .touchUpInside)
            return button
        }.forEach {
            alertView.stackView.addArrangedSubview($0)
        }
    }

    private func addBackgroundTapHandler() {
        let tapGesture = UITapGestureRecognizer(target: nil, action: nil)
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        //self.actions.send(completion: .finished)

//        tapGesture.rx.event
//            .filter { [weak self] recognizer in
//                guard let self = self else { return false }
//                return !self.alertView.frame.contains(recognizer.location(in: self.view)) &&
//                    recognizer.state == .ended
//            }
//            .subscribe { [weak self] _ in
//                self?.actions.onCompleted()
//            }
//            .
        self.view.addGestureRecognizer(tapGesture)
    }

    // MARK: - UIGestureRecognizerDelegate
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return shouldDismissOnBackgoundTap
    }


}
