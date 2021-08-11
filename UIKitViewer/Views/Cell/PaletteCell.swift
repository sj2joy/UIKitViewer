//
//  PaletteCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class PaletteCell: UITableViewCell {
    
    static let identifier = "PaletteCell"
    
    weak var delegate: DelegateControlCell?
    
    private let colors: [UIColor] = [.systemBlue,
                                     .systemGreen,
                                     .systemTeal,
                                     .systemRed,
                                     .systemYellow,]
    private var colorButtons: [UIButton] = []
    private var currentObject: ProvideObject = .UIView
    let nameLabel = UILabel()
    private let stackView = UIStackView()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func setupUI() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        
        colors.forEach {
            let button = UIButton()
            button.backgroundColor = $0
            self.colorButtons.append(button)
        }
        
        colorButtons.forEach {
            $0.addTarget(self, action: #selector(touchedPaletteButton(_:)), for: .touchUpInside)
            $0.layer.cornerRadius = 8
        }
        self.setupConstraints()
    }
    
    struct Constraint {
        static let paddingY: CGFloat = 8
        static let paddingX: CGFloat = 16
        static let spacing: CGFloat = 8
    }
    
    private func setupConstraints() {

        colorButtons.forEach {
            stackView.addArrangedSubview($0)
                $0.widthAnchor.constraint(equalTo: $0.heightAnchor, multiplier: 1.0).isActive = true
        }
        
        let views = [nameLabel, stackView]
        views.forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constraint.spacing)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX * 2)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX * 2)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY * 2)
        }
    }
        
    @objc private func touchedPaletteButton(_ sender: UIButton) {
        self.delegate?.cell?(self, valueForColor: sender.backgroundColor)
    }
        
    func configure(title: String, from object: ProvideObject) {
        self.nameLabel.text = title
        self.currentObject = object
    }
    
    func relates(to propertyName: String) -> Bool {
      return self.nameLabel.text!.contains(propertyName)
    }
}
