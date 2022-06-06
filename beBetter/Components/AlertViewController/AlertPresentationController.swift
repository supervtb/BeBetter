//
//  AlertPresentationController.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit

class AlertPresentationController: UIPresentationController {

    private let dimmingView = UIView()

    override init(presentedViewController: UIViewController,
                  presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.dimmingView.backgroundColor = UIColor(.alertBackground)
    }

    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .dimmed
        self.dimmingView.alpha = 0

        self.containerView?.addSubview(self.dimmingView)

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 1 }, completion: nil)
    }

    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()

        self.presentingViewController.view.tintAdjustmentMode = .automatic

        let coordinator = self.presentedViewController.transitionCoordinator
        coordinator?.animate(alongsideTransition: { _ in self.dimmingView.alpha = 0 }, completion: nil)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()

        if let containerView = self.containerView {
            self.dimmingView.frame = containerView.frame
        }
    }
}

