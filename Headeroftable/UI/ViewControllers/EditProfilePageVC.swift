//
//  EditProfilePageVC.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 18.12.2024.
//

import UIKit
import RxSwift
import FirebaseAuth

enum EditProfileMode {
    case newUser // Yeni kullanıcı bilgileri girecek
    case editProfile // Mevcut kullanıcı bilgilerini düzenleyecek
}
class EditProfilePageVC: UIViewController {
    
    var mode: EditProfileMode = .newUser // Varsayılan mod
    //var user: User? // Mevcut kullanıcı bilgilerini düzenlemek için
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var dateOfBirthTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var saveButtonOutlet: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    private var datePicker: UIDatePicker!
    private var selectedDateOfBirth: Date?
    private var selectedGender: User.Gender = .unknown
    private let viewModel = EditProfileViewModel()
    private let authViewModel = AuthViewModel()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        configureViewForMode()
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        UserManager.shared.fetchAndHandleCurrentUser(){ user in
            if let user = user {
                self.populateUserData(user)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //kullanıcı bilgisi güncelle
        UserManager.shared.fetchAndHandleCurrentUser(){ user in
            if let user = user {
                self.populateUserData(user)
            }
        }
        
    }
    
    // Mode'a göre ekranı yapılandır
    private func configureViewForMode() {
        switch mode {
        case .newUser:
            title = "Complete Profile" // Yeni kullanıcı için başlık
            if let currentUser = Auth.auth().currentUser {
                emailTextField.text = currentUser.email
                emailTextField.isEnabled = false // E-posta düzenlenemez
            }else {
                print("Kullanıcı oturumu kapalı.")
            }
        case .editProfile:
            title = "Edit Profile" // Mevcut profil düzenleme için başlık
            emailTextField.isEnabled = false // Email düzenlenemez
        }
    }
    
    private func setupUI() {
        setupDatePicker()
    }
    
    private func setupBindings() {
        // Save Button Action
        saveButtonOutlet.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                
                self.saveUserProfile()
                
                switch mode {
                case .newUser:
                    navigateToHomePage()
                case .editProfile:
                    navigateToProfilePage()
                }
            }
            .disposed(by: disposeBag)
        // Logout Button Action
        logoutButton.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.handleLogout()
            }
            .disposed(by: disposeBag)
    }
    
    private func populateUserData(_ user: User) {
        
        
        // Kullanıcı bilgilerini doldur
        nameTextField.text = user.name
        emailTextField.text = user.email
        countryTextField.text = user.country
        selectedDateOfBirth = user.dateOfBirth
        dateOfBirthTextField.text = formatDate(user.dateOfBirth)
        
        // Cinsiyeti seçili hale getir
        switch user.gender {
        case .male:
            genderSegmentedControl.selectedSegmentIndex = 0
        case .female:
            genderSegmentedControl.selectedSegmentIndex = 1
        case .other:
            genderSegmentedControl.selectedSegmentIndex = 2
        default:
            genderSegmentedControl.selectedSegmentIndex = -1
        }
    }
    
    private func setupDatePicker() {
        datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        dateOfBirthTextField.inputView = datePicker
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDateOfBirth = sender.date
        dateOfBirthTextField.text = formatDate(sender.date)
    }
    private func handleLogout() {
        authViewModel.logout { [weak self] error in
            if let error = error {
                self?.showAlert("Logout Error", error)
            } else {
                UserManager.shared.currentUser.accept(nil)
                self?.navigateToHomePage()
            }
        }
    }
    
    private func saveUserProfile() {
        // Kullanıcı bilgilerini al
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert("Error", "Name cannot be empty")
            return
        }
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert("Error", "Email cannot be empty")
            return
        }
        guard let dateOfBirth = selectedDateOfBirth else {
            showAlert("Error", "Please select your date of birth")
            return
        }
        guard let country = countryTextField.text else {
            showAlert("Error", "Please select your date of country")
            return
        }
        
        
        // Seçilen cinsiyeti belirle
        let gender: User.Gender
        switch genderSegmentedControl.selectedSegmentIndex {
        case 0:
            gender = .male
        case 1:
            gender = .female
        case 2:
            gender = .other
        default:
            gender = .unknown
        }
        
        
        
        
        guard var currentUser = UserManager.shared.currentUser.value else {
            print("EditProfilePageVC: Kullanıcı bulunamadı")
            return
        }
        currentUser.name = name
        currentUser.dateOfBirth = dateOfBirth
        currentUser.gender = gender
        currentUser.country = country
        // Kullanıcı bilgilerini ViewModel aracılığıyla kaydet
        viewModel.saveUser(user: currentUser)
    }
    
    private func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
    private func navigateToHomePage() {
        // Ana sayfaya yönlendirme
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let MainPageVC = storyboard.instantiateViewController(withIdentifier: "MainPageVC") as? MainPageVC {
            navigationController?.setViewControllers([MainPageVC], animated: true)
        }
    }
    private func navigateToProfilePage() {
        // Ana sayfaya yönlendirme
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ProfilePageVC = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as? ProfilePageVC {
            navigationController?.setViewControllers([ProfilePageVC], animated: true)
        }
    }
    
    
}
