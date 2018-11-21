import UIKit

/*
 UIColor Extension with app level colors
 */
extension UIColor {

    static func lcmCreateRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }

    open class var lcmHeaderBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 255, green: 209, blue: 0, alpha: 1)
    }

    open class var lcmDisabledBlack: UIColor {
        return UIColor.lcmCreateRGB(red: 0, green: 0, blue: 0, alpha: 0.4)
    }

    open class var lcmSunflowerYellow: UIColor {
        return UIColor.lcmCreateRGB(red: 255, green: 209, blue: 0, alpha: 1)
    }

    open class var lcmDisabledSunflowerYellow: UIColor {
        return UIColor.lcmCreateRGB(red: 70, green: 75, blue: 91, alpha: 1)
    }

    open class var lcmDisabledRed: UIColor {
        return UIColor.lcmCreateRGB(red: 216, green: 35, blue: 12, alpha: 1)
    }

    open class var lcmDark: UIColor {
        return UIColor.lcmCreateRGB(red: 28, green: 32, blue: 45, alpha: 1)
    }

    open class var lcmSlateGray: UIColor {
        return UIColor.lcmCreateRGB(red: 89, green: 95, blue: 111, alpha: 1)
    }

    open class var lcmCoolGray: UIColor {
        return UIColor.lcmCreateRGB(red: 168, green: 171, blue: 179, alpha: 1)
    }

    open class var lcmLightGray: UIColor {
        return UIColor(white: 221.0 / 255.0, alpha: 1.0)
    }

    open class var lcmTextFieldBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 216, green: 216, blue: 216, alpha: 0.05)
    }

    open class var lcmListItemBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 37, green: 40, blue: 53, alpha: 1)
    }

    open class var lcmTransparentHeaderColor: UIColor {
        return UIColor.lcmCreateRGB(red: 183, green: 150, blue: 0, alpha: 1)
    }

    open class var lcmPendingVerficiationTextColor: UIColor {
        return UIColor.lcmCreateRGB(red: 69, green: 139, blue: 234, alpha: 1.0)
    }

    open class var iOSDefaultBlue: UIColor {
        return UIColor.lcmCreateRGB(red: 0, green: 122, blue: 255, alpha: 1.0)
    }

    open class var lcmLightText: UIColor {
        return UIColor.lcmCreateRGB(red: 255, green: 255, blue: 255, alpha: 1.0)
    }

    open class var darkTableBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 38, green: 41, blue: 58, alpha: 1.0)
    }

    open class var lcmError: UIColor {
        return .red
    }

    open class var darkListBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 47, green: 52, blue: 70, alpha: 1.0)
    }

    open class var walletBackgroundColor: UIColor {
        return UIColor.lcmCreateRGB(red: 27, green: 30, blue: 45, alpha: 1.0)
    }

    open class var cardTypeCellSelectedColor: UIColor {
        return UIColor.lcmCreateRGB(red: 255, green: 255, blue: 255, alpha: 0.1)
    }

    open class var darkPlaceholderColor: UIColor {
        return UIColor.lcmCreateRGB(red: 63, green: 68, blue: 80, alpha: 1.0)
    }

    open class var grayRowHighlighting: UIColor {
        return UIColor.lcmCreateRGB(red: 62, green: 63, blue: 73, alpha: 1.0)
    }

    open class var availableShowersGreen: UIColor {
        return UIColor.lcmCreateRGB(red: 7, green: 138, blue: 33, alpha: 1.0)
    }

    open class var availableShowersOrange: UIColor {
        return UIColor.lcmCreateRGB(red: 231, green: 121, blue: 43, alpha: 1.0)
    }

}

/*
 Color Identifier to make it compatible to IB and design time/runtime compatible
 */
// TODO: Update with generic names instead of coolGray etc
enum LCMColorIdentifier: Int {
    case header = 0
    case headerDisabled = 1
    case dark = 2
    case slateGray = 3
    case coolGray = 4
    case lightGray = 5
    case white = 6
    case sunflowerYellow = 7
    case listItemBackgroundColor = 8
    case textFieldBackgroundColor = 9
    case textFieldTextColor = 10
    case transparentHeader = 11
    case pendingVerficiationTextColor = 12
    case error = 13
    case disabled = 14
    case disabledBlack = 15
    case unknown = -1

    static func color(_ lcmColor: LCMColorIdentifier) -> UIColor {
        return color(lcmColor: lcmColor.rawValue)
    }

    static func color(lcmColor: Int) -> UIColor {
        guard let color = LCMColorIdentifier(rawValue: lcmColor) else {
            return .black
        }

        switch color {
        case .header:
            return .lcmHeaderBackgroundColor
        case .headerDisabled:
            return .lcmHeaderBackgroundColor
        case .disabledBlack:
            return .lcmDisabledBlack
        case .dark:
            return .lcmDark
        case .slateGray:
            return .lcmSlateGray
        case .coolGray:
            return .lcmCoolGray
        case .lightGray:
            return .lcmLightGray
        case .sunflowerYellow:
            return .lcmSunflowerYellow
        case .listItemBackgroundColor:
            return .lcmListItemBackgroundColor
        case .white:
            return .white
        case .textFieldBackgroundColor:
            return .lcmTextFieldBackgroundColor
        case .textFieldTextColor:
            return .white
        case .transparentHeader:
            return .lcmTransparentHeaderColor
        case .pendingVerficiationTextColor:
            return .lcmPendingVerficiationTextColor
        case .error:
            return .lcmError
        case .disabled:
            return .lcmDisabledSunflowerYellow
        default:
            return .black
        }
    }

    func uiColor() -> UIColor {
        return LCMColorIdentifier.color(lcmColor: rawValue)
    }
}
