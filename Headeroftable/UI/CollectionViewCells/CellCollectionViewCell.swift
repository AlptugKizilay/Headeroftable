//
//  CellCollectionViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit
import Kingfisher

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
    //    public func configure(with image: UIImage) {
    //        imageView.image = image
    //        imageView.contentMode = .scaleAspectFit
    //        imageView.layer.cornerRadius = 12
    //        imageView.clipsToBounds = true
    //    }
    func configure(with article: Article){
        labelTitle.text = article.title
        labelAbstract.text = article.abstract
        
        if let metadata = article.media.first?.mediaMetadata[2]{
            if let url = URL(string: metadata.url) {
                // Kingfisher ile resim yükle
                imageView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"), // Varsayılan görsel
                    options: [
                        .transition(.fade(0.3)), // Yumuşak geçiş
                        .cacheOriginalImage // Resmi önbelleğe al
                    ]
                )
            }
        } else {
            // Eğer resim yoksa placeholder göster
            imageView.image = UIImage(named: "placeholder")
        }
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        labelTitle.numberOfLines = 0
        labelAbstract.numberOfLines = 0
        labelTitle.lineBreakMode = .byWordWrapping
        labelAbstract.lineBreakMode = .byWordWrapping
        
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
