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
        self.layer.masksToBounds = false
        
        // Gölgelendirme
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowRadius = 6
    }
    public func configure(with title: String, isSelected: Bool = false) {
        buttonOutlet.setTitle(title, for: .normal)
        buttonOutlet.setTitleColor(isSelected ? .white : UIColor(named: "mainColor"), for: .normal)
        buttonOutlet.backgroundColor = isSelected ? UIColor(named: "mainColor") : UIColor.clear
        buttonOutlet.layer.cornerRadius = 16
        buttonOutlet.layer.borderWidth = isSelected ? 0 : 1
        buttonOutlet.layer.borderColor = UIColor.lightGray.cgColor
        buttonOutlet.clipsToBounds = true
        buttonOutlet.titleLabel?.font = UIFont.systemFont(ofSize: 6, weight: .medium)
        buttonOutlet.titleLabel?.adjustsFontForContentSizeCategory = false


    }
    override var isHighlighted: Bool {
        didSet {
            UIButton.animate(withDuration: 0.2, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.95, y: 0.95) : .identity
            })
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: "buttonsCellCollectionViewCell", bundle: nil)
    }
    
}
