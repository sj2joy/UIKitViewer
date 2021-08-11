//
//  ContentsView.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class ContentsView: UIView {
    
    private var object = UIView()
    private var provideType: ProvideObject = .UIView
    
    // MARK: Initialize
    
    init(objectType: ProvideObject) {
        super.init(frame: .zero)
        self.provideType = objectType
        self.setUI()
        self.setObject()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 16
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.backgroundColor = .white
    }
    
    private func setObject() {
        
        switch self.provideType {
        case .UIView:
            object = UIView()
            object.backgroundColor = .white
        case .UIButton:
            guard let button = self.provideType.getInstance() as? UIButton else { return }
            button.setTitle("Test Button", for: .normal)
            button.setTitleColor(.black, for: .normal)
            object = button
        case .UILabel:
            guard let label = self.provideType.getInstance() as? UILabel else { return }
            label.text = "Test Label"
            object = label
        case .UIStepper:
            guard let stepper = self.provideType.getInstance() as? UIStepper else { return }
            object = stepper
        case .UITextField:
            guard let textField = self.provideType.getInstance() as? UITextField else { return }
            textField.borderStyle = .roundedRect
            object = textField
        case .UISwitch:
            guard let `switch` = self.provideType.getInstance() as? UISwitch else { return }
            `switch`.isOn = false
            object = `switch`
        case .UITableView:
            guard let tableView = self.provideType.getInstance() as? UITableView else { return }
            tableView.dataSource = self
            tableView.delegate = self
            object = tableView
        case .UICollectionView:
            guard let collectionView = self.provideType.getInstance() as? UICollectionView else { return }
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
            collectionView.backgroundColor = .clear
            collectionView.dataSource = self
            collectionView.delegate = self
            object = collectionView
        case .UIImageView:
            guard let imageView = self.provideType.getInstance() as? UIImageView else { return }
            imageView.image = UIImage(named: "UIImageView")
            object = imageView
        case .UIPageControl:
            guard let pageControl = self.provideType.getInstance() as? UIPageControl else { return }
            pageControl.numberOfPages = 3
            pageControl.currentPage = 0
            pageControl.backgroundColor = .gray
            object = pageControl
        case .UISegmentedControl:
            guard let segmentedControl = self.provideType.getInstance() as? UISegmentedControl else { return }
            segmentedControl.selectedSegmentIndex = 0
            object = segmentedControl
        }
        
        self.addSubview(object)
        setupConstraintObject()
        object.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
    private func setupConstraintObject() {

      switch self.provideType {
      case .UILabel, .UIButton:
        object.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(self.snp.width).multipliedBy(0.5)
        }
      case .UITextField:
        object.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.5)
        }
      case .UIImageView, .UIView, .UITableView, .UICollectionView:
        object.snp.makeConstraints { make in
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.height.equalTo(self.snp.height).multipliedBy(0.9)
        }
      default:
        return
      }
      
    }
    //여기서부터 이어서 할것
    private func replaceTableViewStyle(to style: UITableView.Style) {
        self.object.removeConstraints(self.object.constraints)
        self.object.removeFromSuperview()
        
        let tableView = UITableView(frame: .zero, style: style)
        tableView.dataSource = self
        tableView.delegate = self
        self.object = tableView
        
        self.addSubview(self.object)
        object.snp.makeConstraints { make in
            make.centerX.equalTo(self.snp.centerX)
            make.centerY.equalTo(self.snp.centerY)
            make.width.equalTo(self.snp.width).multipliedBy(0.9)
            make.height.equalTo(self.snp.height).multipliedBy(0.9)
        }
        tableView.reloadData()
    }
    
}

//MARK: -  About Textfield
extension ContentsView {
    
    func configure(title: String) {
        switch self.provideType {
        case .UIButton:
            guard let button = self.object as? UIButton else { return }
            button.setTitle(title, for: .normal)
        case .UILabel:
            guard let label = self.object as? UILabel else { return }
            label.text = title
        case .UITextField:
            guard let textField = self.object as? UITextField else { return }
            textField.text = title
        default:
            return
        }
    }
}
// MARK: -  About Palette
extension ContentsView {
    
    enum SwitchColorType {
        case onTint, thumbTint
    }
    func configureSwitch(color: UIColor?, for type: SwitchColorType) {
        guard let `switch` = self.object as? UISwitch else { return }
        switch type {
        case .onTint:
            `switch`.onTintColor = color
        case .thumbTint:
            `switch`.thumbTintColor = color
        }
    }
    
    func configure(textColor color: UIColor?) {
        switch self.provideType {
        case .UIButton:
            guard let button = self.object as? UIButton else { return }
            button.setTitleColor(color, for: .normal)
        case .UILabel:
            guard let label = self.object as? UILabel else { return }
            label.textColor = color
        case .UITextField:
          guard let textField = self.object as? UITextField else { return }
          textField.textColor = color
        default:
          return
        }
    }
    
    func configureTableView(separatorColor color: UIColor?) {
        guard let tableView = self.object as? UITableView else { return }
        tableView.separatorColor = color
    }
    
