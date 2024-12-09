//
//  ViewController.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class MainPageVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
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
        viewModel.filteredArticles
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
        tableView.separatorStyle = .none
    }
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Search articles..."
    }
    private func setupCustomTabBar() {
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBarView)
        customTabBarView.layer.cornerRadius = 40
        customTabBarView.backgroundColor = .white
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
            cell.article = articles[indexPath.row - 2]
            return cell
        }
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.masksToBounds = true
        cell.contentView.backgroundColor = .white
        cell.backgroundColor = .clear
        
        // Hücre kenar boşluğu
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let article = articles[indexPath.row - 2]
        guard let url = URL(string: article.url) else { return }
        let safariVC = SFSafariViewController(url: url )
        present(safariVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 256
        }else if indexPath.row == 1 {
            return 40
        }
        return 148
        
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
extension MainPageVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // ViewModel'e arama kelimesini gönder
        viewModel.updateSearchKeyword(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder() // Klavyeyi kapat
    }
}








