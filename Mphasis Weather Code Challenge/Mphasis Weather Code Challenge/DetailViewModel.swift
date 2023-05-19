//
//  DetailViewModel.swift
//  Mphasis Weather Code Challenge
//
//  Created by Brett Sarafian on 5/18/23.
//

import Foundation
import UIKit

class DetailViewModel  {
    private let appid: String = "82102f4cdc7f5e5c79365ba07d98b1df"
    private let cityName: String
    var cityData: Data?
    var city: City?
    var iconString: String?

    init(cityName: String) {
        self.cityName = cityName
        getCityData { _ in }
    }

    func getCityData(_ completionHandler: @escaping (Result<Data, Error>) -> Void) {
        if let data = cityData {
            completionHandler(.success(data))
            return
        }
        
        guard var url = URL(string: "https://api.openweathermap.org/data/2.5/weather") else { return }
        url.append(queryItems: [URLQueryItem(name: "q", value: cityName),
                               URLQueryItem(name: "appid", value: appid),
                               URLQueryItem(name: "units", value: "imperial")])
        let request = URLRequest(url: url)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completionHandler(.failure(error))
                }
                if let data = data {
                    self.cityData = data
                    completionHandler(.success(data))
                }
            }
        }
        task.resume()
    }

    func parseCityData(_ data: Data) -> Bool {
        guard city == nil else { return false }
        do {
            let decoder = JSONDecoder()
            let city = try decoder.decode(City.self, from: data)
            self.city = city
            self.iconString = city.weather.first?.icon
            return true
        } catch {
            print("Error occured: \(error)")
            return false
        }
    }
}
