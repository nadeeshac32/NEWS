//
//  RestClientError.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 15/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//


typealias ErrorCallback             = (_ error: RestClientError) -> Void
typealias SuccessEmptyDataCallback  = () -> Void

public enum RestClientError: Error {
	case AlamofireError(message: String)
	
	case JsonParseError(message: String)
	
    case ServerError(code: String, message: String)
    
	case UndefinedError
	
	case EmptyDataError
}


extension RestClientError {
	init(jsonResult: Dictionary<String, Any>?) {
		if let status               = jsonResult?["status"] as? String, status == "error",
            let code                = jsonResult?["code"] as? String,
            let message             = jsonResult?["message"] as? String {
            self                    = .ServerError(code: code, message: message)
		} else {
			self                	= .UndefinedError
		}
	}
}


extension RestClientError: CustomStringConvertible {
	public var description: String {
		switch self {
		case let .AlamofireError(message)           : return    "Alamofire error -> message: \(message)"
		case let .JsonParseError(message)           : return    "Json Parse error -> message: \(message)"
        case let .ServerError(code, message)        : return    "Server error -> code: \(code), message: \(message)"
		case .UndefinedError                        : return    "Error Not Registered"
		case .EmptyDataError 						: return 	"Error Response Empty"
		}
	}
}
