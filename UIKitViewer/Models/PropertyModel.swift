//
//  PropertyModel.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import Foundation

enum ObjectType {
  case slider
  case palette
  case textField
  case toggle
  case select
}

struct Property {
  var name: String
  var objectType: ObjectType
}

var properties: [String: [Property]] = [
  "CALayer" : [
    Property(name: "borderWidth", objectType: .slider),
    Property(name: "borderColor", objectType: .palette),
    Property(name: "cornerRadius", objectType: .slider)
  ],
  "UIButton" : [
    Property(name: "setTitle", objectType: .textField),
    Property(name: "setTitleColor", objectType: .palette),
    Property(name: "setImage", objectType: .toggle),
    Property(name: "setBackgroundImage", objectType: .toggle)
  ],
  "UILabel" : [
    Property(name: "text", objectType: .textField),
    Property(name: "textColor", objectType: .palette),
    Property(name: "numberOfLines", objectType: .slider)
  ],
  "UIView" : [
    Property(name: "contentMode", objectType: .select),
    Property(name: "tintColor", objectType: .palette),
    Property(name: "backgroundColor", objectType: .palette),
    Property(name: "clipsToBounds", objectType: .toggle),
    Property(name: "alpha", objectType: .slider),
    Property(name: "isHidden", objectType: .toggle)
    ],
  "UISwitch" : [
    Property(name: "isOn", objectType: .toggle),
    Property(name: "setOn", objectType: .toggle),
    Property(name: "onTintColor", objectType: .palette),
    Property(name: "thumbTintColor", objectType: .palette),
  ],
  "UIStepper" : [
    Property(name: "setIncrementImage", objectType: .toggle),
    Property(name: "setDecrementImage", objectType: .toggle),
    Property(name: "setDividerImage", objectType: .toggle)
  ],
  "UITextField" : [
    Property(name: "textColor", objectType: .palette),
    Property(name: "placeholder", objectType: .toggle),
    Property(name: "borderStyle", objectType: .select),
    Property(name: "clearButtonMode", objectType: .select),
  ],
  "UITableView" : [
    Property(name: "style", objectType: .select),
    Property(name: "separatorColor", objectType: .palette),
  ],
  "UICollectionView" : [
    ],
  "UICollectionViewFlowLayout" : [
    Property(name: "itemSize", objectType: .slider),
    Property(name: "minimumLineSpacing", objectType: .slider),
    Property(name: "minimumInteritemSpacing",objectType: .slider),
    Property(name: "sectionInset", objectType: .slider),
    Property(name: "headerReferenceSize", objectType: .slider),
    Property(name: "footerReferenceSize", objectType: .slider),
    ],
  "UIImageView" : [
  ],
  "UIPageControl" : [
    Property(name: "currentPage", objectType: .slider),
    Property(name: "numberOfPages", objectType: .slider),
  ],
  "UISegmentedControl" : [
  ]
]
