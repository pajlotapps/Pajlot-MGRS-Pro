

import UIKit

class MainVC: UIViewController {

    @IBOutlet var helpView: UIVisualEffectView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print(UserDefaults.standard.bool(forKey: "seenHelpView") )
        if UserDefaults.standard.bool(forKey: "seenHelpView") == false {
            view.addSubview(helpView)
            helpView.frame = view.frame
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    
    
    @IBAction func closeHelpView(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            self.helpView.alpha = 0
        }) { (success) in
            self.helpView.removeFromSuperview()
            UserDefaults.standard.set(true, forKey: "seenHelpView")
        }
    }    
}
