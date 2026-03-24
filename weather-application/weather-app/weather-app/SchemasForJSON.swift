//
//  SchemasForJSON.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 06.02.26.
//

import UIKit
import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let sys: SysInfo
    let main: MainInfo
    let weather: [WeatherInfo]
    let wind: WindInfo
    let clouds: CloudsInfo
}

struct SysInfo: Decodable {
    let country: String
}

struct WeatherInfo: Decodable {
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Decodable {
    let temp: Double
    let feels_like: Double
    let humidity: Int
    let pressure: Int
}

struct WindInfo: Decodable {
    let speed: Double
    let deg: Int
}

struct CloudsInfo: Decodable {
    let all: Int
}


struct ForecastResponse: Decodable {
    let list: [ForecastItem]
    let city: CityInfo
}

struct ForecastItem: Decodable {
    let dt: Int
    let main: MainInfo
    let weather: [WeatherInfo]
    let dt_txt: String
}

struct CityInfo: Decodable {
    let name: String
    let country: String
}
