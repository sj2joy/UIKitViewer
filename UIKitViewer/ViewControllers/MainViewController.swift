//
//  ViewController.swift
//  UIKitViewer
//
//  Created by Jang Seok jin on 2021/08/11.
//

import UIKit

class MainViewController: UIViewController {
    
    let objects = properties.keys
      .filter { $0 != "UICollectionViewFlowLayout" && $0 != "CALayer" }
      .sorted()
    let flowLayout = UICollectionViewFlowLayout()
    lazy var collectionView = UICollectionView()
    let manager = ObjectManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    struct Constraint {
      static let itemSpacing: CGFloat = 10.0
      static let lineSpacing: CGFloat = 10.0
    }
    
    private func setUI() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.title = "UIKit Viewer"
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        view.addSubview(collectionView)
 
        flowLayout.itemSize = CGSize(width: collectionView.frame.width / 2 - (Constraint.itemSpacing * 2.5),
                                     height: 180)
        flowLayout.minimumInteritemSpacing = Constraint.itemSpacing
        flowLayout.minimumLineSpacing = Constraint.lineSpacing
        flowLayout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return objects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as! MainCollectionViewCell
        cell.configure(title: objects[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = ProvideObject(rawValue: objects[indexPath.item]) else { return }
        let selectedVC = SelectedViewController()
        manager.object = items
        navigationController?.pushViewController(selectedVC, animated: true)
    }
}

