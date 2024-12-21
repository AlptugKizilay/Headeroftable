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
                do {
                    var userData = try user.asDictionary()
                    // Eğer user.id nil ise, Firestore'un otomatik bir ID oluşturmasına izin ver
                    let documentID = user.id ?? UUID().uuidString // Eğer ID yoksa UUID oluştur
                    userData["id"] = documentID
                    
                    self.db.collection("users").document(documentID).setData(userData) { error in
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

