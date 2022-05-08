/// Extension that provides the semantic colors to be used all over Enablon mobile apps,
/// based on the `Colors` assets catalog.
/// See `https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/dark-mode/`
/// and `https://material.io/develop/ios/components/theming/color/#semantic-color-values`
/// for more information.

import UIKit


public extension UIColor {

    /// Enum for the color names that matches colors available in the assets catalog
    enum ColorName: String {

        /// The color displayed most frequently across all app’s screens and components
        case primary

        /// A light or dark variation of the primary color
        case secondary

        /// The color of contrast for active elements
        case tertiary

        /// The color for inactive elements
        case inactivePrimary

        /// The color for disabled elements
        case disabledPrimary

        /// The color for elements in the pressed status
        case pressedPrimary

        /// The color for background views, typically found behind scrollable content
        case backgroundPrimary

        /// The color for secondary items in background
        case backgroundSecondary

        /// The color for tertiary items in background
        case backgroundTertiary

        /// The color for separators
        case separator

        /// The color for components shown at foreground, typically cards, sheets, cells
        case surface

        /// The color dedicated to the main texts
        case textPrimary

        /// The color dedicated to the secondary texts, typically subtitles
        case textSecondary

        /// The color dedicated to the least important texts, typically placeholders
        case textTertiary

        /// The color dedicated for toggle and alert when background is darker than text
        case textQuaternary

        /// The color for shadows
        case shadow

        /// The color for overlays
        case overlay

        /// The color displayed for a neutral status
        case neutralPrimary

        /// Light or dark variation of the neutral color
        case neutralSecondary

        /// Light or dark variation of the information color
        case infoSecondary

        /// The color displayed for a success status
        case successPrimary

        /// Light or dark variation of the success color
        case successSecondary

        /// The color displayed for a warning status
        case warningPrimary

        /// Light or dark variation of the warning color
        case warningSecondary

        /// The color displayed for an error status
        case errorPrimary

        /// A light or dark variation of the error color
        case errorSecondary

        /// The color dedicated to the main texts
        case iconPrimary

        /// The color dedicated to the secondary icons
        case iconSecondary

        case pinkishGrey

        case totalyWhite

        case navigationShadow

        case blackColor

        case whiteColor

        case aquamarine

        case lightPeach

        case robinSEggBlue

    }


    /** Initialize color with provided name */
    convenience init(_ name: ColorName, in bundle: Bundle? = Bundle.main) {
        // try to load color from name, in provided bundle
        let namedColor = UIColor(named: name.rawValue, in: bundle, compatibleWith: nil)
        if namedColor == nil {
            assertionFailure()
        }
        self.init(cgColor: (namedColor ?? .clear).cgColor) // default to clear color if named color is not available
    }

}
