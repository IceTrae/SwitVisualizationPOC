import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var queueGraph: MarchingCardsView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        queueGraph.animateIn(Queue(users: 3, currentPosition: 2))
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.queueGraph.updateQueue(Queue(users: 2, currentPosition: 1))
        }
        //queueGraph.queue = Queue(users: 2, currentPosition: 1)
    }
}

