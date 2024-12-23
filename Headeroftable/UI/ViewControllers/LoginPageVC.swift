//
//  LoginPageVC.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 17.12.2024.
//

import UIKit
import RxSwift
import RxCocoa

class LoginPageVC: UIViewController {

    @IBOutlet weak var mailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private let authViewModel = AuthViewModel()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        navigationController?.navigationBar.tintColor = UIColor(named: "colorButton")
    }
    
    private func setupBindings() {
            // Login Button Action
            loginButton.rx.tap
                .bind { [weak self] in
                    guard let self = self else { return }
                    let email = self.mailTF.text ?? ""
                    let password = self.passwordTF.text ?? ""
                    
                    // Kullanıcı giriş yap
                    self.authViewModel.loginUser(email: email, password: password)
                }
                .disposed(by: disposeBag)
            
            // Başarı mesajı
            authViewModel.successMessage
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { [weak self] message in
                    print(message) // Başarı mesajı
                    self?.navigateToProfilePage() // Giriş başarılıysa profile yönlendir
                })
                .disposed(by: disposeBag)
            
            // Hata mesajı
            authViewModel.errorMessage
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { error in
                    print("Error: \(error)")
                })
                .disposed(by: disposeBag)
        }
    private func navigateToProfilePage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfilePageVC") as? ProfilePageVC {
            navigationController?.setViewControllers([profileVC], animated: true)
        }
    }
    
    @IBAction func registerButtonAct(_ sender: Any) {
        navigateToRegisterPage()
    }
    private func navigateToRegisterPage() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let registerVC = storyboard.instantiateViewController(withIdentifier: "RegisterPageVC") as? RegisterPageVC {
            navigationController?.pushViewController( registerVC, animated: true)
        }else {
            print("RegisterPageVC Storyboard ID yanlış veya tanımlı değil.")
        }
    }
}
