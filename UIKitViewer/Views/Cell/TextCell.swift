//
//  TextCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class TextCell: UITableViewCell {
    
    static let identifier = "TextCell"
    weak var delegate: DelegateControlCell?
    private let nameLabel = UILabel()
    private let textField = UITextField()
    private var currentObject: ProvideObject = .UIView

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        textField.borderStyle = .roundedRect
        textField.delegate = self
        setConstraint()
    }
    
    struct Constraint {
        static let paddingX: CGFloat = 8
        static let paddingY: CGFloat = 16
        static let spacing: CGFloat = 8
    }
    
    func setConstraint() {
        let views = [nameLabel, textField]
        views.forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.top)
            make.leading.equalTo(contentView.snp.centerX).offset(Constraint.paddingX)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX)
            make.bottom.equalTo(nameLabel.snp.bottom)
        }
    }
    
    func configure(title: String, from object: ProvideObject) {
        self.nameLabel.text = title
        self.currentObject = object
        
        if let text = ObjectManager.shared.values(for: title) as? String {
          self.textField.text = text
        } else {
          switch self.currentObject {
          case .UIButton:
            self.textField.text = "Test Button"
          case .UILabel:
            self.textField.text = "Test Label"
          default:
            break
          }
          ObjectManager.shared.addValue(self.textField.text!, for: title)
        }
    }
}

//MARK: - UITextFieldDelegate

extension TextCell: UITextFieldDelegate {
  func textFieldDidChangeSelection(_ textField: UITextField) {
    ObjectManager.shared.updateValue(textField.text!, for: self.nameLabel.text!)
    self.delegate?.cell?(self, valueForTextField: textField.text ?? "")
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
