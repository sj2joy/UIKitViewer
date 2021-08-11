//
//  ToggleCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit
import SnapKit

class ToggleCell: UITableViewCell {
    
    static let identifier = "ToggleCell"
    weak var delegate: DelegateControlCell?
    private let nameLabel = UILabel()
    private let onOffSwitch = UISwitch()
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
        onOffSwitch.addTarget(self, action: #selector(changedSwitch(_:)), for: .valueChanged)
        setConstraint()
    }
    
    struct Constraint {
      static let paddingY: CGFloat = 16
      static let paddingX: CGFloat = 16
      static let spacing: CGFloat = 8
    }
    
    func setConstraint() {
        let views = [nameLabel, onOffSwitch]
        views.forEach {
            contentView.addSubview($0)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
        onOffSwitch.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
    }
    
    func configure(title: String, from object: ProvideObject) {
      self.nameLabel.text = title
      self.currentObject = object
      
      if let currentState = ObjectManager.shared.values(for: title) as? Bool {
        self.onOffSwitch.isOn = currentState
      }else {
        switch self.currentObject {
        case .UICollectionView, .UIView:
          self.onOffSwitch.isOn = true
        default:
          self.onOffSwitch.isOn = false
        }
        ObjectManager.shared.addValue(self.onOffSwitch.isOn, for: title)
      }
    }
    
    func relates(to propertyName: String) -> Bool {
      return self.nameLabel.text!.contains(propertyName)
    }
    
    @objc private func changedSwitch(_ sender: UISwitch) {
        ObjectManager.shared.addValue(sender.isOn, for: self.nameLabel.text!)
        self.delegate?.cell?(self, valueForToggle: sender.isOn)
    }
}
