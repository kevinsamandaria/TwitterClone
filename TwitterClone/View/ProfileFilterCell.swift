//
//  ProfileFilterCell.swift
//  TwitterClone
//
//  Created by Kevin  Sam Andaria on 27/02/23.
//

import UIKit

class ProfileFilterCell: UICollectionViewCell {
    // -MARK: Properties
    var option: profileFilterOption! {
        didSet {
            titleLabel.text = option.description 
        }
    }
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .lightGray
        lbl.font = UIFont.systemFont(ofSize: 14)
        lbl.text = "Test Filter"
        
        return lbl
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .twitterBlue : .lightGray
        }
    }
    
    // -MARK: Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.center(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
