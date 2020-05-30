//
//  MoviesAPIService.swift
//  Movies
//
//  Created by Emin Emini on 11/05/2020.
//  Copyright © 2020 Emin Emini. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var selectedCompany = 1

class MoviesAPIService {
    
    typealias MoviesListAPIResult = (moviesList:[Movie] , nextPage: Int?, totalPages:Int)
    
    class func getMoviesList (moviesType : String, pageNumber: Int ,completion: @escaping (MoviesListAPIResult?) -> Void) {
        let moviesURL = getMoviesListURL(moviesType: moviesType , page: pageNumber)
        Alamofire.request(moviesURL).responseJSON { response in
            var moviesList: [Movie] = []
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                if let moviesJsonList = json["results"].array {
                    for movie in moviesJsonList {
                        moviesList.append(Movie(movieJson: movie))
                    }
                }
                let currentPage = json["page"].int!
                let totalPages = json["total_pages"].int!
                let nextPage = currentPage+1 < totalPages ? currentPage+1 : nil
                completion((moviesList , nextPage , totalPages))
            } else {
                completion(nil)
            }    
        }
    }
    
    class func getMoreDetailedMovie (movieId : Int, completion: @escaping (Movie?) -> Void) {
        let moviesURL = getMovieDetailsUrl(movieId: movieId)
        Alamofire.request(moviesURL).responseJSON { response in
            if response.result.isSuccess{
                completion (Movie(movieJson: JSON(response.result.value!)))
            }
            else{
                completion(nil)
            }
        }
    }
    
    class func getSimilarMovies (movieId: Int , completion: @escaping ([Movie]?) -> Void) {
        let moviesURL = getSimilarMoviesUrl(movieId:movieId)
        print("About to get similar movies")
        Alamofire.request(moviesURL).responseJSON { response in
            var moviesList: [Movie] = []
            debugPrint(response)
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                if let moviesJsonList = json["results"].array {
                    for movie in moviesJsonList {
                        moviesList.append(Movie(movieJson: movie))
                    }
                }
                completion(moviesList)
            } else {
                completion(nil)
            }
        }
    }
    
    class func getMovieDetailsUrl(movieId: Int) -> String {
        return "\(appendAPIKeyToURL(url: "\(Constants.BASE_URL)movie/\(movieId)", isOneQueryParam: true))&append_to_response=videos"
    }
    
    class func  getSimilarMoviesUrl(movieId: Int) -> String{
        return appendAPIKeyToURL(url: "\(Constants.BASE_URL)movie/\(movieId)/similar", isOneQueryParam: true)
    }
    
    class func getPosterImageUrl(imagePath: String) -> String {
        return "\(Constants.POSTER_BASE_URL)\(imagePath)"
    }
    
    class func getBackDropImageUrl(imagePath: String) -> String {
        return "\(Constants.BACK_DROP_BASE_URL)\(imagePath)"
    }
    
    class func getMoviesListURL(moviesType: String , page:Int) -> String {
        if isShowingCompanies {
            let currentDate = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let dateResult = formatter.string(from: currentDate)
            
            return appendAPIKeyToURL2(url:"\(Constants.BASE_URL)discover/movie" , appendix: "page=1&release_date.lte=\(dateResult)&\(moviesType)=\(selectedCompany)", isOneQueryParam: false)
        } else {
            return appendAPIKeyToURL(url:"\(Constants.BASE_URL)movie/\(moviesType)?page=\(page)" , isOneQueryParam: false)
        }
        
    }
    
    class func appendAPIKeyToURL(url: String, isOneQueryParam: Bool) -> String {
        let separator = isOneQueryParam ? "?" : "&"
        print("\(url)\(separator)api_key=\(Constants.API_KEY)")
        return "\(url)\(separator)api_key=\(Constants.API_KEY)"
    }
    
    class func appendAPIKeyToURL2(url: String, appendix: String, isOneQueryParam: Bool) -> String {
        let separator = isOneQueryParam ? "?" : "&"
        print("\(url)?api_key=\(Constants.API_KEY)\(separator)sort_by=primary_release_date.desc\(separator)\(appendix)")
        return "\(url)?api_key=\(Constants.API_KEY)\(separator)sort_by=primary_release_date.desc\(separator)\(appendix)"
    }
}

enum MoviesType: String {
    case popular = "popular"
    case upcoming = "upcoming"
    case nowPlaying = "now_playing"
    case topRated = "top_rated"
    case companies = "with_companies"
}


var company1List = [Movie]()
var company2List = [Movie]()
var company3List = [Movie]()
var company4List = [Movie]()
var company5List = [Movie]()
