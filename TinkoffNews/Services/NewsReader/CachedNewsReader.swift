//
//  NewsReader.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 30.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class CachedNewsReader: NewsReader {
    fileprivate var dataBaseService: DataBaseService
    fileprivate var apiService: NewsApi
    
    init() {
        dataBaseService = DataBaseService()
        apiService = NewsApi()
    }
    
    func createNewsIterator() -> NewsIteratorProtocol {
        return dataBaseService.getNewsIterator()
    }
    
    func refreshNews(completion:@escaping(_ result: Result<Bool>) -> ()) {
        apiService.getNews { result in
            switch result {
            case .success(let value):
                self.dataBaseService.saveOrUpdate(newsModels: value)
                completion(Result { return true})
            case .failure(let error):
                completion(Result{ throw error})
                break
            }
        }
    }
}
