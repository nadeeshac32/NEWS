//
//  Plist.swift
//  Plist
//
//  Created by Nadeesha Lakmal on 5/19/19.
//  Copyright © 2019 Nadeesha Lakmal. All rights reserved.
//

import Foundation
struct Plist {
	
	enum PlistError: Error {
		case FileNotWritten
		case FileDoesNotExist
	}
	
	let name:String
	
	var sourcePath:String? {
		guard let path = Bundle.main.path(forResource: name, ofType: "plist") else { return .none }
		return path
	}
	
	var destPath:String? {
		guard sourcePath != .none else { return .none }
		let dir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
		return (dir as NSString).appendingPathComponent("\(name).plist")
	}
	
	init?(name:String) {    // saves plist in app’s Documents directory
		
		self.name = name
		
		let fileManager = FileManager.default
		
		guard let source = sourcePath else { return nil }
		guard let destination = destPath else { return nil }
		guard fileManager.fileExists(atPath: source) else { return nil }
		
		if !fileManager.fileExists(atPath: destination) {
			
			do {
				try fileManager.copyItem(atPath: source, toPath: destination)
			} catch let error as NSError {
				print("[PlistManager] Unable to copy file. ERROR: \(error.localizedDescription)")
				return nil
			}
		}
	}
	
	func getValuesInPlistFile() -> NSDictionary? {
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: destPath!) {
			guard let dict = NSDictionary(contentsOfFile: destPath!) else { return .none }
			return dict
		} else {
			return .none
		}
	}
	
	func getMutablePlistFile() -> NSMutableDictionary?{
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: destPath!) {
			guard let dict = NSMutableDictionary(contentsOfFile: destPath!) else { return .none }
			return dict
		} else {
			return .none
		}
	}
	
	func addValuesToPlistFile(dictionary:NSDictionary) throws {
		let fileManager = FileManager.default
		if fileManager.fileExists(atPath: destPath!) {
			if !dictionary.write(toFile: destPath!, atomically: false) {
				print("[PlistManager] File not written successfully")
				throw PlistError.FileNotWritten
			}
		} else {
			throw PlistError.FileDoesNotExist
		}
	}
	
}
