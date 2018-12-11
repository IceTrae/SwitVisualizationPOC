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
    var startLocation: Int {
        return columns / 2
    }
    var columnWidth: CGFloat {
        return (bounds.width / 6.4) - margin
    }

    var midpoint: CGFloat {
        return CGFloat(floor(Float(columns / 2)))
    }

    var cardCenterX: CGFloat {
        return positions[0]?.midX ?? frame.midX
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
    }

    func animateIn(_ queue: Queue, completion: (() -> Void)? = nil) {
        guard queue.currentPosition <= queue.users else {
            return
        }

        layoutIfNeeded()
        removeCards()
        self.queue = queue
        cards = Array(1...queue.users).map({ createView(location: startLocation, position: $0) })
        animateIn(completion: completion)
    }

    func animateIn(completion: (() -> Void)? = nil) {
        let allCards = cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
        var cardsToMove: [CardView] = allCards.filter({ $0.currentLocation != startLocation})
        if let nextCard = allCards.first(where: { $0.currentLocation == startLocation }) {
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
                    self?.animateIn(completion: completion)
                } else {
                    completion?()
                }
            })
    }

    func updateQueue(_ newQueue: Queue, completion: (() -> Void)? = nil) {
        guard newQueue.currentPosition <= newQueue.users else {
            removeCards(completion: completion)
            return
        }

        guard let queue = queue else {
            animateIn(newQueue, completion: completion)
            return
        }

        marchCards(stepCount: queue.currentPosition - newQueue.currentPosition) {
            self.adjustCards(cardsCount: queue.users - newQueue.users) {
                self.queue = newQueue
                completion?()
            }
        }
    }

    func marchCards(stepCount: Int, completion: @escaping () -> ()) {
        guard stepCount != 0 else {
            completion()
            return
        }

        let direction: AnimationDirection = stepCount > 0 ? .left : .right
        let addend = stepCount.signum() * -1
        UIView.animate(
            withDuration: 0.5,
            delay: 0.0,
            options: [.curveEaseInOut, .allowUserInteraction],
            animations: {
                self.cards.forEach({
                    self.viewAnimate(view: $0, direction: direction)
                })
        },
            completion: { [weak self] finished in
                self?.marchCards(stepCount: stepCount + addend, completion: completion)
        })
    }

    func adjustCards(cardsCount: Int, completion: (() -> Void)? = nil) {
        guard cardsCount != 0 else {
            completion?()
            return
        }

        if cardsCount < 0 {
            addCards(count: abs(cardsCount), completion: completion)
        } else {
            dropCards(count: cardsCount, completion: completion)
        }
    }

    func addCards(count: Int, completion: (() -> Void)? = nil) {
        let lastPosition = sortedCards.last?.linePosition ?? 1
        let newLastPosition = lastPosition + count
        let newCards = Array(lastPosition + 1...newLastPosition).map({ self.createView(location: startLocation, position: $0) })
        self.viewsAnimate(cards: newCards, direction: .right, completion: completion)
    }

    func dropCards(count: Int, completion: (() -> Void)? = nil) {
        let dropIndex = self.sortedCards.count - count
        let dropCards = Array(self.cards[dropIndex...])
        self.cards = Array(self.cards[..<dropIndex])
        self.removeCards(cards: dropCards, completion: completion)
    }

    func viewsAnimate(cards: [CardView], direction: AnimationDirection, completion: (() -> Void)? = nil) {
        let allCards = self.sortedCards
        let newCards = cards.sorted(by: { $0.linePosition ?? 0 < $1.linePosition ?? 0 })
        let target = (allCards.last?.currentLocation ?? 1) + 1
        var cardsToMove: [CardView] = newCards.filter({ $0.currentLocation != startLocation})
        if let nextCard = newCards.first(where: { $0.currentLocation == startLocation }) {
            cardsToMove.append(nextCard)
        }
        guard target < startLocation else {
            completion?()
            return
        }

        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: [.curveLinear, .allowUserInteraction],
            animations: {
                cardsToMove.forEach({
                    self.viewAnimate(view: $0, direction: direction)
                })
            },
            completion: { [weak self] finished in
                if (newCards.first(where: { $0.currentLocation == target }) == nil) {
                    self?.viewsAnimate(cards: newCards, direction: direction, completion: completion)
                } else {
                    self?.cards.append(contentsOf: newCards)
                    completion?()
                }
            })
    }

    func removeCards(completion: (() -> Void)? = nil) {
        queue = nil
        removeCards(cards: cards, completion: completion)
    }

    func removeCards(cards: [CardView], completion: (() -> Void)? = nil) {
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
                completion?()
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
            offset = offset - width - margin - (calculateWidth(for: 1) / 2)
        }
        if index == 1 {
            offset = offset - margin - width / 2
        }

        offset = offset + cards.reduce(0) { (result, i) -> CGFloat in
            var offsetValue: CGFloat = 0
            let width = columnWidth * (1 - abs(midpoint - i) * 0.1)
            if i == 0 {
                offsetValue = offsetValue - (width)
            }
            if i == 1 {
                offsetValue = offsetValue - margin - (width / 2)
            }
            return result + offsetValue + margin + width
        }

        let height = width * 1.18
        let bar = CGRect(x: offset - 2.5, y: maxHeight - height, width: width, height: height)

//        let shapeLayer = CAShapeLayer()
//        let rect = UIBezierPath(rect: bar)
//        rect.lineWidth = 1.0
//        shapeLayer.path = rect.cgPath
//        shapeLayer.fillColor = UIColor.red.cgColor
//        layer.addSublayer(shapeLayer)

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
        view.backgroundColor = .lcmCoolGray
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
        guard location != 0 else {
            return 1
        }

        let cardsPerSide = startLocation - 1
        let target = abs(location)
        guard target > 0 else {
            return 0.9
        }

        return 1 - Array(1...target).map({ max(CGFloat(cardsPerSide - $0) / 10, 0) }).reduce(0, +)
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

