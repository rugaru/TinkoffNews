//
//  NewsApi.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 30.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class NewsApi: NSObject {
    
    private let apiUrl = "https://api.tinkoff.ru/v1/"
    
    public func getNews(completion:@escaping(_ result: Result<[NewsContent]>) -> ()) {
        let url = URL(string: apiUrl + "news")
        dataTask(with: url!) { result in
            switch result {
            case .success(let value):
                completion(Result {return NewsJsonParser.parseNews(newsJson: value)})
            case .failure(let error):
                completion(Result {throw error})
            }
        }
    }
    
    public func getContent(newsId: String, completion:@escaping(_ result: Result<String>) -> ()) {
        let url = URL(string: apiUrl + "news_content?id=" + newsId)
        dataTask(with: url!) { result in
            switch result {
            case .success(let value):
                completion(Result {return NewsJsonParser.parseContent(contentJson: value)})
            case .failure(let error):
                completion(Result {throw error})
            }
        }
    }
    
    private func dataTask(with url: URL, completionHandler: @escaping (Result<[String: Any]>) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil || response == nil {
                completionHandler(Result {throw error!})
                return
            }
            guard let json = try? JSONSerialization.jsonObject(with: data!) as? [String: Any] else {
                completionHandler(Result {throw error!})
                return
            }
            completionHandler(Result {return json!})
        }
        task.resume()
    }
}

enum Result<Value> {
    case success(value: Value)
    case failure(error: NSError)
    
    init(_ f: () throws -> Value) {
        do {
            let value = try f()
            self = .success(value: value)
        }catch let error as NSError {
            self = .failure(error: error)
        }
    }
}
