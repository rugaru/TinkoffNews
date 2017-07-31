//
//  MainPresenter.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 28.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

protocol MainPresenter {
    func refreshNews()
    func getNext()
}

protocol MainView: NSObjectProtocol {
    func displayRefreshNews(news: [NewsContent])
    func showError(message: String)
    func displayNextNews(news: [NewsContent])
}

class MainPresenterImpl: MainPresenter {

    weak fileprivate var view: MainView?
    fileprivate var newsIterator: NewsIteratorProtocol
    fileprivate var cachedNewsReader: NewsReader
    
    fileprivate var news: [NewsContent] {
        return newsIterator.getNext(fetchLimit: 20)
    }
    
    init(view: MainView) {
        self.view = view
        cachedNewsReader = CachedNewsReader()
        newsIterator = cachedNewsReader.createNewsIterator()
        loadNews()
    }
    
    private func loadNews() {
        if newsIterator.isEmpty() {
            refreshNews()
        } else {
            self.view?.displayRefreshNews(news: news)
        }
    }
    
    func refreshNews() {
        cachedNewsReader.refreshNews(completion: {[weak self] result in
            switch result {
            case .success(_):
                self?.newsIterator = (self?.cachedNewsReader.createNewsIterator())!
                self?.view?.displayRefreshNews(news: (self?.news)!)
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        })
    }
    
    func getNext() {
        view?.displayNextNews(news: news)
    }
}
