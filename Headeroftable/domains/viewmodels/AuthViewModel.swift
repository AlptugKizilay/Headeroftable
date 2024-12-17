import Foundation
import RxSwift
import RxCocoa

class AuthViewModel {
    
    // Use case'lerimizi burada kullanacağız
    private let registerUserUseCase: RegisterUserUseCaseProtocol
    private let loginUserUseCase: LoginUserUseCaseProtocol
    private let disposeBag = DisposeBag()
    
    // View'de gözlemlenecek durumlar
    let isLoading = BehaviorRelay<Bool>(value: false)
    let successMessage = PublishSubject<String>()
    let errorMessage = PublishSubject<String>()
    
    init(
        registerUserUseCase: RegisterUserUseCaseProtocol = RegisterUserUseCase(),
        loginUserUseCase: LoginUserUseCaseProtocol = LoginUserUseCase()
    ) {
        self.registerUserUseCase = registerUserUseCase
        self.loginUserUseCase = loginUserUseCase
    }
    
    // Kullanıcı kaydı
    func registerUser(email: String, password: String) {
        isLoading.accept(true) // Yükleniyor durumunu bildir
        registerUserUseCase.execute(email: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] user in
                    self?.isLoading.accept(false)
                    self?.successMessage.onNext("VM- Kullanıcı kaydedildi: \(user.name)")
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMessage.onNext("VM- Hata: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
    
    // Kullanıcı girişi
    func loginUser(email: String, password: String) {
        isLoading.accept(true) // Yükleniyor durumunu bildir
        loginUserUseCase.execute(email: email, password: password)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] user in
                    self?.isLoading.accept(false)
                    self?.successMessage.onNext("VM- Giriş başarılı: \(user.name)")
                },
                onError: { [weak self] error in
                    self?.isLoading.accept(false)
                    self?.errorMessage.onNext("VM- Hata: \(error.localizedDescription)")
                }
            )
            .disposed(by: disposeBag)
    }
}
