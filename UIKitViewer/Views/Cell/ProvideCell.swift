//
//  ProvideCell.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

@objc protocol DelegateControlCell {
    @objc optional func cell(_ tableViewCell: UITableViewCell, valueForColor color: UIColor?)
    @objc optional func cell(_ tableViewCell: UITableViewCell, valueForSlider value: Float)
    @objc optional func cell(_ tableViewCell: UITableViewCell, valueForToggle value: Bool)
    @objc optional func cell(_ tableViewCell: UITableViewCell, valueForTextField text: String)
    @objc optional func cell(_ tableViewCell: UITableViewCell, valueForSelect values: [String])
}

class ProvideCell {
    
    weak var delegate: DelegateControlCell?
    
    func register(to tableView: UITableView) {
        tableView.register(SliderCell.self, forCellReuseIdentifier: SliderCell.identifier)
        tableView.register(PaletteCell.self, forCellReuseIdentifier: PaletteCell.identifier)
        tableView.register(ToggleCell.self, forCellReuseIdentifier: ToggleCell.identifier)
        tableView.register(TextCell.self, forCellReuseIdentifier: TextCell.identifier)
        tableView.register(SelectedCell.self, forCellReuseIdentifier: SelectedCell.identifier)
    }
    
    func create(to tableView: UITableView, with title: String, objectType object: ProvideObject, controlType control: ObjectType) -> UITableViewCell {
        switch control {
        case .slider:
            let cell = tableView.dequeueReusableCell(withIdentifier: SliderCell.identifier) as! SliderCell
            cell.configure(title: title, from: object)
            cell.delegate = self.delegate
            return cell
        case .palette:
            let cell = tableView.dequeueReusableCell(withIdentifier: PaletteCell.identifier) as! PaletteCell
            cell.configure(title: title, from: object)
            cell.delegate = self.delegate
            return cell
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.identifier) as! ToggleCell
            cell.configure(title: title, from: object)
            cell.delegate = self.delegate
            return cell
        case .textField:
            let cell = tableView.dequeueReusableCell(withIdentifier: TextCell.identifier) as! TextCell
            cell.configure(title: title, from: object)
            cell.delegate = self.delegate
            return cell
        case .select:
            let cell = tableView.dequeueReusableCell(withIdentifier: SelectedCell.identifier) as! SelectedCell
            cell.configure(title: title, from: object)
            cell.delegate = self.delegate
            return cell
        }
    }
}
