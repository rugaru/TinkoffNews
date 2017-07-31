//
//  NewsReader.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 30.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

protocol NewsReader {
    func createNewsIterator() -> NewsIteratorProtocol
    func refreshNews(completion:@escaping(_ result: Result<Bool>) -> ())
}


