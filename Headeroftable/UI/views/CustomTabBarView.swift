//
//  CustomTabBarView.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 25.11.2024.
//

import UIKit

class CustomTabBarView: UIView {
    
    // XIB bağlantıları
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    
    var contentView: UIView!
    private var selectedButton: UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)    
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
 
    }
    

    
    
    static func nib() -> UINib {
        return UINib(nibName: "CustomTabBarView", bundle: nil)
    }
    static func createView() -> CustomTabBarView {
            guard let view = nib().instantiate(withOwner: nil, options: nil).first as? CustomTabBarView else {
                fatalError("Could not load CustomTabBarView from nib")
            }
            return view
        }
}

