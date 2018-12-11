import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var queueGraph: MarchingCardsView!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var userCountSlider: UISlider!
    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var currentPositionSlider: UISlider!
    @IBOutlet weak var coinView: CoinView!

    var currentPosition: Int {
        get {
            return Int(currentPositionSlider.value)
        }
        set {
            currentPositionSlider.value = Float(newValue)
            currentPositionLabel.text = "\(newValue)"
        }
    }

    var users: Int {
        get {
            return Int(userCountSlider.value)
        }
        set {
            userCountSlider.value = Float(newValue)
            userCountLabel.text = "\(newValue)"
        }
    }

    var hasAnimated = false

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @objc func flip(views: [UIView]) {
        guard views.count >= 2 else {
            return
        }

        let transitionOptions: UIView.AnimationOptions = [.transitionFlipFromLeft, .showHideTransitionViews]
        UIView.transition(from: views[0], to: views[1], duration: 0.4, options: transitionOptions) { complete in
            self.flip(views: views.reversed())
        }

//        UIView.transition(with: firstView, duration: 1.0, options: transitionOptions, animations: {
//            self.firstView.isHidden = true
//        }) { complete in
//            guard complete else {
//                return
//            }
//
//            UIView.transition(with: self.secondView, duration: 1.0, options: transitionOptions, animations: {
//                self.secondView.isHidden = false
//            })
//        }

        //UIView.transition(from: firstView, to: secondView, duration: 2.0, options: transitionOptions) { complete in

        //}
//        UIView.transition(with: firstView, duration: 1.0, options: transitionOptions, animations: {
//            self.firstView.isHidden = true
//        } )
//
//        UIView.transition(with: secondView, duration: 1.0, options: transitionOptions, animations: {
//            self.secondView.isHidden = false
//        })
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//        let views = [firstView!, secondView!]
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: { [weak self] in
//            self?.flip(views: views)
//        })
        //coinView.center.x = queueGraph.cardCenterX
    }

    @IBAction func resetCards(_ sender: Any) {
        queueGraph.removeCards()
        coinView.animate()
        coinView.position = currentPosition
        queueGraph.animateIn(Queue(users: users, currentPosition: currentPosition)) {
            self.coinView.stopAnimate()
        }
        hasAnimated = true
    }

    @IBAction func animateCards(_ sender: Any) {
        if hasAnimated {
//            users -= 1
//            currentPosition -= 1//currentPosition % 2 == 0 ? 1 : 3
        } else {
            resetCards("")
            return
        }

        hasAnimated = true
        coinView.animate()
        coinView.position = currentPosition
        queueGraph.updateQueue(Queue(users: users, currentPosition: currentPosition)) {
            self.coinView.stopAnimate()
        }
    }

    @IBAction func userCountChanged(_ sender: Any) {
        userCountLabel.text = "\(Int(userCountSlider.value))"
    }

    @IBAction func currentPositionChanged(_ sender: Any) {
        let currentPosition = Int(currentPositionSlider.value)
        currentPositionLabel.text = "\(currentPosition)"
    }
}

class CoinView: UIView {
    var currentPositionLabel: UILabel?
    var pointerView: UIView?
    var position: Int? {
        didSet {
            currentPositionLabel?.attributedText = getPositionText(position: position)
        }
    }
    var faceUp: Bool = true {
        didSet {
            currentPositionLabel?.isHidden = !faceUp
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    var shouldAnimate = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        createLabel()
        createPointer()
        borderColor = .lcmSunflowerYellow
    }

    func animate() {
        shouldAnimate = true
        pointerView?.isHidden = true
        spinView()
    }

    func stopAnimate() {
        shouldAnimate = false
    }

    func spinView() {
        UIView.transition(with: self, duration: 0.4, options: [.transitionFlipFromLeft], animations: {
            self.faceUp = !self.faceUp
            self.currentPositionLabel?.alpha = self.shouldAnimate ? 0 : 1
        }) { complete in
            guard self.shouldAnimate else {
                if !self.faceUp {
                    self.spinView()
                    return
                }
                self.currentPositionLabel?.alpha = 1
                self.pointerView?.isHidden = false
                return
            }

            self.spinView()
        }
    }

    private func createLabel() {
        let label = UILabel()
        currentPositionLabel = label
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layoutCenterX()
        label.layoutCenterY()
    }

    private func createPointer() {
        let pointer = UIView()
        pointer.translatesAutoresizingMaskIntoConstraints = false
        pointer.backgroundColor = .lcmSunflowerYellow
        addSubview(pointer)
        pointer.layoutCenterX()
        pointer.topAnchor.constraint(equalToSystemSpacingBelow: self.bottomAnchor, multiplier: 0).isActive = true
        pointer.layoutSize(5.0, by: 22.0)
        pointerView = pointer
    }

    private func getPositionText(position: Int?) -> NSMutableAttributedString? {
        guard let position = position else {
            return nil
        }

        let attributedString = NSMutableAttributedString(string: "#\(position)", attributes: [
            .font: LCMFontBook.extraBold.of(size: 57.6),
            .foregroundColor: UIColor(white: 1.0, alpha: 1.0),
            .kern: 0.0
            ])
        attributedString.addAttribute(
            .font,
            value: LCMFontBook.regular.of(size: 28.08),
            range: NSRange(location: 0, length: 1))
        return attributedString
    }
}

