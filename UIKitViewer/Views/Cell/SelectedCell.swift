//
//  SelectedCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class SelectedCell: UITableViewCell {

    static let identifier = "SelectedCell"
    weak var delegate: DelegateControlCell?
    private let nameLabel = UILabel()
    private let selectedButton = UIButton()
    private var currentObject: ProvideObject = .UIView
    var currentProperty: String { return self.nameLabel.text ?? "" }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16)
        selectedButton.setTitle("More", for: .normal)
        selectedButton.setTitleColor(.black, for: .normal)
        selectedButton.backgroundColor = .white
        selectedButton.layer.borderColor = UIColor.black.cgColor
        selectedButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        setConstraint()
    }
    
    struct Constraint {
        static let paddingY: CGFloat = 8
        static let paddingX: CGFloat = 16
        static let spacing: CGFloat = 8
    }
    
    public func setConstraint() {
        let views = [nameLabel, selectedButton]
        views.forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
     
        selectedButton.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
    }
    
    private var cases = [String]()
    func configure(title: String, from object: ProvideObject) {
      self.nameLabel.text = title
      self.currentObject = object
      
      let initialTitle: String
      switch title {
      case "contentMode":
        initialTitle = UIView.ContentMode.scaleToFill.stringRepresentation
        self.cases = UIView.ContentMode.allCases.map { $0.stringRepresentation }
      case "style":
        initialTitle = UITableView.Style.plain.stringRepresentation
        self.cases = UITableView.Style.allCases.map { $0.stringRepresentation }
      case "borderStyle":
        initialTitle = UITextField.BorderStyle.none.stringRepresentation
        self.cases = UITextField.BorderStyle.allCases.map { $0.stringRepresentation }
      case "clearButtonMode":
        initialTitle = UITextField.ViewMode.never.stringRepresentation
        self.cases = UITextField.ViewMode.allCases.map { $0.stringRepresentation }
      default:
        return
      }
      self.selectedButton.setTitle(initialTitle, for: .normal)
    }
    
    func configure(selectedValue: String) {
        self.selectedButton.setTitle(selectedValue, for: .normal)
    }
    
    func relates(to propertyName: String) -> Bool {
      return self.nameLabel.text!.contains(propertyName)
    }

    @objc private func didTapButton(_ sender: UIButton) {
        self.delegate?.cell?(self, valueForSelect: self.cases)
    }
}
