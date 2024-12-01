//
//  FirstCellTableViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 24.11.2024.
//

import UIKit

class FirstCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupCollectionView() {
        // Flow Layout oluştur
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = UIConstants.collectionViewItemSize
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIConstants.collectionViewInset

        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false

        // Hücre kaydı
        collectionView.register(
            CellCollectionViewCell.nib(),
            forCellWithReuseIdentifier: UIConstants.collectionViewCellIdentifier
        )
    }
    

}
extension FirstCellTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           
        let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: UIConstants.collectionViewCellIdentifier,
                   for: indexPath
               ) as! CellCollectionViewCell
               cell.configure(with: UIImage(named: "yemek_resim")!)
               return cell
       }
    //Snap Animasyonu
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }

        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing
        let estimatedIndex = scrollView.contentOffset.x / cellWidthIncludingSpacing
        let index: CGFloat = velocity.x > 0 ? ceil(estimatedIndex) : floor(estimatedIndex)
        targetContentOffset.pointee = CGPoint(x: index * cellWidthIncludingSpacing, y: 0)
    }
}
extension FirstCellTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return UIConstants.collectionViewItemSize
    }
}
