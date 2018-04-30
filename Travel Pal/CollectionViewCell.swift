//
//  CollectionViewCell.swift
//  Travel Pal
//
//  Created by Carli Casteel on 4/27/18.
//  Copyright © 2018 Carli Casteel. All rights reserved.
//

import UIKit

protocol CollectionViewCellDelegate: class {
    func delete(cell: CollectionViewCell)
}

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func layoutSubviews() {
        if deleteButton != nil {
            deleteButton.isHidden = true
        }
        if cellImageView != nil {
            cellImageView.frame = CGRect(x: 20, y: 10, width: self.frame.width - 40, height: self.frame.width - 40)
        }
        if cellLabel != nil {
            cellLabel.frame = CGRect(x: 10, y: cellImageView.frame.origin.y + cellImageView.frame.height + 5, width: self.frame.width - 20, height: 20)
            cellLabel.textAlignment = .center
        }
    }
    
    weak var delegate: CollectionViewCellDelegate?
    
    var imageName: String! {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            deleteButton.isHidden = !isEditing
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        delegate?.delete(cell: self)
    }
}
