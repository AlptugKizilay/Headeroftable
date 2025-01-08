//
//  RegisterPageVC.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 17.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterPageVC: UIViewController {
    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    private let authViewModel = AuthViewModel() // ViewModel
    private let disposeBag = DisposeBag()
    static var emailshared = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
      }
    

    private func setupBindings() {
            // Register Button Action
            registerButton.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    let email = self.mailTF.text ?? ""
                    let password = self.passwordTF.text ?? ""
                    RegisterPageVC.emailshared = email
                    
                    // Kullanıcıyı register etmek için ViewModel'i kullan
                    self.authViewModel.registerUser(email: email, password: password)
                }
                .disposed(by: disposeBag)
            
            // Başarı mesajı
            authViewModel.successMessage
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] message in
                    print(message) // Başarı mesajı
                    self?.navigateToEditProfilePage() // Kayıt başarılıysa editprofile yönlendir
                })
                .disposed(by: disposeBag)
            
            // Hata mesajı
            authViewModel.errorMessage
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { error in
                    print("Error: \(error)") // Hata mesajı
                })
                .disposed(by: disposeBag)
        }
    private func navigateToEditProfilePage() {
            // Ana sayfaya yönlendirme
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let EditProfilePageVC = storyboard.instantiateViewController(withIdentifier: "EditProfilePageVC") as? EditProfilePageVC {
                navigationController?.setViewControllers([EditProfilePageVC], animated: true)
            }
        }
    
}
