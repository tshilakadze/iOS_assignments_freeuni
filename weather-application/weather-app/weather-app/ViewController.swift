//
//  ViewController.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 05.02.26.
//

import UIKit

class ViewController: UIViewController {
    
    private var headerHandling: PageHeader?
    private let main_stack = UIStackView()
    private let separator = UIView()
    private var separatorWidth: NSLayoutConstraint!
    private var separatorHeight: NSLayoutConstraint!
    private let location = LocationService()
    private var blurView: UIVisualEffectView?
    private var spinner: UIActivityIndicatorView?
    private let weatherView = UIView()
    
    private let location_label = UILabel()
    private let weather_label = UILabel()
    private let cloud_label = UILabel()
    private let humidity_label = UILabel()
    private let pressure_label = UILabel()
    private let speed_label = UILabel()
    private let direction_label = UILabel()
    
    private let weather_image_view = UIImageView()
    private var imageWidthConstraint: NSLayoutConstraint!
    private var imageHeightConstraint: NSLayoutConstraint!
    
    private let errorHandler = ErrorHandling()
    private var errorView: UIView?
    private var uiBuilt = false
    
    private func showLoading() {
        headerHandling?.setShareEnabled(false)
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        let spin = UIActivityIndicatorView(style: .large)
        spin.translatesAutoresizingMaskIntoConstraints = false
        spin.startAnimating()
        
        blur.contentView.addSubview(spin)
        weatherView.addSubview(blur)
        
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: weatherView.topAnchor),
            blur.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor),
            blur.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor),
            
            spin.centerXAnchor.constraint(equalTo: blur.centerXAnchor),
            spin.centerYAnchor.constraint(equalTo: blur.centerYAnchor)
        ])
        
        blurView = blur
        spinner = spin
    }
    
    private func hideLoading() {
        blurView?.removeFromSuperview()
        blurView = nil
        spinner = nil
    }
    
    private func refreshWeather(){
        showLoading()
        location.getUserLocation { lat, lon in
            if lat == 0 && lon == 0 {
                DispatchQueue.main.async {
                    self.hideLoading()
                    self.showApiError()
                    let alert = self.errorHandler.locationDeniedAlert()
                    self.present(alert, animated: true)
                }
                return
            }
            let weatherService = WeatherService()
            weatherService.fetchWeatherData(lat: lat, lon: lon) { result in
                DispatchQueue.main.async {
                    self.hideLoading()
                    switch result {
                    case .success(let weather):
                        self.hideApiError()
                        if !self.uiBuilt {
                            self.setupUI(
                                header: self.headerHandling!,
                                city_name: weather.name,
                                country: weather.sys.country,
                                temperature: weather.main.temp,
                                description: weather.weather.first?.description ?? "",
                                cloud_percentage: weather.clouds.all,
                                humidity_level: weather.main.humidity,
                                pressure: weather.main.pressure,
                                wind_speed: weather.wind.speed,
                                wind_direction: weather.wind.deg
                            )
                            self.uiBuilt = true
                        }
                        self.updateUI(weather: weather)
                        self.headerHandling?.setShareEnabled(true)
                    case .failure:
                        DispatchQueue.main.async {
                            self.showApiError()
                        }
                    }
                }
            }
        }
    }
    
    private func createSmallStack(image_name: String, stack_label: UILabel) -> UIStackView{
        let result = UIStackView()
        result.axis = .vertical
        result.alignment = .center
        result.distribution = .fill
        result.spacing = 6
        let stack_image = UIImageView(image: UIImage(named: image_name))
        stack_image.contentMode = .scaleAspectFit
        stack_image.tintColor = .orange
        stack_image.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack_image.widthAnchor.constraint(equalToConstant: 20),
            stack_image.heightAnchor.constraint(equalToConstant: 20)
        ])
        stack_label.numberOfLines = 1
        stack_label.textAlignment = .center
        stack_label.adjustsFontSizeToFitWidth = true
        stack_label.minimumScaleFactor = 0.6
        result.addArrangedSubview(stack_image)
        result.addArrangedSubview(stack_label)
        return result
    }
    
    private func getDirection(wind: Int) -> String{
        let directions = ["N", "NNE", "NE", "ENE", "E", "ESE", "SE", "SSE",
                          "S", "SSW", "SW", "WSW", "W", "WNW", "NW", "NNW", "N"]
        let deg = (wind + 11) % 360
        let index = Int(Double(deg) / 22.5) % 16
        return directions[index % 16]
    }
    
    private func getWeatherImage(cloudPercentage: Int, description: String) -> UIImage? {
        let desc = description.lowercased()
        let hour = Calendar.current.component(.hour, from: Date())
        let is_night = hour < 6 || hour > 19
        if desc.contains("rain") {
            return UIImage(systemName: "cloud.rain.fill")
        } else if cloudPercentage > 10 {
            return UIImage(systemName: "cloud.fill")
        } else {
            if is_night {
                return UIImage(systemName: "moon.stars.fill")
            } else {
                return UIImage(named: "sun")
            }
        }
    }
    
    private func updateUI(weather: WeatherResponse) {
        let description = weather.weather.first?.description.capitalized ?? ""
        weather_image_view.image = getWeatherImage(
            cloudPercentage: weather.clouds.all,
            description: description
        )
        location_label.text = "\(weather.name), \(weather.sys.country)"
        weather_label.text = "\(Int(weather.main.temp))°C | \(description)"
        
        cloud_label.text = "\(weather.clouds.all)%"
        humidity_label.text = "\(weather.main.humidity)%"
        pressure_label.text = "\(weather.main.pressure) hPa"
        speed_label.text = "\(weather.wind.speed) km/h"
        direction_label.text = getDirection(wind: weather.wind.deg)
        view.layoutIfNeeded()
    }
    
    private func setupUI(header: UIView, city_name: String, country: String, temperature: Double, description: String, cloud_percentage: Int, humidity_level: Int, pressure: Int, wind_speed: Double, wind_direction: Int){
        main_stack.arrangedSubviews.forEach {
            $0.removeFromSuperview()
        }
        
        let stack_1 = UIStackView()
        stack_1.axis = .vertical
        stack_1.alignment = .center
        stack_1.distribution = .equalSpacing
        stack_1.spacing = 15
        
        weather_image_view.image = getWeatherImage(cloudPercentage: cloud_percentage, description: description)
        
        weather_image_view.contentMode = .scaleAspectFit
        weather_image_view.translatesAutoresizingMaskIntoConstraints = false
        weather_image_view.translatesAutoresizingMaskIntoConstraints = false
        imageWidthConstraint = weather_image_view.widthAnchor.constraint(equalToConstant: 80)
        imageHeightConstraint = weather_image_view.heightAnchor.constraint(equalToConstant: 80)
        imageWidthConstraint.isActive = true
        imageHeightConstraint.isActive = true
        
        location_label.text = city_name + ", " + country
        location_label.numberOfLines = 1
        location_label.adjustsFontSizeToFitWidth = true
        location_label.minimumScaleFactor = 0.6
        
        weather_label.text = String(temperature) + "°C | " + description
        weather_label.textColor = .blue
        weather_label.numberOfLines = 1
        weather_label.adjustsFontSizeToFitWidth = true
        weather_label.minimumScaleFactor = 0.6
        
        stack_1.addArrangedSubview(weather_image_view)
        stack_1.addArrangedSubview(location_label)
        stack_1.addArrangedSubview(weather_label)
        stack_1.translatesAutoresizingMaskIntoConstraints = false
        
        cloud_label.text = String(cloud_percentage) + " %"
        humidity_label.text = String(humidity_level) + " mm"
        pressure_label.text = String(pressure) + " hPa"
        let cloud_stack = createSmallStack(image_name: "raining", stack_label: cloud_label)
        let humidity_stack = createSmallStack(image_name: "drop", stack_label: humidity_label)
        let pressure_stack = createSmallStack(image_name: "celsius", stack_label: pressure_label)
        
        let stack_h1 = UIStackView()
        stack_h1.axis = .horizontal
        stack_h1.alignment = .center
        stack_h1.distribution = .equalCentering
        stack_h1.spacing = 20
        stack_h1.addArrangedSubview(cloud_stack)
        stack_h1.addArrangedSubview(humidity_stack)
        stack_h1.addArrangedSubview(pressure_stack)
        stack_h1.translatesAutoresizingMaskIntoConstraints = false
        
        speed_label.text = String(wind_speed) + " km/h"
        direction_label.text = getDirection(wind: wind_direction)
        let wind_speed_stack = createSmallStack(image_name: "wind", stack_label: speed_label)
        let wind_direction_stack = createSmallStack(image_name: "compass", stack_label: direction_label)
        
        let stack_h2 = UIStackView()
        stack_h2.axis = .horizontal
        stack_h2.alignment = .center
        stack_h2.distribution = .equalCentering
        stack_h2.spacing = 20
        stack_h2.addArrangedSubview(wind_speed_stack)
        stack_h2.addArrangedSubview(wind_direction_stack)
        stack_h2.translatesAutoresizingMaskIntoConstraints = false
        
        let lower_stack = UIStackView()
        lower_stack.axis = .vertical
        lower_stack.spacing = 20
        lower_stack.alignment = .center
        lower_stack.distribution = .equalCentering
        lower_stack.translatesAutoresizingMaskIntoConstraints = false
        
        lower_stack.addArrangedSubview(stack_h1)
        lower_stack.addArrangedSubview(stack_h2)
        
        separator.backgroundColor = .lightGray
        separator.translatesAutoresizingMaskIntoConstraints = false
        main_stack.axis = .vertical
        main_stack.spacing = 40
        main_stack.alignment = .center
        main_stack.distribution = .fill
        main_stack.translatesAutoresizingMaskIntoConstraints = false
        main_stack.addArrangedSubview(stack_1)
        main_stack.addArrangedSubview(separator)
        main_stack.addArrangedSubview(lower_stack)
        weatherView.addSubview(main_stack)
        
        separatorHeight = separator.heightAnchor.constraint(equalToConstant: 1)
        separatorWidth = separator.widthAnchor.constraint(equalTo: main_stack.widthAnchor, multiplier: 0.8)
        separatorHeight.isActive = true
        separatorWidth.isActive = true
        
        NSLayoutConstraint.activate([
            main_stack.topAnchor.constraint(greaterThanOrEqualTo: header.bottomAnchor, constant: 20),
            main_stack.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            main_stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            main_stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            main_stack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            main_stack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    private func setUpDisplay(){
        view.backgroundColor = .systemBackground
        title = "Today"
        let header = PageHeader(title: "Today", showShareButton: true)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.onShareTapped = { [weak self] in
            guard let self = self else { return }
            
            let currentLocation = self.location_label.text ?? "Unknown City"
            let currentWeather = self.weather_label.text ?? "Today"
            self.shareWeather(location: currentLocation, weather: currentWeather)
        }
        view.addSubview(header)
        self.headerHandling = header
        header.onRefreshTapped = { [weak self] in
            self?.refreshWeather()
        }
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        weatherView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weatherView)
        
        header.onRefreshTapped = { [weak self] in
            self?.refreshWeather()
        }
        
        NSLayoutConstraint.activate([
            weatherView.topAnchor.constraint(equalTo: header.bottomAnchor),
            weatherView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            weatherView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            weatherView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDisplay()
        refreshWeather()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            guard self.separatorHeight != nil,
                  self.separatorWidth != nil,
                  self.main_stack.superview != nil else { return }
            if size.width > size.height {
                self.main_stack.axis = .horizontal
                self.main_stack.alignment = .center
                self.main_stack.distribution = .fill
                self.main_stack.spacing = 20
                
                self.imageWidthConstraint.constant = 40
                self.imageHeightConstraint.constant = 40
                
                self.separatorHeight.isActive = false
                self.separatorWidth.isActive = false
                self.separatorWidth = self.separator.widthAnchor.constraint(equalToConstant: 1)
                self.separatorHeight = self.separator.heightAnchor.constraint(equalTo: self.main_stack.heightAnchor, multiplier: 0.6)
                self.separatorWidth.isActive = true
                self.separatorHeight.isActive = true
                
            } else {
                self.main_stack.axis = .vertical
                self.main_stack.alignment = .center
                self.main_stack.distribution = .fill
                self.main_stack.spacing = 40
                
                self.imageWidthConstraint.constant = 80
                self.imageHeightConstraint.constant = 80
                
                self.separatorWidth.isActive = false
                self.separatorHeight.isActive = false
                self.separatorHeight = self.separator.heightAnchor.constraint(equalToConstant: 1)
                self.separatorWidth = self.separator.widthAnchor.constraint(equalTo: self.main_stack.widthAnchor, multiplier: 0.8)
                self.separatorHeight.isActive = true
                self.separatorWidth.isActive = true
            }
            self.view.layoutIfNeeded()
        })
    }
    
    private func showApiError() {
        headerHandling?.setShareEnabled(false)
        main_stack.isHidden = true
        
        let view = errorHandler.weatherLoadingAlert(target: self, retryAction: #selector(retryPressed))
        if errorView != nil { return }
        weatherView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: weatherView.topAnchor),
            view.bottomAnchor.constraint(equalTo: weatherView.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: weatherView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: weatherView.trailingAnchor)
        ])
        errorView = view
    }
    
    private func hideApiError() {
        errorView?.removeFromSuperview()
        errorView = nil
        main_stack.isHidden = false
    }
    
    @objc private func retryPressed() {
        hideApiError()
        refreshWeather()
    }
    
    private func shareWeather(location: String, weather: String) {
        let loc = location
        let weath = weather
        
        let textToShare = "Current weather in \(loc): \(weath)."
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        self.present(activityVC, animated: true)
    }
}
