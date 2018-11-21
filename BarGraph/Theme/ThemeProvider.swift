import UIKit

/*
 Protocol to establish contract between different subclasses to provide the font
 */
protocol LCMLabelTheming {
    static var isDesignTimeEnvironment: Bool { get }
    static var fontBook: LCMFontBook { get }
}

protocol Themeable {
    func applyTheme()
}

class ThemeProvider {

    private static var _keyboardAppearance: UIKeyboardAppearance = .dark
    static var keyboardAppearance: UIKeyboardAppearance {
        return _keyboardAppearance
    }

    static func applyTheme() {
        LCMDarkNavigationBar.appearance().barTintColor = UIColor.lcmDark
        LCMDarkNavigationBar.appearance().tintColor = .white
        LCMDarkNavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: LCMFontBook.bold.of(size: 18.0), NSAttributedString.Key.foregroundColor: UIColor.white]
        LCMDarkNavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        LCMDarkNavigationBar.appearance().isTranslucent = false

        LCMNavigationBar.appearance().barTintColor = UIColor.lcmHeaderBackgroundColor
        LCMNavigationBar.appearance().tintColor = UIColor.lcmDark
        LCMNavigationBar.appearance().isTranslucent = false
        if let image = UIImage.from(color: UIColor.lcmHeaderBackgroundColor) {
            // Using the strechable image, to avoid any future issue (navigation bar extension)
            var stretchableImage = image.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0)
            stretchableImage = stretchableImage.withRenderingMode(.alwaysOriginal)
            LCMNavigationBar.appearance().setBackgroundImage(image, for: .default)
        }

        // Set the title font to app-font-bold with font size 18
        LCMNavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: LCMFontBook.bold.of(size: 18.0)]
        UIBarButtonItem.appearance().setTitleTextAttributes(
            [
                NSAttributedString.Key.font: LCMFontBook.bold.of(size: 15),
                NSAttributedString.Key.foregroundColor: UIColor.black,
            ],
            for: .normal)

        LCMTransparentNavigationBar.appearance().tintColor = .white
        LCMTransparentNavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: LCMFontBook.bold.of(size: 18.0),
                                                                        NSAttributedString.Key.foregroundColor: UIColor.white, ]

        LCMTransparentNavigationBar.appearance().barTintColor = UIColor.lcmDark
    }

    static func applyMobilePayBackgroundColor(toView view: UIView) {
        view.backgroundColor = UIColor.lcmDark
    }

    static func applyTheme(toTextView textView: LCMLinkTextView) {
        textView.backgroundColor = LCMColorIdentifier.dark.uiColor()
    }

    static func applyTheme(toCheckbox check: LCMCheckbox) {
        check.lineWidth = 4.0
        check.cornerRadius = 4.0
        check.animationDuration = 0.5
        check.boxType = .square
        check.onAnimationType = .bounce
        check.offAnimationType = .fade
        check.onTintColor = UIColor.lcmSunflowerYellow
        check.onFillColor = UIColor.lcmSunflowerYellow
        check.onCheckColor = UIColor.black
        check.offFillColor = UIColor.clear
        check.tintColor = UIColor.lcmSlateGray
    }

    static func applyTheme(toFormField formField: LCMFormField) {
        let textField = formField.field
        formField.backgroundColor = .clear
        textField.backgroundColor = LCMColorIdentifier.textFieldBackgroundColor.uiColor()
        textField.textColor = LCMColorIdentifier.textFieldTextColor.uiColor()
        textField.font = LCMFontBook.bold.of(size: 18.0)
        textField.borderStyle = .roundedRect
        if let text: String = textField.placeholder ,
           let textRange = text.nsRange(from: 0 ..< text.count) {
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: LCMColorIdentifier.color(.slateGray), range: textRange)
            textField.attributedPlaceholder = attributedText
        }
    }

    static func applyTheme(toDateField dateField: LCMDateField) {
        let formField = dateField as LCMFormField
        dateField.picker.backgroundColor = LCMColorIdentifier.dark.uiColor()
        dateField.picker.setValue(LCMColorIdentifier.white.uiColor(), forKey: "textColor")
        dateField.picker.setValue(false, forKeyPath: "highlightsToday")
        dateField.toolBar.barTintColor = LCMColorIdentifier.dark.uiColor()
        dateField.toolBar.tintColor = LCMColorIdentifier.white.uiColor()
        dateField.monthYearPicker.backgroundColor = LCMColorIdentifier.dark.uiColor()
    }

    static func applyTheme(toCreditCardField creditCardField: LCMCreditCardField) {
        let formField = creditCardField as LCMFormField
        formField.field.font = LCMFontBook.bold.of(size: 26.0)
        formField.field.backgroundColor = .clear
        formField.field.borderStyle = .none
        formField.field.clearButtonMode = .never
        formField.field.rightViewMode = .never
    }

    static func applyTheme(toPicker pickerField: LCMPicker) {
        let formField = pickerField as LCMFormField
        pickerField.picker.backgroundColor = LCMColorIdentifier.dark.uiColor()
        pickerField.toolBar.barTintColor = LCMColorIdentifier.dark.uiColor()
        pickerField.toolBar.tintColor = LCMColorIdentifier.white.uiColor()
    }

    static func applyTheme(toTextField textField: LCMTextField) {
        textField.backgroundColor = LCMColorIdentifier.textFieldBackgroundColor.uiColor()
        textField.textColor = LCMColorIdentifier.textFieldTextColor.uiColor()
        textField.font = LCMFontBook.bold.of(size: 18.0)
        textField.borderStyle = .roundedRect
        if let text: String = textField.placeholder,
            let textRange = text.nsRange(from: 0 ..< text.count) {
            let attributedText = NSMutableAttributedString(string: text)
            attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: LCMColorIdentifier.color(.slateGray), range: textRange)
            textField.attributedPlaceholder = attributedText
        }
    }

    static func applyTheme(toPasswordVisibilityToggle toggle: PasswordToggleVisibilityView) {
        toggle.tintColor = LCMColorIdentifier.coolGray.uiColor()
    }

    static func applyTheme(toFieldLabel label: LCMFieldLabel) {
        label.backgroundColor = .clear
        label.textColor = LCMColorIdentifier.coolGray.uiColor()
        label.font = LCMFontBook.bold.of(size: 18.0)
    }

    static func applyTheme(toErrorLabel label: LCMErrorLabel) {
        label.textColor = LCMColorIdentifier.error.uiColor()
        label.font = LCMFontBook.bold.of(size: 14.0)
    }

    static func applyTheme(toSecondaryButton button: LCMSecondaryButton) {
        button.lcmTextColor = .sunflowerYellow
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.cornerRadius = 4.0
        button.layer.masksToBounds = true
        button.layer.borderColor = LCMColorIdentifier.sunflowerYellow.uiColor().cgColor
    }
}

