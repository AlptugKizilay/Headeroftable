//
//  ViewController.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 23.11.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let customTabBarView = CustomTabBarView.createView()
    private var previousScrollOffset: CGFloat = 0

    override func viewDidLoad() {
            super.viewDidLoad()
        
            setupTableView()
            setupCustomTabBar()
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
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
                    // İlk CollectionView için
                    let cell = tableView.dequeueReusableCell(withIdentifier: "firstCell", for: indexPath) as! FirstCellTableViewCell
                    return cell
                } else if indexPath.row == 1 {
                    // İkinci CollectionView için
                    let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! SecondCellTableViewCell
                    return cell
                }else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
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
extension ViewController: UIScrollViewDelegate {
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
    







