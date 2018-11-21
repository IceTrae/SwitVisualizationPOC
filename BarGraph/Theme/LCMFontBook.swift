import UIKit

/*
 Application level Fonts and subtypes
 */

enum LCMFontBook: String {
    case black = "App-Font-Black"
    case blackItalic = "App-Font-BlackItalic"
    case bold = "App-Font-Bold"
    case boldItalic = "App-Font-BoldItalic"
    case extraBold = "App-Font-ExtraBold"
    case extraBoldItalic = "App-Font-ExtraBoldItalic"
    case extraLight = "App-Font-ExtraLight"
    case extraLightItalic = "App-Font-ExtraLightItalic"
    case italic = "App-Font-Italic"
    case light = "App-Font-Light"
    case lightItalic = "App-Font-LightItalic"
    case regular = "App-Font-Regular"
    case semiBold = "App-Font-SemiBold"
    case semiBoldItalic = "App-Font-SemiBoldItalic"

    func of(size: CGFloat) -> UIFont {
        guard let font = UIFont(name: rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }

        return font
    }

    static func appFont(ofType: LCMFontBook, size: CGFloat) -> UIFont {
        return ofType.of(size: size)
    }

    static func appFont(rawValue: String) -> UIFont {
        if let font = LCMFontBook(rawValue: rawValue) {
            return font.of(size: 14.0)
        }
        return LCMFontBook.regular.of(size: 14.0)
    }
}
