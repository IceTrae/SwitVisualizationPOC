import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var queueGraph: MarchingCardsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        queueGraph.animateIn(Queue(users: 10, currentPosition: 5))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.queueGraph.updateQueue(Queue(users: 8, currentPosition: 3))
        }
        //queueGraph.queue = Queue(users: 2, currentPosition: 1)
    }
}

