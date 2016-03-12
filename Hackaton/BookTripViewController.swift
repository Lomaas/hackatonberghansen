
import UIKit


protocol BookTripViewControllerDelegate: class
{
    func didConfirmTrip()
}

class BookTripViewController: UIViewController {
    weak var delegate: BookTripViewControllerDelegate?

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBAction func didPressConfirm(sender: AnyObject)
    {
        activityIndicatorView.startAnimating()
        let timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "update", userInfo: nil, repeats: true)

    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func update()
    {
        delegate?.didConfirmTrip()
    }
}
