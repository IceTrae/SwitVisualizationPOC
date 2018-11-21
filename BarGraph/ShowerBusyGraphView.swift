import UIKit

class ShowerBusyGraphView: UIView {
    var columnWidth: CGFloat {
        var graphWidth = bounds.width
        graphWidth -= (2 * constants.graphMargin)
        return (graphWidth / CGFloat(data.count)) - constants.columnMargin
    }
    var columnRect: CGRect {
        let barSize = CGSize(width: columnWidth, height: constants.maxColumnHeight)
        let barOrigin = CGPoint(x: constants.graphMargin, y: bounds.minY + constants.topColumnMargin)
        return CGRect(origin: barOrigin, size: barSize)
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: 150)
    }

    let data = [
        ShowerHistoryItem(dayOfWeek: 1, hour: 0, usage: 0.5),
        ShowerHistoryItem(dayOfWeek: 1, hour: 1, usage: 0.75),
        ShowerHistoryItem(dayOfWeek: 1, hour: 2, usage: 0.25),
        ShowerHistoryItem(dayOfWeek: 1, hour: 3, usage: 1.0),
        ShowerHistoryItem(dayOfWeek: 1, hour: 4, usage: 0.85),
        ShowerHistoryItem(dayOfWeek: 1, hour: 5, usage: 0.75),
        ShowerHistoryItem(dayOfWeek: 1, hour: 6, usage: 0.65),
        ShowerHistoryItem(dayOfWeek: 1, hour: 7, usage: 0.55),
        ShowerHistoryItem(dayOfWeek: 1, hour: 8, usage: 0.5),
        ShowerHistoryItem(dayOfWeek: 1, hour: 9, usage: 0.4),
        ShowerHistoryItem(dayOfWeek: 1, hour: 10, usage: 0.35),
        ShowerHistoryItem(dayOfWeek: 1, hour: 11, usage: 0.3),
        ShowerHistoryItem(dayOfWeek: 1, hour: 12, usage: 0.2),
        ShowerHistoryItem(dayOfWeek: 1, hour: 13, usage: 0.1),
        ShowerHistoryItem(dayOfWeek: 1, hour: 14, usage: 0.0),
        ShowerHistoryItem(dayOfWeek: 1, hour: 15, usage: 0.1),
        ShowerHistoryItem(dayOfWeek: 1, hour: 16, usage: 0.1),
        ShowerHistoryItem(dayOfWeek: 1, hour: 17, usage: 0.2),
        ShowerHistoryItem(dayOfWeek: 1, hour: 18, usage: 0.3),
        ShowerHistoryItem(dayOfWeek: 1, hour: 19, usage: 0.4),
        ShowerHistoryItem(dayOfWeek: 1, hour: 20, usage: 0.5),
        ShowerHistoryItem(dayOfWeek: 1, hour: 21, usage: 0.6),
        ShowerHistoryItem(dayOfWeek: 1, hour: 22, usage: 0.7),
        ShowerHistoryItem(dayOfWeek: 1, hour: 23, usage: 0.85),
    ]

    override func draw(_: CGRect) {
        let origin = CGPoint.zero.offsetBy(dx: 0.0, dy: CGFloat(constants.graphHeight))
        let line = CGRect(origin: origin, size: CGSize(width: bounds.width, height: constants.graphBaseLineHeight))
        UIColor.gray.setFill()
        UIBezierPath(rect: line).fill()
        data.forEach {
            let totalColumnWidth = columnWidth + constants.columnMargin
            var bar = columnRect
            bar.size.height = constants.maxColumnHeight * CGFloat($0.usage)
            bar.origin = bar.origin.offsetBy(dx: CGFloat($0.hour)*totalColumnWidth, dy: constants.maxColumnHeight - bar.height)
            if $0.isCurrentTime {
                let  path = UIBezierPath()

                let  p0 = CGPoint(x: bar.midX, y: bar.origin.y)
                path.move(to: p0)

                let  p1 = CGPoint(x: bar.midX, y: constants.topColumnMargin - 10.0)
                path.addLine(to: p1)

                let  dashes: [CGFloat] = [ 4.0, 4.0 ]
                path.setLineDash(dashes, count: dashes.count, phase: 0.0)
                path.lineWidth = 1.0
                path.lineCapStyle = .round
                UIColor.lcmCoolGray.setStroke()
                path.stroke()
                let label = $0.currentTimeLabel
                let size = label.size()
                let origin = CGPoint(x: bar.midX - (size.width/2), y: bounds.minY)
                let labelRect = CGRect(origin: origin, size: size)
                label.draw(in: labelRect)
                let busyLabel = $0.busyLabel
                let busySize = busyLabel.size()
                let busyOrigin = CGPoint(x: bar.midX - (busySize.width/2), y: labelRect.maxY)
                let busyRect = CGRect(origin: busyOrigin, size: busySize)
                busyLabel.draw(in: busyRect)
            }
            guard $0.hour % 3 == 0 else {
                return
            }

            drawLabelForColumn(item: $0)
        }
    }

    override func layoutSubviews() {
        data.forEach {
            createColumn(item: $0)
        }
    }

    private func createColumn(item: ShowerHistoryItem) {
        let hour = item.hour
        let totalColumnWidth = columnWidth + constants.columnMargin
        var bar = columnRect
        bar.size.height = constants.maxColumnHeight * CGFloat(item.usage)
        bar.origin = bar.origin.offsetBy(dx: CGFloat(hour)*totalColumnWidth, dy: constants.maxColumnHeight - bar.height)
        let view = UIView(frame: bar)
        view.backgroundColor = .clear
        addSubview(view)
        let shapeLayer = CAShapeLayer()
        let layerRec = CGRect(origin: convert(bar.origin, to: view), size: bar.size)
        let rect = UIBezierPath(roundedRect: layerRec, byRoundingCorners: [.topRight, .topLeft], cornerRadii: CGSize(width: 2, height: 2))
        rect.lineWidth = 1.0
        shapeLayer.path = rect.cgPath
        shapeLayer.fillColor = (item.isCurrentTime ? UIColor.lcmSunflowerYellow : .lcmSlateGray).cgColor
        view.layer.addSublayer(shapeLayer)
    }

    private func drawLabelForColumn(item: ShowerHistoryItem) {
        let totalColumnWidth = columnWidth + constants.columnMargin
        var bar = columnRect
        bar.origin = bar.origin.offsetBy(dx: CGFloat(item.hour)*totalColumnWidth, dy: constants.topLabelMargin)
        let label = centeredAttributedString(item.labelText, fontSize: 11)
        let size = label.size()
        let origin = CGPoint(x: bar.minX - (size.width/2), y: bar.maxY)
        let rect = CGRect(origin: origin, size: size)
        label.draw(in: rect)
    }

    private func centeredAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString {
        let font = LCMFontBook.semiBold.of(size: 11)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: font,
            .foregroundColor: UIColor.lcmLightText,
        ]

        return NSAttributedString(string: string, attributes: attributes)
    }
}

