//
//  UserManager.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 7.01.2025.
//

import Foundation
import RxSwift
import RxCocoa
import FirebaseAuth
import FirebaseFirestore

class UserManager {
    static let shared = UserManager() // Singleton Instance, usermanager heryerden erişilebilir.
    
    // Reaktif kullanıcı durumu
    var currentUser: BehaviorRelay<User?> = BehaviorRelay(value: nil){
        didSet {
            print("UserManager: currentUser değişti. Yeni değer: \(String(describing: currentUser.value))")
        }
    }
    
    private init() {
        // Eğer oturum açmış kullanıcı varsa, başlatma sırasında yükle
        if let authUser = Auth.auth().currentUser {
            fetchUserFromFirestore(userId: authUser.uid) { success, error in
                if success {
                    print("UserManager: Kullanıcı başarıyla yüklendi.")
                } else {
                    print("UserManager: Kullanıcı yüklenirken hata: \(error ?? "Bilinmeyen hata")")
                }
            }
        } else {
            print("UserManager: Kullanıcı oturumu açık değil.")
        }
    }

//    func fetchUserFromFirestore(userId: String) {
//        let documentRef = Firestore.firestore().collection("users").document(userId)
//        
//        documentRef.getDocument { snapshot, error in
//            if let document = snapshot {
//                do {
//                    // Firestore’un özel Decoder'ını kullanarak modeli decode et
//                    let user = try document.data(as: User.self) // Firestore Swift Model Decoding
//                    UserManager.shared.currentUser.accept(user)
//                    print("UserManager: Firestore'dan kullanıcı yüklendi: \(user.name)")
//                } catch {
//                    print("UserManager: Kullanıcı dönüştürme hatası: \(error)")
//                }
//            } else {
//                print("UserManager: Kullanıcı bulunamadı veya Firestore hatası: \(String(describing: error))")
//            }
//        }
//    }
    func fetchUserFromFirestore(userId: String, completion: @escaping (Bool, String?) -> Void) {
        let documentRef = Firestore.firestore().collection("users").document(userId)
        
        // Loading Indicator Başlat
        LoadingView.shared.show()
        
        documentRef.getDocument { snapshot, error in
            defer {
                DispatchQueue.main.async {
                    LoadingView.shared.hide() // İşlem bittiğinde loading gizle
                }
            }
            
            if let document = snapshot, document.exists {
                do {
                    // Firestore'un Decoding ile Kullanıcı Verisini Al
                    let user = try document.data(as: User.self)
                    UserManager.shared.currentUser.accept(user) // UserManager'da Güncelle
                    
                    print("UserManager: Firestore'dan kullanıcı yüklendi: \(user.name)")
                    completion(true, nil) // Başarılı
                } catch {
                    print("UserManager: Kullanıcı dönüştürme hatası: \(error)")
                    completion(false, "Veri dönüştürme hatası: \(error.localizedDescription)") // Hata
                }
            } else {
                print("UserManager: Kullanıcı bulunamadı veya Firestore hatası: \(String(describing: error))")
                completion(false, "Kullanıcı bulunamadı veya Firestore hatası") // Hata
            }
        }
    }
    func fetchAndHandleCurrentUser(completion: @escaping (User?) -> Void) {
        if let authUser = Auth.auth().currentUser {
            UserManager.shared.fetchUserFromFirestore(userId: authUser.uid) { success, error in
                if success {
                    if let currentUser = UserManager.shared.currentUser.value {
                        completion(currentUser)
                    } else {
                        print("UserManager: Kullanıcı bulunamadı.")
                        completion(nil)
                    }
                } else {
                    print("UserManager: Hata oluştu: \(error ?? "Bilinmeyen hata")")
                    completion(nil)
                }
            }
        } else {
            print("Auth: Oturum açmış kullanıcı yok.")
            completion(nil)
        }
    }

    // Kullanıcı güncelleme
    func updateUser(_ user: User) {
        currentUser.accept(user)
    }
    
    func addFavoriteArticle(_ articleId: String) {
        guard var user = currentUser.value else { return }
        
        if !user.favoriteArticles.contains(where: { $0.articleId == articleId }) {
            let newFavorite = User.FavoriteArticle(articleId: articleId, addedAt: Date())
            user.favoriteArticles.append(newFavorite)
            currentUser.accept(user)
        }
    }
    
    func removeFavoriteArticle(_ articleId: String) {
        guard var user = currentUser.value else { return }
        user.favoriteArticles.removeAll(where: { $0.articleId == articleId })
        currentUser.accept(user)
    }
}
