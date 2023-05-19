//
//  City.swift
//  Mphasis Weather Code Challenge
//
//  Created by Brett Sarafian on 5/18/23.
//

import Foundation

struct City: Codable {
    var base: String?
    var weather: [Weather]
    var name: String?
    var main: Temp?
    var visibility: Int?
}

struct error: Codable {
    var cod: String?
    var message: String?
}

struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Temp: Codable {
    var temp: Double
}