extension ShowerBusyGraphView {
    struct constants {
        static let graphBaseLineHeight: CGFloat = 1.0
        static let graphMargin: CGFloat = 20.0
        static let columnMargin: CGFloat = 1.0
        static let maxColumnHeight: CGFloat = 55.0
        static let topLabelMargin: CGFloat = 7.0
        static let topColumnMargin: CGFloat = 45.0
        static var graphHeight: CGFloat {
            return maxColumnHeight + topColumnMargin
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}

struct ShowerHistoryItem {
    let dayOfWeek: Int
    let hour: Int
    let usage: Double

    var time: Date {
        var comp = DateComponents()
        comp.weekday = dayOfWeek + 1
        let date = Calendar.current.nextDate(after: Date(), matching: comp, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward) ?? Date()
        return Calendar.current.date(bySettingHour: hour, minute: 0, second: 0, of: date) ?? Date()
    }

    var labelText: String {
        let formatter = DateFormatter()
        formatter.amSymbol = "am"
        formatter.pmSymbol = "pm"
        formatter.dateFormat = "h\na"
        return formatter.string(from: time)
    }

    var isToday: Bool {
        return (Calendar.current.component(.weekday, from: Date()) - 1) == dayOfWeek
    }

    var isCurrentTime: Bool {
        guard isToday else {
            return false
        }

        return Calendar.current.component(.hour, from: Date()) == hour
    }

    var currentTimeLabel: NSAttributedString {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: LCMFontBook.regular.of(size: 11.0),
            .foregroundColor: UIColor.lcmCoolGray,
        ]
        return NSAttributedString(string: "Current \(formatter.string(from: Date()))", attributes: attributes)
    }

    var busyLabel: NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center

        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: paragraphStyle,
            .font: LCMFontBook.regular.of(size: 11.0),
            .foregroundColor: UIColor.lcmLightText,
        ]
        let label = usage > 0.5 ? "Usually Busy" : "Usually Not Busy"
        return NSAttributedString(string: label, attributes: attributes)
    }
}
