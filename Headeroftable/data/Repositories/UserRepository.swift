//
//  UserRepository.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import Foundation
import FirebaseFirestore
import RxSwift

protocol UserRepositoryProtocol {
    func fetchUsersAsModels() -> Observable<[User]>
    func fetchUsers() -> Observable<[[String: Any]]>
    func saveUser(user: User) -> Observable<Void>
}

class UserRepository: UserRepositoryProtocol {
    private let db = Firestore.firestore()
    
    func fetchUsersAsModels() -> Observable<[User]> {
        return Observable.create { observer in
            self.db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let documents = snapshot?.documents {
                    let users = documents.compactMap { try? $0.data(as: User.self) }        //compactMap, Nil olmayan dönüşmüş değerlerden yeni bir dizi oluşturur.
                    observer.onNext(users)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func fetchUsers() -> Observable<[[String: Any]]> {
        return Observable.create { observer in
            self.db.collection("users").getDocuments { snapshot, error in
                if let error = error {
                    observer.onError(error)
                } else if let documents = snapshot?.documents {
                    observer.onNext(documents.map { $0.data() })
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    func saveUser(user: User) -> Observable<Void> {
        return Observable.create { observer in
            guard let userId = user.id else {
                observer.onError(NSError(domain: "UserRepository", code: 0, userInfo: [NSLocalizedDescriptionKey: "User ID is missing"]))
                return Disposables.create()
            }
            
            do {
                let userData = try user.asDictionary()
                self.db.collection("users").document(userId).setData(userData) { error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        observer.onNext(())
                        observer.onCompleted()
                    }
                }
            } catch {
                observer.onError(error)
            }
            
            return Disposables.create()
        }
    }
//    func saveUser(user: User) -> Observable<Void> {
//        return Observable.create { observer in
//            do {
//                let userData = try user.asDictionary()
//                self.db.collection("users").document(user.id ?? UUID().uuidString).setData(userData) { error in
//                    if let error = error {
//                        observer.onError(error)
//                    } else {
//                        observer.onNext(())
//                        observer.onCompleted()
//                    }
//                }
//            } catch {
//                observer.onError(error)
//            }
//            return Disposables.create()
//        }
//    }
}

/*
 1.    Model Kullanımı (User):
 •    Tip güvenli ve daha temiz kod.
 •    UI’ye veri bind etmek için.
 •    Favori makaleler gibi ilişkisel verilerle çalışırken kullanılır.
 2.    Dictionary Kullanımı ([String: Any]):
 •    Esnek ve hızlı veri işlemleri için kullanılır.
 •    Firestore’a veri ekleme/güncelleme için uygundur.
 •    Debugging veya API’den gelen veriyi hızlıca görmek için kullanılabilir.
 */

