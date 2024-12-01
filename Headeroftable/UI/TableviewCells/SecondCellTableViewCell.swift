//
//  SecondCellTableViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 24.11.2024.
//

import UIKit

class SecondCellTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtonCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupButtonCollectionView() {
        // Flow Layout oluştur
        let layoutb = UICollectionViewFlowLayout()
        layoutb.itemSize = UIConstants.buttonsCollectionViewItemSize
        layoutb.scrollDirection = .horizontal
        print(layoutb.scrollDirection)
        layoutb.sectionInset = UIConstants.buttonsCollectionViewInset
        
        buttonsCollectionView.collectionViewLayout = layoutb
        buttonsCollectionView.dataSource = self
        buttonsCollectionView.delegate = self
        buttonsCollectionView.showsHorizontalScrollIndicator = false
        
        // Hücre kaydı
        buttonsCollectionView.register(
            buttonsCellCollectionViewCell.nib(),
            forCellWithReuseIdentifier: UIConstants.buttonsCollectionViewCellIdentifier
        )
    }
}
extension SecondCellTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 8
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
               
                   let cell = collectionView.dequeueReusableCell(
                       withReuseIdentifier: UIConstants.buttonsCollectionViewCellIdentifier,
                       for: indexPath
                   ) as! buttonsCellCollectionViewCell
                   cell.configure()
                   return cell
               }

           }

extension SecondCellTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            return UIConstants.buttonsCollectionViewItemSize
    }
}
