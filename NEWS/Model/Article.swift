//
//  Articles.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 15/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import Foundation

struct Article: Decodable {
    let source: Source?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}
