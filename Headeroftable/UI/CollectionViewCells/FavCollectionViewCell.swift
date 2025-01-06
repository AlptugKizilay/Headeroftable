import UIKit

class FavCollectionViewCell: UICollectionViewCell {
    static let identifier = "FavCollectionViewCell"
    
    public let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.numberOfLines = 0 // Çok satırlı metin
        label.textColor = .black
        return label
    }()
    
    public let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0 // Çok satırlı metin
        label.textColor = .darkGray
        return label
    }()
    
    // Dynamic Aspect Ratio Constraint için referans
    private var aspectRatioConstraint: NSLayoutConstraint?
    
    enum LayoutType {
          case grid
          case list
      }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupViews() {
        contentView.addSubview(postImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailsLabel)

        postImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    /*
    func configure(with image: UIImage, title: String, details: String, layoutType: LayoutType) {
        postImageView.image = image
        titleLabel.text = title
        detailsLabel.text = details
        

        switch layoutType {
        case .grid:
            configureGridLayout()
        case .list:
            configureListLayout()
        }
    }
    */
    private func configureGridLayout() {
        // Grid düzeni: Sadece postImageView
        titleLabel.isHidden = true
        detailsLabel.isHidden = true
        
        NSLayoutConstraint.deactivate(contentView.constraints)
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            postImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureListLayout() {
        titleLabel.isHidden = false
        detailsLabel.isHidden = false
        
        NSLayoutConstraint.deactivate(contentView.constraints)
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            
            detailsLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            detailsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            detailsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            detailsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        // Önce tüm layout'ları temizle
        if let aspectRatioConstraint = aspectRatioConstraint {
            postImageView.removeConstraint(aspectRatioConstraint)
            //self.aspectRatioConstraint = nil
        }
        // Dinamik olarak postImageView'un aspect ratio'sunu ayarlayın
        let aspectRatio = postImageView.image?.size.height ?? 1.0 / (postImageView.image?.size.width ?? 1.0)
        aspectRatioConstraint = postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: aspectRatio)
        aspectRatioConstraint?.isActive = true
    }
    
        func configure(with image: UIImage, title: String, details: String, layoutType: LayoutType) {
            postImageView.image = image
            titleLabel.text = title
            detailsLabel.text = details
            
            switch layoutType {
            case .grid:
                configureGridLayout()
            case .list:
                configureListLayout()
            }
    
            // Eski Aspect Ratio Constraint'i kaldır
            if let aspectRatioConstraint = aspectRatioConstraint {
                postImageView.removeConstraint(aspectRatioConstraint)
            }
    
            // Yeni Aspect Ratio Constraint ekle
            let aspectRatio = image.size.height / image.size.width
            aspectRatioConstraint = postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor, multiplier: aspectRatio)
            aspectRatioConstraint?.isActive = true
        }
}
