//
//  CollectionViewController.swift
//  CollectionViewFlowLayout
//
//  Created by Tan Tan on 3/29/20.
//  Copyright © 2020 Tan Tan. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource {
 
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = AlbumCollectionViewLayout()
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.register(UINib(nibName: "CollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "cellId")
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 61
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        cell.label.text = "\(indexPath.row)"
        return cell
    }
    
    
    
}


