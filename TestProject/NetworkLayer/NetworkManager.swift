//
//  NetworkManager.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

final class NetworkManager {
    
    static let shared = NetworkManager() // made let shared static
    
    public init() {}
    
    func get<T: Decodable>(url: String, completion: @escaping ((Result<T, Error>) -> Void)) {
        
        guard let url = URL(string: url) else { return } //changed " " to url
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error {
                DispatchQueue.main.async { completion(.failure(error)) }
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decoded))
            } catch let error {
                completion(.failure(error))
            }
        }.resume()  //Added .resume()
    }
}


