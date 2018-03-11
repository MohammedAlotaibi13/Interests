//
//  Constants.swift
//  Interest
//
//  Created by محمد عايض العتيبي on 3/2/1439 AH.
//  Copyright © 1439 code schoole. All rights reserved.
//

import Foundation

struct Constants {
    
    struct Bloomberg {
        static let ApiScheme = "https"
        static let ApiHost = "newsapi.org"
        static let apiPath = "/v2/top-headlines"
    }
    
    struct ParametrKeys {
        static let apiKey = "apiKey"
        static let source = "sources"
    }
    
    struct ParametrValue {
        static let apiKey = "f8c65cfeea364fdb99bb9ecadc5bbd07"
        static let source = "bloomberg"
    }
    
    struct ResponseKey {
        static let statue = "status"
        static let article = "articles"
        static let author = "author"
        static let title = "title"
        static let description = "description"
        static let url = "url"
        static let image = "urlToImage"
        static let publishedAt = "publishedAt"
    }
    
    struct ResponseValue {
        static let statue = "ok"
    }
    
    struct firebase {
        static let name = "Name"
        static let duration = "Duration"
        static let interestRate = "InterestRate"
        static let totalLoan = "Total loan"
        static let instalment = "instalment"
        static let toatalLoanNonSaaudi = "NonSaudiTotalLoan"
    }
}
