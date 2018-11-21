import QuartzCore
import UIKit

/*
 Shake animation support to any view
 */
extension UIView {
    @objc func shake() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.notificationOccurred(.error)
        UIView.shake(view: self)

    }

    func fadeIn(duration: TimeInterval = 0.7, delay: TimeInterval = 0.0, _ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }

    func fadeOut(duration: TimeInterval = 0.7, delay: TimeInterval = 0.0, _ completion: ((Bool) -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }

    static func shake(view: UIView) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.isRemovedOnCompletion = true
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        view.layer.add(animation, forKey: "shake")
    }

    func set(focus: Bool) {
        for child in subviews.reversed() {
            if focus {
                becomeFirstResponder()
            } else {
                resignFirstResponder()
            }

            child.set(focus: focus)
        }
    }

    static func animateBounce(view: UIView, completed: @escaping (() -> Swift.Void)) {
        weak var localView: UIView? = view
        UIView.animate(withDuration: 0.2 / 1.5, animations: {
            localView?.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2 / 2, animations: {
                localView?.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
            }, completion: { _ in
                UIView.animate(withDuration: 0.2 / 2, animations: {
                    localView?.transform = CGAffineTransform.identity
                }, completion: { _ in
                    completed()
                })
            })
        })
    }

    @discardableResult
    func fromNib<T: UIView>() -> T? {
        guard let contentView = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            // xib not loaded, or its top view is of the wrong type
            return nil
        }
        self.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.layoutAttachAll()
        return contentView
    }

    func layoutAttachAll(margin: CGFloat = 0.0) {
        layoutAttachAll(top: margin, trailing: margin, bottom: margin, leading: margin)
    }

    func layoutAttachAll(topBottom: CGFloat = 0.0, trailingLeading: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: topBottom)
        layoutAttachBottom(to: view, margin: topBottom)
        layoutAttachLeading(to: view, margin: trailingLeading)
        layoutAttachTrailing(to: view, margin: trailingLeading)
    }

    func layoutAttachAll(top: CGFloat = 0.0, trailing: CGFloat = 0.0, bottom: CGFloat = 0.0, leading: CGFloat = 0.0) {
        let view = superview
        layoutAttachTop(to: view, margin: top)
        layoutAttachBottom(to: view, margin: bottom)
        layoutAttachLeading(to: view, margin: leading)
        layoutAttachTrailing(to: view, margin: trailing)
    }

    func layoutSize(_ width: CGFloat?, by height: CGFloat?) {
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }

        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }

    func layoutCenterY(equalTo view: UIView? = nil) {
        guard let view = view ?? superview else {
            return
        }

        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func layoutCenterX(equalTo view: UIView? = nil) {
        guard let view = view ?? superview else {
            return
        }

        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    @discardableResult
    func layoutAttachTop(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = view == superview
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: isSuperview ? .top : .bottom, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)

        return constraint
    }

    /// attaches the bottom of the current view to the given view
    @discardableResult
    func layoutAttachBottom(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: isSuperview ? .bottom : .top, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)

        return constraint
    }

    /// attaches the leading edge of the current view to the given view
    @discardableResult
    func layoutAttachLeading(to: UIView? = nil, margin: CGFloat = 0.0) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: isSuperview ? .leading : .trailing, multiplier: 1.0, constant: margin)
        superview?.addConstraint(constraint)

        return constraint
    }

    /// attaches the trailing edge of the current view to the given view
    @discardableResult
    func layoutAttachTrailing(to: UIView? = nil, margin: CGFloat = 0.0, priority: UILayoutPriority? = nil) -> NSLayoutConstraint {

        let view: UIView? = to ?? superview
        let isSuperview = (view == superview) || false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: isSuperview ? .trailing : .leading, multiplier: 1.0, constant: -margin)
        if let priority = priority {
            constraint.priority = priority
        }
        superview?.addConstraint(constraint)

        return constraint
    }
}
