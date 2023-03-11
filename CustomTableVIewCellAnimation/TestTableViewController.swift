
import UIKit

class TestTableViewController: UITableViewController, TestCellDelegate {
    
    private var cells: [TestTableViewCell] = []
    private var shouldAnimate = false
    private var textFieldIsEditing = false
    private var textValues = [IndexPath: String]()
    private var labelsData = Array(1...20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupKeyboardBehaviour()
        sortCellsArray()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labelsData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCell", for: indexPath) as! TestTableViewCell
        cell.delegate = self
        
        if let text = textValues[indexPath] {
            cell.textField.text = text
        } else {
            cell.textField.text = ""
        }
        cell.label.text = String(labelsData[indexPath.row])
        cells.append(cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TestTableViewCell, let index = cells.firstIndex(of: cell) {
            cells.remove(at: index)
        }
        if let cell = cell as? TestTableViewCell, !cells.contains(cell) {
            cells.append(cell)
        }
        sortCellsArray()
        if shouldAnimate {
            for cell in self.cells { cell.animateOut(withAnimation: false) }
        }
    }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TestTableViewCell, let index = cells.firstIndex(of: cell) {
            cells.remove(at: index)
            cell.animateIn()
        }
        sortCellsArray()
    }
    
    private func sortCellsArray() {
        cells = cells.sorted(by: {Int($0.label.text!)! < Int($1.label.text!)!})
    }
    
    internal func myTextFieldDidBeginEditing(in cell: TestTableViewCell) {
        shouldAnimate = true
        textFieldIsEditing = true
        for (index, cell) in cells.enumerated() {
            cell.animateOut(index: index)
        }
    }
    
    internal func myTextFieldDidEndEditing(in cell: TestTableViewCell) {
        shouldAnimate = false
        if !textFieldIsEditing { for cell in cells { cell.animateIn() } }
        
        if let indexPath = tableView.indexPath(for: cell), let text = cell.textField.text {
            textValues[indexPath] = text
        }
    }
    
    private func setupKeyboardBehaviour() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
    }
    
    @objc func viewTapped(sender: UITapGestureRecognizer) {
        view.endEditing(true)
        for cell in cells { cell.animateIn() }
    }
}
