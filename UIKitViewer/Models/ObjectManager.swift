//
//  ObjectManager.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

typealias SliderValueChanged = (value: Float, minValue: Float, maxValue: Float)

class ObjectManager {
    
    static let shared = ObjectManager()
    private init() {}
    var dataSource = [ItemInfo]()
    var object: ProvideObject = .UIButton {
        didSet {
            object.itemNameInheritance().forEach {
                let itemInfo = ItemInfo(name: $0, objectProperties: properties[$0] ?? [])
                self.dataSource.append(itemInfo)
            }
            
            let layer = properties.filter { $0.key == "CALayer" }.first
            let layerInfo = ItemInfo(name: layer?.key ?? "", objectProperties: layer?.value ?? [])
            self.dataSource.append(layerInfo)
            
            if object == .UICollectionView {
              let layout = properties.filter { $0.key == "UICollectionViewFlowLayout" }.first
              let itemInfo = ItemInfo(name: layout?.key ?? "", objectProperties: layout?.value ?? [])
              self.dataSource.insert(itemInfo, at: 1)
            }
        }
    }
    
    
    private var valuesForObjects = [String: Any]()
    
    func addValue(_ value: Any, for key: String) {
      self.valuesForObjects[key] = value
    }
    
    func updateValue(_ value: Any, for key: String) {
      self.valuesForObjects.updateValue(value, forKey: key)
    }
    
    func updateSliderValue(_ value: Float, for key: String) {
      guard var values = valuesForObjects[key] as? SliderValueChanged else { return }
      values.value = value
      self.valuesForObjects.updateValue(values, forKey: key)
    }
    
    func values(for key: String) -> Any? {
      return valuesForObjects[key]
    }
    
    func removeAllValues() {
      self.valuesForObjects.removeAll()
    }
    
}
