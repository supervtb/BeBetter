// From https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
import UIKit

extension CALayer {

    func applySketchShadow(
        color: UIColor,
        alpha: Float = 1,
        x: CGFloat = 0,
        y: CGFloat = 0,
        blur: CGFloat,
        spread: CGFloat = 0)
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: x, height: y)
        shadowRadius = blur / UIScreen.main.scale
        if spread == 0 {
            shadowPath = nil
        } else {
            let dx = -spread
            let rect = bounds.insetBy(dx: dx, dy: dx)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }

    func applyDefaultContainerShadow() {
        applySketchShadow(color: UIColor(.backgroundPrimary),
                          alpha: 0.5,
                          x: 0,
                          y: 0,
                          blur: 14,
                          spread: 0)
    }
}

