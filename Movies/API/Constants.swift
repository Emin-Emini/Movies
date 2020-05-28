//
//  Constants.swift
//  Movies
//
//  Created by Emin Emini on 11/05/2020.
//  Copyright © 2020 Emin Emini. All rights reserved.
//

import Foundation

struct Constants {
    static let API_KEY = "5018815e8ba8370cd1ca9f94183aba1a"
    static let BASE_URL = "https://api.themoviedb.org/3/"
    static let MOVIE_URL = "movie/"
    static let DISCOVER_URL = "discover/movie"
    static let MOVIE_SEARCH_BASE_URL = "https://api.themoviedb.org/3/search/movie"
    static let IMAGES_BASE_URL = "https://image.tmdb.org/t/p/"
    static let BACK_DROP_BASE_URL = IMAGES_BASE_URL + "w500"
    static let POSTER_BASE_URL = IMAGES_BASE_URL + "w185"
    static let KEY_POPULAR = "popular"
    static let KEY_UPCOMING = "upcoming"
    static let KEY_TOP_RATED = "top_rated"
    static let KEY_NOW_PLAYING = "?with_company=3&"
}
