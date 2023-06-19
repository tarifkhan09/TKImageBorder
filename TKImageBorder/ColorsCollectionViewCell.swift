//
//  ColorsCollectionViewCell.swift
//  TKImageBorder
//
//  Created by MD Tarif khan on 19/6/23.
//

import UIKit

class ColorsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override var isSelected: Bool{
        didSet{
            if isSelected{
                contentView.layer.borderColor = UIColor.white.cgColor
                contentView.layer.cornerRadius = 10.0
                contentView.layer.borderWidth = 2.0
            } else {
                contentView.layer.borderColor = UIColor.clear.cgColor
                contentView.layer.cornerRadius = 5.0
            }
        }
    }
    
}
