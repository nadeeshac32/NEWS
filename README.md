# NEWS
iOS Test - using [`News API`](https://newsapi.org)

## Requirements:
- [x] Xcode Version 10.3
- [x] Swift 5
- [x] iOS Version 12.0 or above 

## Features
* Fetches Top headlines and user preferred news and displays
	* For headlines, user can select categories from a tab view
	* For user preferred news, user can select keywords from a tab view
	* Clickable link to the original post
	* Paginated response with infinite scroll
* Two Orientations for News collection
	* Table View (List View)
  * Collection View (Grid View)
* Categories or Keywords selection Tab bar
  
## Xcode Project General changes
 - Change the Team to your own Team
 
## Project Architecture and Related details

Specifics                 | Details
--------------------------|------------------------------------------------------------------------
| Master branch 	| Using RxSwift for MVVM is lot easier than using Closures. 
| Architecture - MVVM     | Advantages of MVVM: <br/>- High distribution of responsibilities among Model, View, ViewModel <br/>- ViewModel knows nothing about the View. It allows to test easily
| Networking - Alamofire    | Check following list of files: <br/>- `Network\HTTPService.swift` <br/>- `Network\NewsAPIProtocol.swift` <br/>
| Models                  | All the models used by the app reside within this folder. Almost all the models which are consumed by the Network Services are extending `Decodable` class.
| Views                   | All the UI elements are built within this folder. Every view is emplemented programmatically, so no Nib files are a used. `News_V` is re-used in both Headlines_VC and UserPreferred_VC.
| ViewModel               | ViewModel bindes Model and Views together. And all the logic goes here.
| App Config         	  | Used a simple Singleton class to keep the configuration parameters


## To-do
- News Detail View Controller
- Writing comments
- Profile View Controller (Managing user details)


## License

Copyright (c) Nadeesha Lakmal.
