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
            // Hücre arka planını ayarla
        self.backgroundColor = .white
            
            // Köşe yuvarlama
            self.layer.cornerRadius = 10
            self.layer.masksToBounds = false // Gölge düzgün görünmesi için `false`
            
            // Gölgelendirme
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 3)
            self.layer.shadowRadius = 6
            
            // Kenarlık (isteğe bağlı)
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
        }
    public func configure() {
        
        buttonOutlet.contentMode = .scaleAspectFill
        buttonOutlet.layer.cornerRadius = 12
        buttonOutlet.clipsToBounds = true
    }
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: "buttonsCellCollectionViewCell", bundle: nil)
    }


    @IBAction func buttonAction(_ sender: Any) {
    }
}
