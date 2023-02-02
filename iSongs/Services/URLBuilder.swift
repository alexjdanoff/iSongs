//
//  URLBuilder.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 30.01.2023.
//

import Foundation

class URLBuilder {
    
    func buildTrackSearch(searchText: String) -> URL? {
        var components = URLComponents()
        let searchTrackLimit = 100
        let mediaType = "music"
        
        components.scheme = BaseURLs.scheme.rawValue
        components.host = BaseURLs.baseUrl.rawValue
        components.path = BaseURLs.searchPath.rawValue
        
        let querySearchText = URLQueryItem(name: BaseURLs.querySearchText.rawValue,
                                           value: searchText)
        let queryResultCount = URLQueryItem(name: BaseURLs.queryResultCount.rawValue,
                                            value: String(searchTrackLimit))
        let queryMediaType = URLQueryItem(name: BaseURLs.queryMediaType.rawValue,
                                          value: mediaType)
        
        components.queryItems = [querySearchText, queryResultCount, queryMediaType]
        
        return components.url
    }
    
    func buildTrackDetailsSearch(trackID id: Int) -> URL? {
        var components = URLComponents()
        
        components.scheme = BaseURLs.scheme.rawValue
        components.host = BaseURLs.baseUrl.rawValue
        components.path = BaseURLs.searchSongsPath.rawValue
        
        let querySongsAlbumID = URLQueryItem(name: BaseURLs.querySongsAlbumId.rawValue,
                                             value: String(id))
        
        components.queryItems = [querySongsAlbumID]

        return components.url
    }
}

fileprivate enum BaseURLs: String {
    
    case scheme = "https"
    case baseUrl = "itunes.apple.com"
    case searchPath = "/search"
    
    case querySearchText = "term"
    case queryResultCount = "limit"
    case queryMediaType = "media"
    
    case searchSongsPath = "/lookup"
    case querySongsAlbumId = "id"
}

