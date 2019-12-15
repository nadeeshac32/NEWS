//
//  NewsAPIResponse.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 15/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import Foundation

struct NewsAPIResponse: Decodable {
    let status: String
    let totalResults: Int?
    let articles: [Article]?
}
