//
//  FirstCellTableViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 24.11.2024.
//

import UIKit
import RxSwift

class FirstCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var collectionViewArticles: [Article] = []
    var viewModel: MainPageViewModel? // ViewModel dışarıdan atanacak
    private var disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        bindViewModel()
        
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
    // ViewModel'deki articles verisini bağlama
    func bindViewModel() {
        guard let viewModel = viewModel else {
            print("ViewModel not set!")
            return
        }
        // Abonelikleri temizleyip yeniden oluştur
        disposeBag = DisposeBag()
        
        viewModel.articles
            .observe(on: MainScheduler.instance) // UI işlemleri için ana thread'e geç
            .subscribe(onNext: { [weak self] articles in
                print("FirstCellTableViewCell - Articles count: \(articles.count)")
                // Gelen verilerle hücreyi güncelle
                self?.updateUI(with: articles)
            })
            .disposed(by: disposeBag)
    }
    
    // UI'yi güncellemek için bir fonksiyon
    private func updateUI(with articles: [Article]) {
        collectionViewArticles = Array(articles.suffix(5))
        collectionView.reloadData()
    }
    
}
extension FirstCellTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewArticles.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UIConstants.collectionViewCellIdentifier,
            for: indexPath
        ) as! CellCollectionViewCell
        cell.configure(with: collectionViewArticles[indexPath.row])
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
