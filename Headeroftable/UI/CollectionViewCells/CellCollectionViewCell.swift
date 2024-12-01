//
//  CellCollectionViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit

class CellCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var labelAbstract: UILabel!
    
    static let identifier = "CellCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCardStyle()
    }
    func setupCardStyle() {
            // Hücre arka planını ayarla
            self.backgroundColor = .white
            
            // Köşe yuvarlama
            self.layer.cornerRadius = 12
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
    public func configure(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
    }
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.4, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }

    static func nib() -> UINib {
        return UINib(nibName: "CellCollectionViewCell", bundle: nil)
    }

}
