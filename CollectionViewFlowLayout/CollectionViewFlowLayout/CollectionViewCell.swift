//
//  CollectionViewCell.swift
//  CollectionViewFlowLayout
//
//  Created by Tan Tan on 3/29/20.
//  Copyright © 2020 Tan Tan. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    
    }


}
