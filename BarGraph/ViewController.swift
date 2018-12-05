import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var queueGraph: MarchingCardsView!
    @IBOutlet weak var userCountLabel: UILabel!
    @IBOutlet weak var userCountSlider: UISlider!
    @IBOutlet weak var currentPositionLabel: UILabel!
    @IBOutlet weak var currentPositionSlider: UISlider!

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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
    }

    @IBAction func resetCards(_ sender: Any) {
        users = 15
        currentPosition = 8
        queueGraph.removeCards()
        queueGraph.animateIn(Queue(users: users, currentPosition: currentPosition))
        hasAnimated = true
    }

    @IBAction func animateCards(_ sender: Any) {
        if hasAnimated {
            users -= 1
            currentPosition -= 1//currentPosition % 2 == 0 ? 1 : 3
        } else {
            queueGraph.animateIn(Queue(users: users, currentPosition: currentPosition))
        }

        hasAnimated = true
        queueGraph.updateQueue(Queue(users: users, currentPosition: currentPosition))
    }

    @IBAction func userCountChanged(_ sender: Any) {
        userCountLabel.text = "\(Int(userCountSlider.value))"
        hasAnimated = false
    }

    @IBAction func currentPositionChanged(_ sender: Any) {
        currentPositionLabel.text = "\(Int(currentPositionSlider.value))"
        hasAnimated = false
    }
}

