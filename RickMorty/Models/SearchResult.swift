//
//  SearchResult.swift
//  RickMorty
//
//  Created by Govardhan Mathi on 1/28/26.
//

import Foundation

enum SearchResult {
    case loading
    case success([Character])
    case error(String)
}
