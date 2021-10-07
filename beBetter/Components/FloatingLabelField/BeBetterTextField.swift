import UIKit

class BeBetterTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        applyElcoinStyle()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyElcoinStyle()
    }

    func applyElcoinStyle() {
        textColor = UIColor.black
        tintColor = UIColor.green
    }
}

final class BeBetterSecureTextField: BeBetterTextField {

    private let eyeButton = UIButton(type: .system)

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSecureTextEntry = true
        setupRightView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        isSecureTextEntry = true
        setupRightView()
    }

    private func setupRightView() {
        rightView = eyeButton
        rightViewMode = .always
        eyeButton.tintColor = UIColor.black
        eyeButton.addTarget(self,
                            action: #selector(onButtonTap(_:)),
                            for: .touchUpInside)
        updateImage()
    }

    @objc private func onButtonTap(_ sender: UIButton) {
        toggleState()
    }

    private func toggleState() {
        isSecureTextEntry.toggle()
        updateImage()
    }

    private func updateImage() {
        // set private img
//        eyeButton.setImage(isSecureTextEntry ? Asset.eyeOn.image : Asset.eyeOff.image,
//                           for: .normal)
    }
}
