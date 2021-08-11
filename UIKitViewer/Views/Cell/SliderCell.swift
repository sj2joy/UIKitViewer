//
//  SliderCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class SliderCell: UITableViewCell {
    
    weak var delegate: DelegateControlCell?
    static let identifier = "SliderCell"
    private let nameLabel = UILabel()
    private let slider = UISlider()
    private let valueLabel = UILabel()
    private var currentObject: ProvideObject = .UIView
    
    private var value: Float {
      get { return self.slider.value }
      set {
        self.valueLabel.text = String(format: "%.1f", newValue)
        self.slider.value = newValue
      }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        valueLabel.font = .systemFont(ofSize: 16)
        valueLabel.text = " 0 "
        
        slider.addTarget(self, action: #selector(changedSlider(_:)), for: .valueChanged)
        slider.minimumValue = 0
        slider.maximumValue = 50
        setConstraint()
    }
    
    struct Constraint {
        static let paddingX = 8
        static let paddingY = 16
        static let spacing = 8
    }
    
    func setConstraint() {
        let views = [nameLabel, slider, valueLabel]
        views.forEach {
            contentView.addSubview($0)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(Constraint.paddingY)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX)
            make.bottom.equalTo(nameLabel.snp.bottom)
        }
        
        slider.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constraint.spacing)
            make.leading.equalTo(contentView.snp.leading).offset(Constraint.paddingX)
            make.trailing.equalTo(contentView.snp.trailing).offset(-Constraint.paddingX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-Constraint.paddingY)
        }
    }
    
    func configure(title: String, from object: ProvideObject) {
        self.nameLabel.text = title
        self.currentObject = object
        
        if let sliderValues = ObjectManager.shared.values(for: title) as? SliderValueChanged {
          self.setSlider(valueType: .custom(sliderValues.value),
                           minValue: sliderValues.minValue,
                           maxValue: sliderValues.maxValue)
        }else {
          let sliderValues = self.initializeSlider(for: title)
          ObjectManager.shared.addValue(sliderValues, for: title)
        }
    }
    
    func relates(to propertyName: String) -> Bool {
      return self.nameLabel.text!.contains(propertyName)
    }
    
    @objc private func changedSlider(_ sender: UISlider) {
        self.value = sender.value
        ObjectManager.shared.updateSliderValue(sender.value, for: self.nameLabel.text ?? "")
        delegate?.cell?(self, valueForSlider: sender.value)
    }
    
    private enum SliderValue {
        case minimum
        case maximum
        case median
        case custom(Float)
    }
    
    private func setSlider(valueType: SliderValue, minValue: Float, maxValue: Float) {
        self.slider.minimumValue = minValue
        self.slider.maximumValue = maxValue
        
        let value: Float
        switch valueType {
        case .minimum:
            value = self.slider.minimumValue
        case .maximum:
            value = self.slider.maximumValue
        case .median:
            value = (self.slider.minimumValue + self.slider.maximumValue) / 2
        case .custom(let customValue):
            value = customValue
        }
        self.value = value
    }
    
    private func initializeSlider(for title: String) -> SliderValueChanged {
        switch title {
        case "alpha":
            self.setSlider(valueType: .maximum, minValue: 0, maxValue: 1)
        case "borderWidth":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 16)
        case "cornerRadius":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 100)
        case "itemSize":
            self.setSlider(valueType: .custom(50), minValue: 20, maxValue: 80)
        case "minimumLineSpacing":
            self.setSlider(valueType: .minimum, minValue: 10, maxValue: 32)
        case "minimumInteritemSpacing":
            self.setSlider(valueType: .minimum, minValue: 10, maxValue: 32)
        case "sectionInset":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 32)
        case "headerReferenceSize":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 0)
        case "footerReferenceSize":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 0)
        case "currentPage":
            self.setSlider(valueType: .minimum, minValue: 0, maxValue: 10)
        case "numberOfPages":
            self.setSlider(valueType: .minimum, minValue: 3, maxValue: 10)
        case "numberOfLines":
            self.setSlider(valueType: .custom(1), minValue: 0, maxValue: 5)
        default:
            print("Unknown")
            return (0, 0, 0)
        }
        return (self.slider.value, self.slider.minimumValue, self.slider.maximumValue)
    }
}
