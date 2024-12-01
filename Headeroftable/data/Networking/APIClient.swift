//
//  APIClient.swift
//  Headeroftable
//
//  Created by Alptuğ Kızılay on 27.11.2024.
//
import Foundation
import Alamofire
import RxSwift

struct ResponseWrapper: Codable {
    let status: String
    let copyright: String
    let num_results: Int
    let results: [Article]
}
class APIClient {
    // Singleton pattern: APIClient her yerden erişilebilir.
    static let shared = APIClient()
    private init() {}

    /// Verilen URL'den makaleleri çeker
    /// - Parameter url: API için hedef URL
    /// - Returns: Makale dizisi içeren bir Observable
    func fetchArticles(from url: String) -> Observable<[Article]> {
        return Observable.create { observer in
            // Alamofire ile HTTP isteği
            AF.request(url, method: .get).validate().response{ response in
                switch response.result {
                case .success(let data):
                    do {
//                        if let jsonString = String(data: data!, encoding: .utf8) {
//                                    print("Response Data: \(jsonString)")  // JSON verisini konsola yazdır
//                                } else {
//                                    print("Data couldn't be converted to string.")
//                                }
                        // Gelen JSON verisini çöz
                        let decodedResponse = try JSONDecoder().decode(ResponseWrapper.self, from: data!)
                                            // "results" içerisindeki makaleleri al
                        let articles = decodedResponse.results
                        
                                            // Veriyi gözlemcilere ilet
                        observer.onNext(articles)
                        
                                            // İşlemi tamamla
                        observer.onCompleted()
                    } catch let decodingError{
                        // JSON parsing hatası
                        //observer.onError(error)
                        print("Decoding error: \(decodingError)")
                    }
                case .failure(let error):
                    // Ağ çağrısı hatası
                    observer.onError(error)
                    print("hataa: \(error.localizedDescription)")
                }
            }
            // Bellek yönetimi için Disposable oluştur
            return Disposables.create()
        }
    }
}

