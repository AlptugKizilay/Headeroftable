//
//  ViewController.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit
import RxSwift
import RxCocoa

class MainPageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = MainPageViewModel()
    private let disposeBag = DisposeBag()
    let customTabBarView = CustomTabBarView.createView()
    private var previousScrollOffset: CGFloat = 0
    var articles: [Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupCustomTabBar()
        viewModel.fetchArticles()
        setupBindings()
        tableView.reloadData()
        
    }
    private func setupBindings() {
        viewModel.articles
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { articles in
                print("Fetched Articles count: \(articles.count)")
                self.articles = articles
                self.tableView.reloadData()
            }, onError: { error in
                print("Error: \(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
        
        // Hata durumunda bir uyarı göster
        viewModel.error
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                let alert = UIAlertController(title: "Hata", message: errorMessage, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: .default))
                self?.present(alert, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    private func setupCustomTabBar() {
        
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBarView)
        customTabBarView.layer.cornerRadius = 40
        customTabBarView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +32),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            customTabBarView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    
}
extension MainPageVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(articles.count)
        return articles.count + 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // İlk CollectionView için
            let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! FirstCellTableViewCell
            cell.viewModel = viewModel // ViewModel'i hücreye ata
            cell.bindViewModel() // ViewModel'i bağla
            return cell
        } else if indexPath.row == 1 {
            // İkinci CollectionView için
            let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! SecondCellTableViewCell
            cell.viewModel = viewModel // ViewModel'i hücreye ata
            cell.bindViewModel() // ViewModel'i bağla
            return cell
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CellTableViewCell
            let article = articles[indexPath.row - 2]
            cell.label.text = article.title
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 256
        }else if indexPath.row == 1 {
            return 40
        }
        return 128
        
    }
}
extension MainPageVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == tableView else { return }
        
        let currentOffset = scrollView.contentOffset.y
        let difference = currentOffset - previousScrollOffset
        
        if difference > 0 && currentOffset > 0 {
            // Scroll Down: Tab bar'ı gizle
            UIView.animate(withDuration: 0.7) {
                self.customTabBarView.alpha = 0
            } completion: { _ in
                self.customTabBarView.isHidden = false
            }
        } else if difference < 0 {
            // Scroll Up: Tab bar'ı göster
            self.customTabBarView.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.customTabBarView.alpha = 1
            }
        }
        
        // Scroll offset'i güncelle
        previousScrollOffset = currentOffset
    }
}








