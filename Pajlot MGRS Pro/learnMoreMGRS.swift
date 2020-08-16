
import UIKit

class learnMoreMGRS: UIViewController {

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    override var prefersStatusBarHidden: Bool {
        return true

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func dissmissBtn(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
}
