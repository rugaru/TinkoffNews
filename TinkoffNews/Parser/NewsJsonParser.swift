//
//  Converter.swift
//  TinkoffNews
//
//  Created by Alina Usmanova on 27.07.17.
//  Copyright © 2017 Alina Usmanova. All rights reserved.
//

import UIKit

class NewsJsonParser: NSObject {
    
    class func parseNews(newsJson: [String: Any]) -> [NewsContent] {
        var news = [NewsContent]()
        let payload = newsJson["payload"] as! Array<[String: Any]>
        for item in payload {
            let milliseconds = (item["publicationDate"] as! [String: Int])["milliseconds"]!/1000
            let attributedString = try! NSAttributedString(
                data: (item["text"] as! String).data(using: String.Encoding.unicode, allowLossyConversion: true)!,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            let n = NewsContent(id: item["id"] as! String,
                                text: attributedString.string,
                                publicationDate: Date(timeIntervalSince1970: TimeInterval(milliseconds)), content: "")
            news.append(n)
        }
        return news
    }
    
    class func parseContent(contentJson: [String: Any]) -> String {
        let payload = contentJson["payload"] as! [String: Any]
        let attributedString = try! NSAttributedString(
            data: (payload["content"] as! String).data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        return attributedString.string
    }
}
