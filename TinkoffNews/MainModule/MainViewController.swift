//
//  MainViewController.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 26.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    fileprivate let refreshControl = UIRefreshControl()
    
    fileprivate var presenter: MainPresenter?
    fileprivate var news = [NewsContent]()
    
    fileprivate var flowLayout: UICollectionViewFlowLayout {
        return collectionView.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MainPresenterImpl(view: self)
        refreshConfigure()
        collectionViewConfigure()
        collectionView.contentSize = view.frame.size
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension MainViewController: MainView {
    func displayRefreshNews(news: [NewsContent]) {
        self.news = news
        endRefreshing()
    }
    
    func displayNextNews(news: [NewsContent]) {
        DispatchQueue.main.async {
            self.news.append(contentsOf: news)
            self.collectionView.reloadData()
        }
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .cancel, handler: { [weak self] _ in
            self?.endRefreshing()
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension MainViewController {
    fileprivate func endRefreshing() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func refreshConfigure() {
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    fileprivate func collectionViewConfigure() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.register(UINib(nibName: "MainCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        flowLayout.estimatedItemSize = CGSize(width: collectionView.frame.width, height: 100)
    }
    
    @objc fileprivate func refreshNews() {
        presenter?.refreshNews()
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height && contentHeight > 0 {
            presenter?.getNext()
        }
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        navigationController?.pushViewController(NewsContentViewController().instantiateViewController(news: news[indexPath.row]), animated: true)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! MainCell
        cell.title.text = news[indexPath.row].text
        cell.date.text = news[indexPath.row].publicationDate.toString()
        return cell
    }
}

