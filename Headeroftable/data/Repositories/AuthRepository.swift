//
//  AuthRepository.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 15.12.2024.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import RxSwift

protocol AuthRepositoryProtocol {
    func registerUser(email: String, password: String) -> Observable<User>
    func loginUser(email: String, password: String) -> Observable<User>
    func logoutUser() -> Observable<Void>
}

class AuthRepository: AuthRepositoryProtocol {
    private let db = Firestore.firestore()
        
    func registerUser(email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else if let authResult = authResult {
                    let user = User(
                        id: authResult.user.uid,
                        name: "", // Kullanıcı adı şimdilik boş
                        email: authResult.user.email ?? "",
                        dateOfBirth: Date(),
                        gender: .unknown,
                        profileImageURL: "",
                        country: "",
                        favoriteArticles: []
                    )
                    self.db.collection("users").document(user.id!).setData(user.asDictionary()) { error in
                                            if let error = error {
                                                observer.onError(error)
                                            } else {
                                                observer.onNext(user)
                                                observer.onCompleted()
                                            }
                                        }
                }
            }
            return Disposables.create()
        }
    }

    func loginUser(email: String, password: String) -> Observable<User> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    observer.onError(error)
                } else if let authResult = authResult {
                    let user = User(
                        id: authResult.user.uid,
                        name: "",
                        email: authResult.user.email ?? "",
                        dateOfBirth: Date(),
                        gender: .unknown,
                        profileImageURL: "",
                        country: "",
                        favoriteArticles: []
                    )
                    observer.onNext(user)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func logoutUser() -> Observable<Void> {
        return Observable.create { observer in
            do {
                try Auth.auth().signOut()
                observer.onNext(())
                observer.onCompleted()
            } catch let error {
                observer.onError(error)
            }
            return Disposables.create()
        }
    }
}

