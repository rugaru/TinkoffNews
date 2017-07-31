//
//  NewsContentPresenter.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 28.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

protocol NewsContentPresenter {
}

protocol NewsContentView: NSObjectProtocol {
    func showNews(content: NewsContent)
    func showError(message: String)
}

class NewsContentPresenterImpl: NewsContentPresenter {
    weak fileprivate var view: NewsContentView?
    fileprivate var api = NewsApi()
    
    init(news: NewsContent, view: NewsContentView) {
        self.view = view
        loadContent(news: news)
    }
    
    private func loadContent(news: NewsContent) {
        var news = news
        api.getContent(newsId: news.id) {[weak self] result in
            switch result {
            case .success(let value):
                news.content = value
                self?.view?.showNews(content: news)
            case .failure(let error):
                self?.view?.showError(message: error.localizedDescription)
            }
        }
    }
}
