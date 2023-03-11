
import UIKit

protocol TestCellDelegate {
    func myTextFieldDidBeginEditing(in cell: TestTableViewCell)
    func myTextFieldDidEndEditing(in cell: TestTableViewCell)
}

class TestTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconView: UIView!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var textFieldLeading: NSLayoutConstraint!
    @IBOutlet weak var iconViewBottom: NSLayoutConstraint!
    
    var delegate: TestCellDelegate?
    var textFieldLeadingConstraint: NSLayoutConstraint?
    var subLabelTopConstraint: NSLayoutConstraint?
    var textFieldStoryboardLeading: NSLayoutConstraint?
    var iconViewBottomConstraint: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func animateOut(withAnimation: Bool = true, index: Int = 0) {
        let animation = withAnimation ? 0.3 : 0.0
        let delay = Double(index) * 0.06
        
        UIView.animate(withDuration: animation) {
            self.label.alpha = 0
            self.layoutIfNeeded()
        } completion: { done in
            if done {
                UIView.animate(withDuration: animation) {
                    self.textFieldStoryboardLeading = self.textFieldLeading
                    self.textFieldStoryboardLeading?.isActive = false
                    self.textFieldLeadingConstraint?.isActive = false
                    self.textFieldLeadingConstraint = self.textField.leadingAnchor.constraint(equalTo: self.iconView.trailingAnchor, constant: 10)
                    self.textFieldLeadingConstraint?.isActive = true
                    self.layoutIfNeeded()
                }
                UIView.animate(withDuration: animation, delay: delay) {
                    self.iconViewBottomConstraint = self.iconViewBottom
                    self.iconViewBottomConstraint?.isActive = false
                    self.subLabelTopConstraint?.isActive = false
                    self.subLabelTopConstraint = self.subLabel.topAnchor.constraint(equalTo: self.iconView.centerYAnchor, constant: 10)
                    self.subLabelTopConstraint?.isActive = true
                    self.layoutIfNeeded()
                }
            }
        }
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.3) {
            self.textFieldLeadingConstraint?.isActive = false
            self.textFieldLeadingConstraint = self.textFieldLeading
            self.textFieldLeadingConstraint?.isActive = true
            self.label.alpha = 1
            self.textFieldStoryboardLeading = self.textFieldLeading
            self.textFieldStoryboardLeading?.isActive = true
            
            self.subLabelTopConstraint?.isActive = false
            self.subLabelTopConstraint = self.iconViewBottom
            self.subLabelTopConstraint?.isActive = true
            self.iconViewBottomConstraint = self.iconViewBottom
            self.iconViewBottomConstraint?.isActive = true
            
            self.layoutIfNeeded()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.myTextFieldDidBeginEditing(in: self)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.myTextFieldDidEndEditing(in: self)
    }
}
