import UIKit
struct Queue {
    let users: Int
    let currentPosition: Int
}
class MarchingCardsView: UIView {
    let margin: CGFloat = 2
    let columns = 11
    var maxHeight: CGFloat {
        return columnWidth * 1.18
    }
    var queue: Queue?
    let queuePosition = 2
    var columnWidth: CGFloat {
        return (bounds.width / 6.4) - margin
    }

    var midpoint: CGFloat {
        return CGFloat(floor(Float(columns / 2)))
    }

    var positions: [Int: CGRect] = [:]
    var cards: [CardView] = []
    var sortedCards: [CardView] {
        return cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: maxHeight)
    }

    override func layoutSubviews() {
        for n in 0..<columns {
            createLocations(index: n)
        }

        //for v in 1..<usersInQueue {
            //if let position = positions[0] {

//                cards[1] = createView(position: 3)
//                cards[2] = createView(position: 4)
//                cards[3] = createView(position: 5)
           // }
       // }

//        guard let view = cards[1], let view2 = cards[2], let view3 = cards[3] else {
//            return
//        }

//        UIView.animate(withDuration: 1.0,
//                       delay: 2.0,
//                       options: [.curveEaseInOut , .allowUserInteraction],
//                       animations: {
//                            self.cards.forEach({
//                                self.viewAnimate(view: $0, direction: .left)
//                            })
////                            self.viewAnimate(view: view, destination: 2)
////                            self.viewAnimate(view: view2, destination: 3)
////                            self.viewAnimate(view: view3, destination: 4)
//                       //                        view.frame = self.positions[3]!
////                        //view.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
////                        //                            view.center = CGPoint(x: view.center.x + view.frame.width, y: view.center.y)
////                        view.alpha = 0.6
//
//                       },
//                       completion: { finished in
//                       })

//        CATransaction.begin()
//        CATransaction.setAnimationDuration(1.0)
//        view.shapeLayer.mask?.position = self.positions[2]!.origin;
//        view.shapeLayer.mask?.bounds = self.positions[2]!;
//        view2.shapeLayer.mask?.position = self.positions[3]!.origin;
//        view2.shapeLayer.mask?.bounds = self.positions[3]!;
//        //CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.eas.easeInEaseOut)
//        //CATransaction.setAnimationTimingFunction(animation.timingFunction)
//        CATransaction.commit()
    }

    func animateIn(_ queue: Queue) {
        self.queue = queue
        layoutIfNeeded()
        removeCards()
        cards = Array(1...queue.users).map({ createView(location: 5, position: $0) })
        animateIn()
    }

    func animateIn() {
        let allCards = cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
        var cardsToMove: [CardView] = allCards.filter({ $0.currentLocation != 5})
        if let nextCard = allCards.first(where: { $0.currentLocation == 5 }) {
            cardsToMove.append(nextCard)
        }

        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                cardsToMove.forEach({
                    self.viewAnimate(view: $0, direction: .right)
                })
            },
            completion: { [weak self] finished in
                if (cardsToMove.first(where: { $0.linePosition == self?.queue?.currentPosition && $0.currentLocation == 0 }) == nil) {
                    self?.animateIn()
                }
            })
    }

    func updateQueue(_ newQueue: Queue) {
        guard let queue = queue else {
            animateIn(newQueue)
            return
        }

        let queueDiff = queue.users - newQueue.users
        print("Queue difference: \(queueDiff)")
        if queue.currentPosition != newQueue.currentPosition {
            UIView.animate(
                withDuration: 1.0,
                delay: 0.0,
                options: [.curveEaseInOut, .allowUserInteraction],
                animations: {
                    self.cards.forEach({
                        self.viewAnimate(view: $0, direction: .left)
                    })
            },
            completion: { [weak self] finished in
                guard let self = self else {
                    return
                }

                if queueDiff > 0 {
                    let dropIndex = self.sortedCards.count - queueDiff
                    let dropCards = Array(self.cards[dropIndex...])
                    self.removeCards(cards: dropCards)
                    self.cards = Array(self.cards[..<dropIndex])
                }

                if queueDiff < 0 { // queue diff represents the number of new cards to be made
                    let lastPosition = self.sortedCards.last?.linePosition ?? 1
                    let newLastPosition = lastPosition + abs(queueDiff)
                    let newCards = Array(lastPosition...newLastPosition).map({ self.createView(location: 5, position: $0) })
                    self.viewsAnimate(cards: newCards, direction: .right)
                    self.cards.append(contentsOf: newCards)
                }

                self.queue = newQueue
            })
        }
        

    }

    func viewsAnimate(cards: [CardView], direction: AnimationDirection) {
        let allCards = self.cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
        let newCards = cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
        let target = allCards.last?.linePosition
        var cardsToMove: [CardView] = newCards.filter({ $0.currentLocation != 5})
        if let nextCard = newCards.first(where: { $0.currentLocation == 5 }) {
            cardsToMove.append(nextCard)
        }
        guard let targetPostion = target, target ?? 5 < 5 else {
            return
        }
        UIView.animate(
            withDuration: 0.3,
            delay: 0.0,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                cardsToMove.forEach({
                    self.viewAnimate(view: $0, direction: direction)
                })
        },
            completion: { [weak self] finished in

                if (cards.first(where: { $0.currentLocation == targetPostion }) == nil) {
                    print("animate again")
                    self?.viewsAnimate(cards: newCards, direction: direction)
                }
        })
    }

    func removeCards() {
        removeCards(cards: cards)
    }

    func removeCards(cards: [CardView]) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                cards.forEach({
                    $0.alpha = 0
                    $0.frame = CGRect(x: $0.frame.midX, y: $0.frame.midY, width: 0, height: 0)
                })
        },
            completion: { finished in
                cards.forEach({ $0.removeFromSuperview() })
        })
    }

    func viewAnimate(view: CardView, direction: AnimationDirection) {
        let modifier = direction == .right ? -1 : 1
        let nextLocation = view.currentLocation + modifier
        view.currentLocation = nextLocation
        guard let destination = positions[nextLocation] else {
            view.alpha = 0
            return
        }

        view.frame = destination
        view.alpha = getAlpha(for: nextLocation)
    }

    func createLocations(index: Int) {
        let position = midpoint - CGFloat(index)
        let width = calculateWidth(for: index)
        let cards: [CGFloat] = Array(0..<Int(index)).map({ CGFloat($0) })
        var offset: CGFloat = 0
        if index == 0 {
            offset = offset - width - (calculateWidth(for: 1) / 2)
        }
        if index == 1 {
            offset = offset - width / 2
        }

        offset = offset + cards.reduce(0) { (result, i) -> CGFloat in
            var offsetValue: CGFloat = 0
            let width = columnWidth * (1 - abs(midpoint - i) * 0.1)
            if i == 0 {
                offsetValue = offsetValue - (width)
            }
            if i == 1 {
                offsetValue = offsetValue - (width / 2)
            }
            return result + offsetValue + margin + width
        }

        let height = width * 1.18
        let bar = CGRect(x: offset, y: maxHeight - height, width: width, height: height)
        positions[Int(position)] = bar
    }

    func calculateWidth(for location: Int) -> CGFloat {
        let position = midpoint - CGFloat(location)
        let multiplier: CGFloat = abs(position)
        return columnWidth * (1 - multiplier * 0.1)
    }

    func createView(location: Int, position: Int) -> CardView {
        let rect = positions[location]!
        let view = CardView(frame: rect)
        view.alpha = getAlpha(for: location)
        view.currentLocation = location
        view.linePosition = position
        view.backgroundColor = .white
        addSubview(view)
//        let shapeLayer = CAShapeLayer()
//        let layerRec = CGRect(origin: convert(rect.origin, to: view), size: rect.size)
//        let pathRect = UIBezierPath(roundedRect: layerRec, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8))
//        shapeLayer.path = pathRect.cgPath
//        shapeLayer.fillColor = UIColor.blue.cgColor
//        view.layer.addSublayer(shapeLayer)
        return view
        //view.transform = CGAffineTransform(scaleX: 1.0 - (multiplier * 0.1), y: 1.0 - (multiplier * 0.1))
    }

    func getAlpha(for location: Int) -> CGFloat {
        return 1 - CGFloat(abs(location)) * 0.2
    }
}

enum AnimationDirection {
    case left
    case right
}

class CardView: UIView {
    var currentLocation: Int = 5
    var linePosition: Int?
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }

    func initCommon() {
        layer.cornerRadius = 8.0
//        let rect = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8))
//        let shapeLayer = CAShapeLayer()
//        shapeLayer.path = rect.cgPath
//        shapeLayer.fillColor = UIColor.white.cgColor
//        self.layer.mask = shapeLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
////        // If the view is animating apply the animation to the sublayer
//        CATransaction.begin()
//        if let animation = layer.animation(forKey: "bounds") {
//
////            let pathAnimation = CABasicAnimation(keyPath: "path")
////            pathAnimation.toValue = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
////            pathAnimation.duration = animation.duration
////            pathAnimation.timingFunction = animation.timingFunction
////            shapeLayer.add(pathAnimation, forKey: pathAnimation.keyPath)
//            CATransaction.setAnimationDuration(animation.duration)
//            CATransaction.setAnimationTimingFunction(animation.timingFunction)
//        }
//        else {
//            CATransaction.disableActions()
//        }
//
//        layer.mask?.bounds = layer.bounds
//
//        CATransaction.commit()

    }
}

