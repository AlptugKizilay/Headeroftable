//
//  CellTableViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit
import RxSwift
import Kingfisher

class CellTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var article: Article? {
        didSet {
            updateUI() // article atandığında UI'yi güncelle
        }
    }
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // UI'yi güncellemek için bir fonksiyon
    private func updateUI() {
        guard let article else { return }
        titleLabel.text = article.title
        authorLabel.text = article.byline
        dateLabel.text = article.publishedDate
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = 12
        imgView.clipsToBounds = true
        
        labelConfig(label: titleLabel)
        labelConfig(label: authorLabel)
        labelConfig(label: dateLabel)

        // Resim yükleme (Kingfisher ile)
        if let media = article.media.first,
               media.mediaMetadata.count > 2, // En az 3 eleman olup olmadığını kontrol et
               let url = URL(string: media.mediaMetadata[2].url) { // Üçüncü elemanın URL'sini al
                // Kingfisher ile resim yükle
                imgView.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"), // Varsayılan görsel
                    options: [
                        .transition(.fade(0.3)), // Yumuşak geçiş
                        .cacheOriginalImage // Resmi önbelleğe al
                    ]
                )
            } else {
                // Görsel bulunamazsa varsayılan bir görsel ayarla
                imgView.image = UIImage(named: "news")
            }
        func labelConfig(label : UILabel) {
            label.layer.shadowColor = UIColor.black.cgColor
            label.layer.shadowOpacity = 0.7
            label.layer.shadowOffset = CGSize(width: 1, height: 1)
            label.layer.shadowRadius = 2
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 0
            
            label.textColor = .white
            if label == titleLabel {
                label.font = UIFont.boldSystemFont(ofSize: 16)

            }else {
                label.font = UIFont.systemFont(ofSize: 11)

                
            }
            
            
        }
        
    
    }
}

