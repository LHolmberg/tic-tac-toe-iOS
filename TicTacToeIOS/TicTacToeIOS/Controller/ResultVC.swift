import UIKit

class ResultVC: UIViewController {
    @IBOutlet weak var resultTxt: UILabel!
    
    var result: String = String()
    
    @IBAction func OkBtn(_ sender: Any) {
        let parent = self.parent as! Home
        parent.viewWillAppear(true)
        self.view.removeFromSuperview()
    }
    override func viewDidLoad() {
        resultTxt.text = self.result
    }
}
