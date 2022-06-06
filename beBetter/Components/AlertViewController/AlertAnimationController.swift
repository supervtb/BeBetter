//
//  AlertAnimationController.swift
//  beBetter
//
//  Created by Альберт Чубаков on 5.06.22.
//

import UIKit

class AlertAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    private enum Constants {

        static let initialScale: CGFloat = 1.2
        static let springDamping: CGFloat = 45.71
        static let springVelocity: CGFloat = 0
    }

    private var isPresentation = false

    init(presentation: Bool) {
        self.isPresentation = presentation
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.404
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromController =
                transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toController =
                transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let fromView = fromController.view,
            let toView = toController.view else
        {
            return
        }

        if self.isPresentation {
            transitionContext.containerView.addSubview(toView)
        }

        let animatingController = self.isPresentation ? toController : fromController
        let animatingView = animatingController.view
        animatingView?.frame = transitionContext.finalFrame(for: animatingController)

        if self.isPresentation {
            animatingView?.transform = CGAffineTransform(scaleX: Constants.initialScale, y: Constants.initialScale)
            animatingView?.alpha = 0

            self.animate({
                    animatingView?.transform = CGAffineTransform(scaleX: 1, y: 1)
                    animatingView?.alpha = 1
                }, inContext: transitionContext, withCompletion: { finished in
                    transitionContext.completeTransition(finished)
                })

        } else {
            self.animate({
                    animatingView?.alpha = 0
                }, inContext: transitionContext, withCompletion: { finished in
                    fromView.removeFromSuperview()
                    transitionContext.completeTransition(finished)
                })
        }

    }

    private func animate(_ animations: @escaping (() -> Void),
                         inContext context: UIViewControllerContextTransitioning,
                         withCompletion completion: @escaping (Bool) -> Void)
    {
        UIView.animate(withDuration: self.transitionDuration(using: context), delay: 0,
                       usingSpringWithDamping: Constants.springDamping, initialSpringVelocity: Constants.springVelocity, options: [],
                       animations: animations, completion: completion)
    }
}