    func configure(backgroundColor color: UIColor?) { self.object.backgroundColor = color }
    func configure(tintColor color: UIColor?) { self.object.tintColor = color }
    func configure(borderColor color: UIColor?) { self.object.layer.borderColor = color?.cgColor }
}

//MARK: -  About Toggle

extension ContentsView {
    
    func configureTextField(shouldDisplayPlaceholder display: Bool) {
        guard let textField = self.object as? UITextField else { return }
        textField.placeholder = display ? "placeholder" : ""
    }
    
    enum ImageType {
        case meanImage
        case background
        case increment, decrement, divider
    }
    
    func configure(shouldSetImage: Bool, for type: ImageType) {
        switch self.provideType {
        case .UIButton:
            guard let button = self.object as? UIButton else { return }
            switch type {
            case .meanImage:
                button.setImage(shouldSetImage ? UIImage(named: "UIImageView") : nil, for: .normal)
            case .background:
                button.setBackgroundImage(shouldSetImage ? UIImage(named: "UIImageView") : nil, for: .normal)
            default:
                return
            }
        case .UIStepper:
            guard let stepper = self.object as? UIStepper else { return }
            switch type {
            case .increment:
                stepper.setIncrementImage(shouldSetImage ? UIImage(named: "UIImageView") : nil, for: .normal)
            case .decrement:
                stepper.setDecrementImage(shouldSetImage ? UIImage(named: "UIImageView") : nil, for: .normal)
            case .divider:
                stepper.setDividerImage(shouldSetImage ? UIImage(named: "UIImageView") : nil,
                                        forLeftSegmentState: .normal,
                                        rightSegmentState: .normal)
            case .background:
                stepper.setBackgroundImage(shouldSetImage ? UIImage(named: "UIImageView") : nil, for: .normal)
            default:
                return
            }
        default:
            return
        }
    }
    
    func configure(isOn value: Bool) {
        guard let `switch` = self.object as? UISwitch else { return }
        `switch`.isOn = value
    }
    
    func configure(setOn value: Bool) {
        guard let `switch` = self.object as? UISwitch else { return }
        `switch`.setOn(value , animated: true)
    }
    
    func configure(hidden value: Bool) { self.object.isHidden = value }
    func configure(clipsToBounds value: Bool) { self.object.clipsToBounds = value }
}
// MARK:- About - Slider

extension ContentsView {
    
    func configureLabel(numberOfLines value: Float) {
        guard let label = self.object as? UILabel else { return }
        label.numberOfLines = Int(value)
    }
    
    enum CollectionViewLayoutType {
        case itemSize, lineSpacing, itemSpacing, sectionInset
        case headerSize, footerSize
    }
    
    func configureCollectionViewLayout(with value: Float, for type: CollectionViewLayoutType) {
        guard
            let collectionView = self.object as? UICollectionView,
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }
        
        let layoutValue = CGFloat(value)
        switch type {
        case .itemSize:
            layout.itemSize = CGSize(width: layoutValue, height: layoutValue)
        case .itemSpacing:
            layout.minimumInteritemSpacing = layoutValue
        case .lineSpacing:
            layout.minimumLineSpacing = layoutValue
        case .sectionInset:
            layout.sectionInset = UIEdgeInsets(
                top: layoutValue, left: layoutValue, bottom: layoutValue, right: layoutValue
            )
        default:
            return
        }
    }
    
    enum PageContrlValueType {
        case numberOfPages, currentPage
    }
    
    func configurePageControl(with value: Float, for type: PageContrlValueType) {
        guard let pageControl = self.object as? UIPageControl else { return }
        
        let value = Int(value)
        switch type {
        case .currentPage:
            pageControl.currentPage = value
        case .numberOfPages:
            pageControl.numberOfPages = value
        }
    }
    
    func configure(alpha value: Float) { self.object.alpha = CGFloat(value) }
    func configure(borderWidth value: Float) { self.object.layer.borderWidth = CGFloat(value) }
    func configure(cornerRadius value: Float) { self.object.layer.cornerRadius = CGFloat(value) }
    
}
// MARK:- About Select

extension ContentsView {
    func configure(contentMode mode: UIView.ContentMode) { self.object.contentMode = mode }
    
    func configure(tableViewStyle style: UITableView.Style) {
        self.replaceTableViewStyle(to: style)
    }
    
    func configure(textFieldBorderStyle style: UITextField.BorderStyle) {
        guard let textField = self.object as? UITextField else { return }
        textField.borderStyle = style
    }
    
    func configure(clearButtonMode mode: UITextField.ViewMode) {
        guard let textField = self.object as? UITextField else { return }
        textField.clearButtonMode = mode
    }
}
//MARK: - UITableViewDelegate, UITableViewDataSource
extension ContentsView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell()
        cell.textLabel?.text = "Section : \(indexPath.section), Row: \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ContentsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
    
    var itemColors: UIColor? {
        get {
            let colors: [UIColor] = [.systemTeal, .systemRed, .systemYellow, .black, .systemBlue]
            return colors.randomElement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = itemColors
        return cell
    }
}

// MARK:- UITextFieldDelegate

extension ContentsView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
