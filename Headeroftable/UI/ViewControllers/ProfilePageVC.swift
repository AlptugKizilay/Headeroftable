import UIKit

class ProfilePageVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    //@IBOutlet weak var collectionView: UICollectionView!
    private var collectionView: UICollectionView!
    let customTabBarView = CustomTabBarView.createView()
    private var news: [(image: UIImage, title: String, details: String)] = []
    public var selectedSegmentIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupCollectionView()
        
        // Örnek veriler
        news = [
            (image: UIImage(named: "news")!, title: "Haber 1", details: "Bu, haber 1 için detaylı bir açıklamadır."),
            (image: UIImage(named: "pizza_resim")!, title: "Haber 2", details: "Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur."),
            (image: UIImage(named: "news")!, title: "Haber 3", details: "Kısa bir haber detayı."),
            (image: UIImage(named: "news")!, title: "Haber 1", details: "Bu, haber 1 için detaylı bir açıklamadır."),
            (image: UIImage(named: "pizza_resim")!, title: "Haber 2", details: "Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur."),
            (image: UIImage(named: "news")!, title: "Haber 3", details: "Kısa bir haber detayı."),
            (image: UIImage(named: "news")!, title: "Haber 1", details: "Bu, haber 1 için detaylı bir açıklamadır."),
            (image: UIImage(named: "pizza_resim")!, title: "Haber 2", details: "Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur."),
            (image: UIImage(named: "news")!, title: "Haber 3", details: "Kısa bir haber detayı."),
            (image: UIImage(named: "news")!, title: "Haber 1", details: "Bu, haber 1 için detaylı bir açıklamadır."),
            (image: UIImage(named: "pizza_resim")!, title: "Haber 2", details: "Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur.Bu haberin açıklaması daha uzun bir metinden oluşur."),
            (image: UIImage(named: "news")!, title: "Haber 3", details: "Kısa bir haber detayı.")
        ]
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true) // Navigation bar gizlenir
        setupCustomTabBarActions()
        setupCustomTabBar()
    }
    private func setupCustomTabBar() {
        customTabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(customTabBarView)
        
        customTabBarView.layer.cornerRadius = 40
        customTabBarView.backgroundColor = .white
        customTabBarView.isHidden = false
        customTabBarView.alpha = 1.0
        NSLayoutConstraint.activate([
            customTabBarView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: +32),
            customTabBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            customTabBarView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            customTabBarView.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
    // Custom Tab Bar'daki butonlar için aksiyonlar
        private func setupCustomTabBarActions() {
            customTabBarView.onProfileButtonTapped = {
                print("Profile Button Tapped!")
                // Profile VC'ye tekrar yönlendirme yapılmaz
            }

            customTabBarView.onHomeButtonTapped = { [weak self] in
                print("Home Button Tapped!")
                self?.navigateToHome()
            }
        }

        // Ana Sayfa Navigasyonu
        private func navigateToHome() {
            guard let navigationController = navigationController else {
                print("NavigationController mevcut değil.")
                return
            }

            // Ana Sayfaya geri git
            for controller in navigationController.viewControllers {
                if controller is MainPageVC {
                    navigationController.popToViewController(controller, animated: true)
                    return
                }
            }

            // Eğer MainPageVC stack'te yoksa, yeni bir tane oluştur
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mainPageVC = storyboard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageVC {
                navigationController.pushViewController(mainPageVC, animated: true)
            }
        }
        
    
    private func setupCollectionView() {
        // Layout tanımla
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.headerReferenceSize = CGSize(width: view.frame.width, height: 240) // Header boyutu
        layout.itemSize = CGSize(width: view.frame.width, height: 100) // Hücre boyutu
        
        // CollectionView oluştur
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(FavCollectionViewCell.self, forCellWithReuseIdentifier: FavCollectionViewCell.identifier)
        collectionView.register(ProfileHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(collectionView)
    }
    
    // MARK: - CollectionView DataSource
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavCollectionViewCell.identifier, for: indexPath) as! FavCollectionViewCell
        let item = news[indexPath.row]
        
        if selectedSegmentIndex == 0 {
            // Grid görünümü:
            cell.configure(with: item.image, title: item.title, details: item.details, layoutType: .grid)
        } else {
            // Liste görünümü:
            cell.configure(with: item.image, title: item.title, details: item.details, layoutType: .list)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if selectedSegmentIndex == 0 {
                // Grid görünümü: Sabit boyut
                let width = (collectionView.frame.width - 20) / 2
                return CGSize(width: width, height: width)
            } else {
                // Liste görünümü: Dinamik boyut
                let item = news[indexPath.row]
                let width = collectionView.frame.width
                let imageHeight = width * (item.image.size.height / item.image.size.width)
                let titleHeight = item.title.height(withConstrainedWidth: width - 16, font: UIFont.boldSystemFont(ofSize: 16))
                let detailsHeight = item.details.height(withConstrainedWidth: width - 16, font: UIFont.systemFont(ofSize: 14))
                let height = imageHeight + titleHeight + detailsHeight + 32
                return CGSize(width: width, height: height)
            }
    }
    
    // MARK: - CollectionView Header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! ProfileHeaderView
            // Header'ı yapılandır
            header.configure(with: UIImage(named: "pizza_resim")!, name: "Melissa Peters")
            // Segmented Control Action
            header.segmentedControl.addTarget(self, action: #selector(segmentedControlChanged(_:)), for: .valueChanged)
            header.onEditProfileTapped = { [weak self] in
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        if let EditProfilePageVC = storyboard.instantiateViewController(withIdentifier: "EditProfilePageVC") as? EditProfilePageVC {
                            self?.navigationController?.pushViewController(EditProfilePageVC, animated: true)
                        }
                    }
            return header
        }
        return UICollectionReusableView()
    }
    @objc private func segmentedControlChanged(_ sender: UISegmentedControl) {
        selectedSegmentIndex = sender.selectedSegmentIndex
        collectionView.reloadData()
        if sender.selectedSegmentIndex == 0 {
            // Grid Görünümü
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 240)
            collectionView.setCollectionViewLayout(layout, animated: false)
            
        } else {
            // Liste Görünümü
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 240)
            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.reloadData()
        }
    }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return ceil(boundingBox.height)
    }
}

