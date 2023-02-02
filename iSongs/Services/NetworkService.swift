//
//  NetworkService.swift
//  iSongs
//
//  Created by Alexandru Jdanov on 27.01.2023.
//

import Foundation

class NetworkService {
    
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchData<T:Codable>(from url: URL, resultType: T.Type, complition: @escaping(Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                complition(.failure(error))
            }
            if let data = data, let parsedJSON = self.parseJSON(data: data, responseType: resultType.self)  {
                complition(.success(parsedJSON))
            } else {
                complition(.failure(CustomErrors.wrongData))
            }
        }
        task.resume()
    }
    
    private func parseJSON<T: Codable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let json = try? decoder.decode(T.self, from: data) {
            return json
        }
        return nil
    }
}

enum CustomErrors: Error {
    
    case wrongData
    case serverEnable
    case searchResultEmpty
}
extension CustomErrors: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .wrongData:
            return "Data was corrupted"
        case .serverEnable:
            return "Server is not available right now"
        case .searchResultEmpty:
            return "Search result is empty"
        }
    }
}
