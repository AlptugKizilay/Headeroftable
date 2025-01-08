//
//  LoadingView.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 8.01.2025.
//
import UIKit

class LoadingView {
    private var overlayView: UIView!
    private var activityIndicator: UIActivityIndicatorView!

    static let shared = LoadingView()

    private init() {
        // Overlay için görünüm ayarları
        overlayView = UIView(frame: UIScreen.main.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Aktivite göstergesi
        activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.center = overlayView.center
        overlayView.addSubview(activityIndicator)
    }

    func show() {
        if let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) {
            activityIndicator.startAnimating()
            window.addSubview(overlayView)
        }
    }

    func hide() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }
}
