//
//  ProfilePageVC.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 17.12.2024.
//

import UIKit

class ProfilePageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProfileView()
    }
    
    private func setupProfileView() {
        // Arka plan
        let backgroundView = UIView()
        backgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        backgroundView.backgroundColor = UIColor(named: "mainColor")
        view.addSubview(backgroundView)
        
        // Eğri çerçeve (Curve)
        let curveLayer = createCurvedLayer()
        view.layer.addSublayer(curveLayer)
        
        // Profil Fotoğrafı
        let profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "pizza_resim") // Profil fotoğrafı
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 60
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.frame = CGRect(x: (view.frame.width - 120) / 2, y: 140, width: 120, height: 120)
        view.addSubview(profileImageView)
        
        // İsim
        let nameLabel = UILabel()
        nameLabel.text = "Melissa Peters"
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.frame = CGRect(x: 20, y: 260, width: view.frame.width - 40, height: 24)
        view.addSubview(nameLabel)
    }
    
    private func createCurvedLayer() -> CAShapeLayer {
        let curvedPath = UIBezierPath()
        let width = view.frame.width
        
        // Eğri çizmeye başla
        curvedPath.move(to: CGPoint(x: 0, y: 250)) // Başlangıç noktası
        curvedPath.addQuadCurve(
            to: CGPoint(x: width, y: 250), // Son nokta
            controlPoint: CGPoint(x: width / 2, y: 200) // Eğrinin kontrol noktası
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
}
