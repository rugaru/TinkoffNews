//
//  NewsContentViewController.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 28.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class NewsContentViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    fileprivate var presenter: NewsContentPresenter?
    
    func instantiateViewController(news: NewsContent) -> UIViewController {
        let view = UIStoryboard(name: "NewsContentViewController", bundle: nil)
            .instantiateViewController(withIdentifier: "NewsContentViewControllerId") as! NewsContentViewController
        view.presenter = NewsContentPresenterImpl(news: news, view: view as NewsContentView)
        return view as UIViewController
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.lineBreakMode = .byWordWrapping
        contentLabel.adjustsFontSizeToFitWidth = true
        contentLabel.lineBreakMode = .byWordWrapping
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension NewsContentViewController: NewsContentView {
    func showNews(content: NewsContent) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.titleLabel.text = content.text
            self.dateLabel.text = content.publicationDate.toString()
            self.contentLabel.text = content.content
            self.titleLabel.sizeToFit()
            self.contentLabel.sizeToFit()
            self.scrollView.contentSize = self.contentSize()
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension NewsContentViewController {
    fileprivate func contentSize() -> CGSize {
        let contentHeight = titleLabel.frame.height + dateLabel.frame.height + contentLabel.frame.height + 4*16
        return CGSize(width: scrollView.frame.width, height: contentHeight)
    }
}
