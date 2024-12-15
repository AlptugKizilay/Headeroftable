//
//  SecondCellTableViewCell.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 24.11.2024.
//

import UIKit
import RxSwift

class SecondCellTableViewCell: UITableViewCell {
    @IBOutlet weak var buttonsCollectionView: UICollectionView!
    var collectionViewArticles: [Article] = []
    var viewModel: MainPageViewModel? // ViewModel dışarıdan atanacak
    private var disposeBag = DisposeBag()
    var sections: [String] = []
    var selectedSection: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtonCollectionView()
        bindViewModel()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupButtonCollectionView() {
        // Flow Layout oluştur
        let layoutb = UICollectionViewFlowLayout()
        //layoutb.itemSize = UIConstants.buttonsCollectionViewItemSize
        layoutb.scrollDirection = .horizontal
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
               // print("SecondCellTableViewCell - Articles count: \(articles.count)")
                // Gelen verilerle hücreyi güncelle
                self?.updateUI(with: articles)
                self?.sections = Array(Set(articles.map { $0.section})).sorted()
            })
            .disposed(by: disposeBag)
    }
    private func updateUI(with articles: [Article]) {
        collectionViewArticles = articles
        buttonsCollectionView.reloadData()
    }
}
extension SecondCellTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: UIConstants.buttonsCollectionViewCellIdentifier,
            for: indexPath
        ) as! buttonsCellCollectionViewCell
        let title = sections[indexPath.row] // `sections` dizisi buton başlıklarını içeriyor
        let isSelected = selectedSection == title // Seçili butonu belirleyin
        cell.configure(with: title, isSelected: isSelected)
        cell.buttonOutlet.isUserInteractionEnabled = false
        
        return cell
    }
    @objc func filterArticles(for section: String) {
        print("Filter for section: \(section)")
        viewModel?.updateSelectedSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selected = sections[indexPath.row]
            if selectedSection == selected {
                // Eğer mevcut seçili butona tekrar dokunulursa filtreyi kaldır
                selectedSection = nil
            } else {
                // Yeni section'ı seç
                selectedSection = selected
            }
        guard let viewModel = viewModel else { return }
        viewModel.updateSelectedSection(selectedSection)
        collectionView.reloadData() // Görünümü güncelle
    }
}

extension SecondCellTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = sections[indexPath.row] // Section adı veya buton title'ı
        let font = UIFont.systemFont(ofSize: 14, weight: .medium)

  
        
        // Text'in genişliğini hesapla
        let textWidth = text.size(withAttributes: [NSAttributedString.Key.font: font]).width
        let padding: CGFloat = 32 // Button padding (16 left + 16 right)
        let calculatedWidth = textWidth + padding
        
        
        return CGSize(width: calculatedWidth, height: 32) // Dinamik genişlik

        
       
    }
}
