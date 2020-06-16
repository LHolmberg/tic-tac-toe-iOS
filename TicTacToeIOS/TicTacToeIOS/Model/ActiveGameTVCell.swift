import UIKit

class ActiveGameTVCell: UITableViewCell {
    
    @IBOutlet weak var opponentTxt: UILabel!
    @IBOutlet weak var whosTurnTxt: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
