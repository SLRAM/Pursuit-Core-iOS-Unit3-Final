//
//  ElementAPIClient.swift
//  Elements
//
//  Created by Stephanie Ramirez on 1/4/19.
//  Copyright © 2019 Pursuit. All rights reserved.
//

import Foundation

final class ElementAPIClient {
    static func getElements(completionHandler: @escaping(AppError?, [ElementData]?) -> Void) {
        NetworkHelper.shared.performDataTask(endpointURLString: "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/elements", httpMethod: "GET", httpBody: nil) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError, nil)
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode(String(statusCode)), nil)
                    return
            }
            if let data = data {
                do {
                    let elementData = try JSONDecoder().decode([ElementData].self, from: data)
                    completionHandler(nil, elementData)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }
    }

    static func getElementImage(num: Int)-> String {
        var elementUrlNumber = ""
        switch num {
        case 1...9:
            elementUrlNumber = "00\(num)"
        case 10...99:
            elementUrlNumber = "0\(num)"
        case 100...:
            elementUrlNumber = String(num)
        default:
            elementUrlNumber = "000"
        }
        
        return("http://www.theodoregray.com/periodictable/Tiles/\(elementUrlNumber)/s7.JPG")
    }
    
    static func favoriteElement(data: Data, completionHandler: @escaping (AppError?, Bool) -> Void) {
        NetworkHelper.shared.performUploadTask(endpointURLString: "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites", httpMethod: "POST", httpBody: data) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError, false)
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode(String(statusCode)), false)
                    return
            }
            if let _ = data {
                completionHandler(nil, true)
            }
        }
    }
    
    static func getFavorites(name: String, completionHandler: @escaping (AppError?, [Favorite]?) -> Void) {
        let getFavoritesEndpoint = "https://5c1d79abbc26950013fbcaa9.mockapi.io/api/v1/favorites?search=\(name)"
        NetworkHelper.shared.performDataTask(endpointURLString: getFavoritesEndpoint, httpMethod: "GET", httpBody: nil) { (appError, data, httpResponse) in
            if let appError = appError {
                completionHandler(appError, nil)
            }
            guard let response = httpResponse,
                (200...299).contains(response.statusCode) else {
                    let statusCode = httpResponse?.statusCode ?? -999
                    completionHandler(AppError.badStatusCode(String(statusCode)), nil)
                    return
            }
            if let data = data {
                do {
                    let favorites = try JSONDecoder().decode([Favorite].self, from: data)
                    completionHandler(nil, favorites)
                } catch {
                    completionHandler(AppError.decodingError(error), nil)
                }
            }
        }
    }
}
