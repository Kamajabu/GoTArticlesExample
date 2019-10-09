//
//  ApiClient.swift
//  GoTArticlesExample
//
//  Created by Kamil Buczel on 17/09/2019.
//  Copyright © 2019 Kamajabu. All rights reserved.
//

import Foundation
import RxSwift

/// Using RxSwift here is a bit overkill, but as this is "show us what you would normally use" kind of app, then welp, why not ;)

struct Network {
    static let BASE_URL = "gameofthrones.fandom.com"

    static let articlesEndpoint = "/api/v1/Articles/Top"
}

enum NetworkError: Error {
    case badURL
    case noData
    case mappingError(error: Error)
}

enum DataError: Error {
    case cantParseJSON
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}

/// Configured that all requests are made on ConcurrentDispatchQueueScheduler(qos: .background)
protocol NetworkClient: class {
    func getWikiaArticles(withLimit: Int) -> Single<WikiaArticles>
    func getImageData(from address: String) -> Single<Data>

    var urlComponents: URLComponents { get }
}

class ApiClient: NetworkClient {
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = Network.BASE_URL
        return urlComponents
    }
    
    private let urlSession = URLSession.shared

    func getWikiaArticles(withLimit _: Int) -> Single<WikiaArticles> {
        let parameters: [String: String] = ["expand": "1",
                                            "category": "Articles",
                                            "limit": "75"]

        var urlComponents = self.urlComponents
        urlComponents.path = Network.articlesEndpoint
        urlComponents.setQueryItems(with: parameters)

        return fetchData(from: urlComponents.url)
            .flatMap(mapWikaArticles)
    }
    
    func getImageData(from address: String) -> Single<Data> {
        return fetchData(from: URL(string: address))
    }

    private func mapWikaArticles(_ jsonData: Data) -> Single<WikiaArticles> {
        return Single<WikiaArticles>.create { single in

            do {
                let decodedData = try JSONDecoder().decode(WikiaArticles.self, from: jsonData)
                single(.success(decodedData))
            } catch {
                let mappingError = NetworkError.mappingError(error: error)
                single(.error(mappingError))
            }

            return Disposables.create()
        }
    }

    private func fetchData(from url: URL?) -> Single<Data> {
        return Single<Data>.create { single in

            guard let url = url else {
                single(.error(NetworkError.badURL))
                return Disposables.create()
            }

            let task = URLSession.shared.dataTask(with: url) { data, _, error in
                if let error = error {
                    single(.error(error))
                    return
                }

                guard let data = data else {
                    return single(.error(NetworkError.noData))
                }

                single(.success(data))
            }

            task.resume()

            return Disposables.create { task.cancel() }
        }.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
    }
}
