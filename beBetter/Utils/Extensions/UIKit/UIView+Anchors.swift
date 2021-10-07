import UIKit

/*
How to use current extension
    let view = UIView()
    let label = UILabel()
    view.addSubview(label, constraints: [equal(\.leadingAnchor, 10),
                                         equal(\.topAnchor, 20),
                                         equal(\.trailingAnchor)])
*/
public typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                _ toKeyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        let constraint = view[keyPath: keyPath].constraint(equalTo: parent[keyPath: toKeyPath], constant: constant)
        constraint.priority = priority
        return constraint
    }
}

public func lessThanOrEqualTo<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                            _ toKeyPath: KeyPath<UIView, Anchor>,
                                            constant: CGFloat = 0,
                                            priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        let constraint = view[keyPath: keyPath].constraint(lessThanOrEqualTo: parent[keyPath: toKeyPath], constant: constant)
        constraint.priority = priority
        return constraint
    }
}

public func greaterThanOrEqualTo<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                          _ toKeyPath: KeyPath<UIView, Anchor>,
                                          constant: CGFloat = 0,
                                          priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { view, parent in
        let constraint = view[keyPath: keyPath].constraint(greaterThanOrEqualTo: parent[keyPath: toKeyPath], constant: constant)
        constraint.priority = priority
        return constraint
    }
}

public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant, priority: priority)
}

public func lessThanOrEqualTo<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                            constant: CGFloat = 0,
                                            priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return lessThanOrEqualTo(keyPath, keyPath, constant: constant, priority: priority)
}

public func greaterThanOrEqualTo<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                          constant: CGFloat = 0,
                                          priority: UILayoutPriority = .required) -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return greaterThanOrEqualTo(keyPath, keyPath, constant: constant, priority: priority)
}

public extension UIView { //Layout
    func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    func addSubviewWithAnchorsToSuperView(_ child: UIView) {
        self.addSubview(child, constraints: [equal(\.topAnchor),
                                             equal(\.bottomAnchor),
                                             equal(\.leftAnchor),
                                             equal(\.rightAnchor)])
    }
}

