//
//  ProvideObject.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

struct ItemInfo {
  var name: String
  var objectProperties: [Property]
}

enum ProvideObject: String {
    case UIView
    case UIButton
    case UILabel
    case UISwitch
    case UIStepper
    case UITextField
    case UITableView
    case UICollectionView
    case UIImageView
    case UIPageControl
    case UISegmentedControl

    func getInstance() -> UIView? {
        guard let itemType = NSClassFromString(self.rawValue) else { return nil }
        switch self {
        case .UIView:
            guard let viewType = itemType as? UIView.Type else { return nil }
            return viewType.init()
        case .UILabel:
          guard let labelType = itemType as? UILabel.Type else { return nil }
          return labelType.init()
        case .UIButton:
          guard let buttonType = itemType as? UIButton.Type else { return nil }
            return buttonType.init(type: .system)
        case .UISwitch:
            guard let switchType = itemType as? UISwitch.Type else { return nil }
            return switchType.init()
        case .UIStepper:
            guard let stepperType = itemType as? UIStepper.Type else { return nil }
            return stepperType.init()
        case .UITextField:
            guard let textFieldType = itemType as? UITextField.Type else { return nil }
            return textFieldType.init()
        case .UITableView:
            guard let tableViewType = itemType as? UITableView.Type else { return nil }
            return tableViewType.init(frame: .zero, style: .grouped)
        case .UICollectionView:
            guard let collectionViewType = itemType as? UICollectionView.Type else { return nil }
            let layout = UICollectionViewFlowLayout()
            return collectionViewType.init(frame: .zero, collectionViewLayout: layout)
        case .UIImageView:
            guard let imageViewType = itemType as? UIImageView.Type else { return nil }
            return imageViewType.init(image: UIImage(named: "default"))
        case .UIPageControl:
            guard let pageControlType = itemType as? UIPageControl.Type else { return nil }
            return pageControlType.init()
        case .UISegmentedControl:
            guard let segmentedControlType = itemType as? UISegmentedControl.Type else { return nil }
            return segmentedControlType.init(items: ["First", "Second"])
        }
    }
    
        func getClass() -> AnyClass? {
            return NSClassFromString(self.rawValue)
        }
    
        func itemNameInheritance() -> [String] {
            guard var current = self.getClass() else { return []}
            var items = [String(describing: current)]
            guard items.first != "UIView" else { return items }
            
            while let superClass = current.superclass() {
              let itemName = String(describing: superClass)
              items.append(itemName)
              if itemName == "UIView" { return items }
              else { current = superClass }
            }
            return items
        }
    }

