//
//  HTTPService.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 15/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import Alamofire

class HTTPService: NSObject {
	var baseUrl                                 	: String?
	var parameters                              	: Parameters?
	var headers                                 	: [String : String]?
	
	init(baseUrl: String! = AppConfig.si.baseUrl) {
		self.baseUrl                            	= baseUrl
		parameters                              	= [:]
		headers                                 	= [
			"Content-Type"                      	: "application/json",
            "Authorization"                         : AppConfig.si.newsAPIKey
		]
	}
	
	func genericRequest<T: Decodable>(method: HTTPMethod, parameters: Parameters?, contextPath: String, responseType: T.Type, onError: ErrorCallback? = nil, completionHandler: @escaping (T?, [T]?) -> Void) {
		
		let urlString                           	= "\(self.baseUrl!)/\(contextPath)"
		self.parameters?.update(other: parameters)
		let request 								= Alamofire.request(urlString,
																		method: method,
																		parameters: method == .get ? nil : self.parameters!,
																		encoding: JSONEncoding.default,
																		headers: self.headers!)
		
		request.responseJSON { response in
			var exception                       	: RestClientError?
			if let errorMessage = response.error?.localizedDescription {
                exception                       	= RestClientError.AlamofireError(message: errorMessage)
			} else {
				if let responseData = response.data {
					if (200..<300).contains((response.response?.statusCode)!) {
                        if let _ = response.result.value as? [Dictionary<String, Any>] {
                            do {
                                let responseItemsArray = try JSONDecoder().decode([T].self, from: responseData)
                                completionHandler(nil, responseItemsArray)
                                return
                            } catch {
                                exception           = RestClientError.JsonParseError(message: AppConfig.si.jsonParseError.msg)
                            }
                        } else {
                            do {
                                let responseObject  = try JSONDecoder().decode(T.self, from: responseData)
                                completionHandler(responseObject, nil)
                                return
                            } catch {
                                exception           = RestClientError.JsonParseError(message: AppConfig.si.jsonParseError.msg)
                            }
                        }
					} else if let dataObject = response.result.value as? Dictionary<String, Any> {
						exception           		= RestClientError.init(jsonResult: dataObject)
					} else {
                        exception       			= RestClientError.JsonParseError(message: AppConfig.si.jsonParseError.msg)
					}
				} else {
					exception             			= RestClientError.EmptyDataError
				}
			}
			
			if let error = exception {
				print("")
				print("request                      : \(request.debugDescription)")
				print("status code                  : \(String(describing: response.response?.statusCode))")
				print("error                        : \(error)")
                print("baseUrl                      : \(self.baseUrl ?? "")")
				print("contextPath                  : \(contextPath)")
				print("parameters                   : \(String(describing: self.parameters))")
				print("")
				onError?(error)
				return
			}
		}
	}
}

extension HTTPService: NewsAPIProtocol {
    func getTopHeadlines(method: HTTPMethod! = .get,
                         country: String! = "",
                         category: String! = "",
                         sources: String! = "",
                         q: String! = "",
                         pageSize: Int! = 20,
                         page: Int! = 0,
                         onSuccess: (([Article]) -> Void)?,
                         onError: ErrorCallback?) {
        
        var contextPath = "top-headlines"
        contextPath += "?country=\(country!)"
        contextPath += "&category=\(category!)"
        contextPath += "&sources=\(sources!)"
        contextPath += "&q=\(q!)"
        contextPath += "&pageSize=\(pageSize!)"
        contextPath += "&page=\(page!)"
        
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: NewsAPIResponse.self, onError: onError, completionHandler: { (newsAPIResponse, _) in
            if let articles = newsAPIResponse?.articles {
                onSuccess?(articles)
                return
            }
        })
    }
    
    func getEveryNews(method: HTTPMethod! = .get,
                      q: String! = "",
                      qInTitle: String! = "",
                      sources: String! = "",
                      domains: String! = "",
                      excludeDomains: String! = "",
                      from: String! = "",
                      to: String! = "",
                      language: String! = "",
                      sortBy: String! = "",
                      pageSize: Int! = 20,
                      page: Int! = 0,
                      onSuccess: (([Article]) -> Void)?,
                      onError: ErrorCallback?) {
        
        var contextPath = "everything"
        contextPath += "?q=\(q!)"
        contextPath += "&qInTitle=\(qInTitle!)"
        contextPath += "&sources=\(sources!)"
        contextPath += "&domains=\(domains!)"
        contextPath += "&excludeDomains=\(excludeDomains!)"
        contextPath += "&from=\(from!)"
        contextPath += "&to=\(to!)"
        contextPath += "&language=\(language!)"
        contextPath += "&sortBy=\(sortBy!)"
        contextPath += "&pageSize=\(pageSize!)"
        contextPath += "&page=\(page!)"
        
        genericRequest(method: method!, parameters: nil, contextPath: contextPath, responseType: NewsAPIResponse.self, onError: onError, completionHandler: { (newsAPIResponse, _) in
            if let articles = newsAPIResponse?.articles {
                onSuccess?(articles)
                return
            }
        })
    }
}
