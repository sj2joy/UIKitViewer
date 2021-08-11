//
//  SelectedViewController.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class SelectedViewController: UIViewController {

    private let provideCell = ProvideCell()
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let manager = ObjectManager.shared
    private lazy var contentsView = ContentsView(objectType: self.manager.object)

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        view.backgroundColor = UIColor(red: 242/255, green: 242/255, blue: 247/255, alpha: 1.0)
        navigationItem.title = manager.dataSource.first?.name
    }
    
    deinit {
        self.manager.dataSource.removeAll()
        self.manager.removeAllValues()
    }
    
    private func setUI() {
        contentsView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        provideCell.delegate = self
        provideCell.register(to: self.tableView)
        setContstraint()
    }
    
    private func setContstraint() {
        let views = [contentsView, tableView]
        views.forEach {
            view.addSubview($0)
        }
        
        let layoutGuide = self.view.safeAreaLayoutGuide

        contentsView.snp.makeConstraints { make in
            make.top.equalTo(layoutGuide.snp.top)
            make.leading.equalTo(layoutGuide.snp.leading)
            make.trailing.equalTo(layoutGuide.snp.trailing)
            make.height.equalTo(240)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.contentsView.snp.bottom)
            make.leading.equalTo(layoutGuide.snp.leading)
            make.trailing.equalTo(layoutGuide.snp.trailing)
            make.bottom.equalTo(layoutGuide.snp.bottom)
        }
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension SelectedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return manager.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      return manager.dataSource[section].name
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager.dataSource[section].objectProperties.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let property = manager.dataSource[indexPath.section].objectProperties[indexPath.row]
        let cell = self.provideCell.create(to: tableView, with: property.name, objectType: manager.object, controlType: property.objectType)
        return cell
    }
}

// MARK:- ControlCellDelegate

extension SelectedViewController: DelegateControlCell {
  
    func cell(_ tableViewCell: UITableViewCell, valueForColor color: UIColor?) {
      guard let cell = tableViewCell as? PaletteCell else { return }
      if cell.relates(to: "backgroundColor") {
        self.contentsView.configure(backgroundColor: color)
      }else if cell.relates(to: "tint") {
        self.contentsView.configure(tintColor: color)
      }else if cell.relates(to: "Title") || cell.relates(to: "text") {
        self.contentsView.configure(textColor: color)
      }else if cell.relates(to: "border") {
        self.contentsView.configure(borderColor: color)
      }else if cell.relates(to: "separator") {
        self.contentsView.configureTableView(separatorColor: color)
      }else if cell.relates(to: "onTint") {
        self.contentsView.configureSwitch(color: color, for: .onTint)
      }else if cell.relates(to: "thumbTint") {
        self.contentsView.configureSwitch(color: color, for: .thumbTint)
      }else {
        return
      }
    }
    
    func cell(_ tableViewCell: UITableViewCell, valueForToggle value: Bool) {
      guard let cell = tableViewCell as? ToggleCell else { return }
      if cell.relates(to: "setImage") {
        self.contentsView.configure(shouldSetImage: value, for: .meanImage)
      }else if cell.relates(to: "setBackgroundImage") {
        self.contentsView.configure(shouldSetImage: value, for: .background)
      }else if cell.relates(to: "isHidden"){
        self.contentsView.configure(hidden: value)
      }else if cell.relates(to: "clipsToBounds"){
        self.contentsView.configure(clipsToBounds: value)
      }else if cell.relates(to: "isOn") {
        self.contentsView.configure(isOn: value)
      }else if cell.relates(to: "setOn") {
        self.contentsView.configure(setOn: value)
      }else if cell.relates(to: "setDecrementImage") {
        self.contentsView.configure(shouldSetImage: value, for: .decrement)
      }else if cell.relates(to: "setIncrementImage") {
        self.contentsView.configure(shouldSetImage: value, for: .increment)
      }else if cell.relates(to: "setDividerImage") {
        self.contentsView.configure(shouldSetImage: value, for: .divider)
      }else if cell.relates(to: "placeholder") {
        self.contentsView.configureTextField(shouldDisplayPlaceholder: value)
      }else {
        return
      }
    }
    
    func cell(_ tableViewCell: UITableViewCell, valueForSlider value: Float) {
      guard let cell = tableViewCell as? SliderCell else { return }
      if cell.relates(to: "alpha") {
        self.contentsView.configure(alpha: value)
      }else if cell.relates(to: "borderWidth") {
        self.contentsView.configure(borderWidth: value)
      }else if cell.relates(to: "cornerRadius") {
        self.contentsView.configure(cornerRadius: value)
      }else if cell.relates(to: "itemSize") {
        self.contentsView.configureCollectionViewLayout(with: value, for: .itemSize)
      }else if cell.relates(to: "minimumInteritemSpacing") {
        self.contentsView.configureCollectionViewLayout(with: value, for: .itemSpacing)
      }else if cell.relates(to: "minimumLineSpacing") {
        self.contentsView.configureCollectionViewLayout(with: value, for: .lineSpacing)
      }else if cell.relates(to: "sectionInset") {
        self.contentsView.configureCollectionViewLayout(with: value, for: .sectionInset)
      }else if cell.relates(to: "currentPage") {
        self.contentsView.configurePageControl(with: value, for: .currentPage)
      }else if cell.relates(to: "numberOfPages") {
        self.contentsView.configurePageControl(with: value, for: .numberOfPages)
      }else if cell.relates(to: "numberOfLines") {
        self.contentsView.configureLabel(numberOfLines: value)
      }else {
        return
      }
    }
    
    func cell(_ tableViewCell: UITableViewCell, valueForTextField text: String) {
      self.contentsView.configure(title: text)
    }
    
    func cell(_ tableViewCell: UITableViewCell, valueForSelect values: [String]) {
      guard let cell = tableViewCell as? SelectedCell else { return }
      var actions = [UIAlertAction]()
      values.enumerated().forEach { (index, title) in
          let action = UIAlertAction(title: title, style: .default) { _ in
            cell.configure(selectedValue: title)
            self.configureCases(with: cell.currentProperty, at: index)
          }
          actions.append(action)
      }
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
      actions.append(cancelAction)
      
      let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      actions.forEach { alert.addAction($0) }
      present(alert, animated: true)
    }
    
    private func configureCases(with title: String, at index: Int) {
      switch title {
      case "contentMode":
        self.contentsView.configure(contentMode: UIView.ContentMode(rawValue: index) ?? .scaleToFill)
      case "style":
        self.contentsView.configure(tableViewStyle: UITableView.Style(rawValue: index) ?? .plain)
      case "borderStyle":
        self.contentsView.configure(textFieldBorderStyle: UITextField.BorderStyle(rawValue: index) ?? .none)
      case "clearButtonMode":
        self.contentsView.configure(clearButtonMode: UITextField.ViewMode(rawValue: index) ?? .never)
      default:
        return
      }
    }
}
