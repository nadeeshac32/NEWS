//
//  NewsAPIProtocol.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 15/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import Alamofire

protocol NewsAPIProtocol {
    func getTopHeadlines(method: HTTPMethod!,
                         country: String!,
                         category: String!,
                         sources: String!,
                         q: String!,
                         pageSize: Int!,
                         page: Int!,
                         onSuccess: ((_ articles: [Article]) -> Void)?,
                         onError: ErrorCallback?)
    
    func getEveryNews(method: HTTPMethod!,
                      q: String!,
                      qInTitle: String!,
                      sources: String!,
                      domains: String!,
                      excludeDomains: String!,
                      from: String!,
                      to: String!,
                      language: String!,
                      sortBy: String!,
                      pageSize: Int!,
                      page: Int!,
                      onSuccess: ((_ articles: [Article]) -> Void)?,
                      onError: ErrorCallback?)
}
