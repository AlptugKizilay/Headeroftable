//
//  buttonsCellCollectionViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit

class buttonsCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var buttonOutlet: UIButton!
    
    static let identifier = "buttonsCellCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
        
        // Initialization code
    }
    func setupCardStyle() {
        self.backgroundColor = .clear
        // self.layer.cornerRadius = 16
        self.layer.masksToBounds = false
        
        // Gölgelendirme
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 6
    }
    public func configure(with title: String, isSelected: Bool = false) {
        buttonOutlet.setTitle(title, for: .normal)
        buttonOutlet.setTitleColor(isSelected ? .white : .black, for: .normal)
        buttonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        buttonOutlet.backgroundColor = isSelected ? UIColor.red : UIColor.clear
        buttonOutlet.layer.cornerRadius = 16
        buttonOutlet.layer.borderWidth = isSelected ? 0 : 1
        buttonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        buttonOutlet.clipsToBounds = true
        
    }
    //    override var isHighlighted: Bool {
    //        didSet {
    //            UIView.animate(withDuration: 0.4, animations: {
    //                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
    //            })
    //        }
    //    }
    static func nib() -> UINib {
        return UINib(nibName: "buttonsCellCollectionViewCell", bundle: nil)
    }
    
}
