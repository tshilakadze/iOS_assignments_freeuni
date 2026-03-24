//
//  WeatherService.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 05.02.26.
//

import UIKit

class WeatherService{
    
    private let apiKey = ""     //!!!!!!!!!!!!!!!!!!!!!!!!!!!
    
    func fetchWeatherData(lat: Double, lon: Double, completion: @escaping (Result<WeatherResponse, Error>) -> Void){
        let urlStr = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            do {
                let decoded = try JSONDecoder().decode(WeatherResponse.self, from: data)
                
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
    
    func fetchForecastData(lat: Double, lon: Double, completion: @escaping (Result<ForecastResponse, Error>) -> Void) {
        let urlStr = "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=\(apiKey)&units=metric"
        
        guard let url = URL(string: urlStr) else {
            completion(.failure(NSError(domain: "BadURL", code: 0)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NoData", code: 0)))
                return
            }
            
            do {
                let decoded = try JSONDecoder().decode(ForecastResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
