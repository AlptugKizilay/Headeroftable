import UIKit

class ProfileHeaderView: UICollectionReusableView {
    static let identifier = "ProfileHeaderView"
    
    // Profil fotoğrafı
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 60
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    // İsim Label
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    // Segmented Control
    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Grid", "List"])
        control.selectedSegmentIndex = 1
        control.backgroundColor = .white
        control.selectedSegmentTintColor = UIColor(named: "colorButton")
        control.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        return control
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProfileView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupProfileView() {
        // Arka plan
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        backgroundView.backgroundColor = UIColor(named: "colorButton")
        addSubview(backgroundView)
        
        // Eğri çerçeve (Curve)
        let curveLayer = createCurvedLayer()
        backgroundView.layer.addSublayer(curveLayer)
        
        // Profil fotoğrafını ekle
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        // İsim label'ını ekle
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        // Segmented control ekle
        addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 16),
            segmentedControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            segmentedControl.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    private func createCurvedLayer() -> CAShapeLayer {
        let curvedPath = UIBezierPath()
        let width = frame.width
        
        // Eğri çizmeye başla
        curvedPath.move(to: CGPoint(x: 0, y: 150)) // Başlangıç noktası
        curvedPath.addQuadCurve(
            to: CGPoint(x: width, y: 150), // Son nokta
            controlPoint: CGPoint(x: width / 2, y: 100) // Eğrinin kontrol noktası
        )
        curvedPath.addLine(to: CGPoint(x: width, y: 0)) // Sağ üst köşe
        curvedPath.addLine(to: CGPoint(x: 0, y: 0)) // Sol üst köşe
        curvedPath.close() // Çizimi kapat
        
        // Eğriyi bir shape layer ile bağla
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = curvedPath.cgPath
        shapeLayer.fillColor = UIColor.white.cgColor
        
        return shapeLayer
    }
    
    func configure(with image: UIImage, name: String) {
        profileImageView.image = image
        nameLabel.text = name
    }
}
