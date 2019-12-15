//
//  AppConfig.swift
//  NEWS
//
//  Created by Nadeesha Lakmal on 14/12/2019.
//  Copyright © 2019 Nadeesha. All rights reserved.
//

import UIKit
import CoreLocation

let configFileName:String = "Configuration"

class AppConfig: NSObject, CLLocationManagerDelegate {
	
	static let si               = AppConfig()
	private var configDict      : NSDictionary?
	
	let defaults            	= UserDefaults.standard
	
	var appName: String! {
		guard let string        = getValue(key: "appName") else { return "" }
		return (string as! String)
	}
	
	
	// MARK: - url variables
	var url: NSDictionary! {
		guard let urlArray      = getValue(key: "url") else { return [:] }
		return (urlArray as! NSDictionary)
	}
	
	var baseUrl: String! {
		guard let string        = url["domain"] else { return "" }
		return (string as! String)
	}
	
	
	// MARK: - API keys
	var apiKeys: NSDictionary! {
		guard let keysArray     = getValue(key: "apiKeys") else { return [:] }
		return (keysArray as! NSDictionary)
	}
	
	var newsAPIKey: String! {
		guard let string        = apiKeys["newsAPIKey"] else { return "" }
		return (string as! String)
	}
	
	// MARK: - system variables
	var memoryCapacity:Int {
		guard let int           = getValue(key: "memoryCapacity") else { return 0 }
		return (int as! Int) * 1024 * 1024
	}
	
	var diskCapacity:Int {
		guard let int           = getValue(key: "diskCapacity") else { return 0 }
		return (int as! Int) * 1024 * 1024
	}
	
	var urlCache:URLCache {
		let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "FreelancerDiskpath")
		return cache
	}
    
    var newsTVCellHeight        = 110
    var newsCVCellSize          = CGSize(width: UIScreen.main.bounds.width , height:340)
	
	
	//MARK: - Colors
	let colorPrimary            = #colorLiteral(red: 0.420697093, green: 0.3667229414, blue: 0.7243047357, alpha: 1)
	let colorSubDetail 			= #colorLiteral(red: 0.6078431373, green: 0.5960784314, blue: 0.6274509804, alpha: 1)
	
	
	//MARK: - RestClientError constants
	var localErrors: NSDictionary! {
		guard let dict          = getValue(key: "localErrors") else { return [:] }
		return (dict as! NSDictionary)
	}
	
	var jsonParseError: (code: Int, msg: String) {
		let dict                = localErrors["jsonParseError"] as! NSDictionary
		return (dict["code"] as! Int ,msg: dict["message"] as! String)
	}
	
	var undefinedError: (code: Int, msg: String) {
		let dict                = localErrors["undefinedError"] as! NSDictionary
		return (dict["code"] as! Int ,msg: dict["message"] as! String)
	}
	
	
	//MAEK: - Specific image names
	let default_ImageName       = "default_image"
	
	
	//MARK: - init
	override private init() {
		super.init()
		self.startCofigManager()
	}
	
	func startCofigManager() {
		if let plist = Plist(name: configFileName) {
			configDict          = plist.getValuesInPlistFile()
		} else {
			print("AppConfig -> startManager : Unable to start")
		}
	}
	
	func getValue(key:String) -> AnyObject? {
		var value:AnyObject?
		if let dict = configDict {
			let keys = Array(dict.allKeys)
			//print("[Config] Keys are: \(keys)")
			if keys.count != 0 {
				for (_,element) in keys.enumerated() {
					//print("[Config] Key Index - \(index) = \(element)")
					if element as! String == key {
						//print("[Config] Found the Item that we were looking for for key: [\(key)]")
						value = dict[key]! as AnyObject
						break
					}
				}
				
				if value != nil {
					return value!
				} else {
					print("[AppConfig] WARNING: The Item for key '\(key)' does not exist! Please, check your spelling.")
					return .none
				}
			} else {
				print("[AppConfig] No Plist Item Found when searching for item with key: \(key). The Plist is Empty!")
				return .none
			}
		} else {
			print("[AppConfig] -> getValue : Unable to get Plist")
			return .none
		}
	}
}
