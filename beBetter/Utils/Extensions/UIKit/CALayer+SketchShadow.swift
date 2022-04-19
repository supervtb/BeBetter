// From https://stackoverflow.com/questions/34269399/how-to-control-shadow-spread-and-blur
import UIKit

extension CALayer {

    func applySketchShadow(
        color: UIColor,
        alpha: Float = 1,
        xValue: CGFloat = 0,
        yValue: CGFloat = 0,
        blur: CGFloat,
        spread: CGFloat = 0
    )
    {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xValue, height: yValue)
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
        applySketchShadow(color: UIColor.systemGray,
                          alpha: 0.5,
                          xValue: 0,
                          yValue: 0,
                          blur: 14,
                          spread: 0)
    }
}