let UITableViewBackgroundViewTag = 1_000

extension UITableView {
    override func applyThemeToBackground() {

        if backgroundView != nil && backgroundView?.tag == UITableViewBackgroundViewTag {
            return
        }
        let themedBackgroundView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        themedBackgroundView.tag = UITableViewBackgroundViewTag
        themedBackgroundView.backgroundColor = LCMColorIdentifier.dark.uiColor()

        themedBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = themedBackgroundView
        backgroundColor = .clear
    }

    func setBackgroundImage(_ named: String) {
        let imageView = UIImageView(image: UIImage(named: named))
        imageView.contentMode = .scaleAspectFill
        backgroundView = imageView
    }
}

extension UICollectionView {
    override func applyThemeToBackground() {

        if backgroundView != nil && backgroundView?.tag == UITableViewBackgroundViewTag {
            return
        }
        let themedBackgroundView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: frame.size))
        themedBackgroundView.tag = UITableViewBackgroundViewTag
        themedBackgroundView.backgroundColor = LCMColorIdentifier.dark.uiColor()

        themedBackgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView = themedBackgroundView
        backgroundColor = .clear
    }
}

extension UIViewController {
    func applyThemeToBackground() {
        view.backgroundColor = LCMColorIdentifier.dark.uiColor()
    }
}

extension UIView {

    @objc func applyThemeToBackground() {
        backgroundColor = LCMColorIdentifier.dark.uiColor()
        tintColor = LCMColorIdentifier.coolGray.uiColor()
    }

    func applyThemeToBackground(_ withAlpha: CGFloat) {
        backgroundColor = LCMColorIdentifier.dark.uiColor().withAlphaComponent(withAlpha)
    }
}

extension Themeable where Self: LCMCheckbox {
    func applyTheme() {
        ThemeProvider.applyTheme(toCheckbox: self)
    }
}

extension Themeable where Self: LCMTextField {
    func applyTheme() {
        ThemeProvider.applyTheme(toTextField: self)
    }
}

extension Themeable where Self: PasswordToggleVisibilityView {
    func applyTheme() {
        ThemeProvider.applyTheme(toPasswordVisibilityToggle: self)
    }
}

extension Themeable where Self: LCMLinkTextView {
    func applyTheme() {
        ThemeProvider.applyTheme(toTextView: self)
    }
}

extension Themeable where Self: LCMFieldLabel {
    func applyTheme() {
        ThemeProvider.applyTheme(toFieldLabel: self)
    }
}

extension Themeable where Self: LCMErrorLabel {
    func applyTheme() {
        ThemeProvider.applyTheme(toErrorLabel: self)
    }
}

extension Themeable where Self: LCMSecondaryButton {
    func applyTheme() {
        ThemeProvider.applyTheme(toSecondaryButton: self)
    }
}
