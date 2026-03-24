//
//  ForecastView.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 05.02.26.
//

import UIKit

class ForecastView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var forecast_table = UITableView()
    private var forecast_data: [String: [ForecastItem]] = [:]
    private var sorted_dates: [String] = []
    
    private var header_handling: PageHeader?
    
    private let location = LocationService()
    private let weather = WeatherService()
    private var blurView: UIVisualEffectView?
    private var spinner: UIActivityIndicatorView?
    
    private let errorHandler = ErrorHandling()
    private var errorView: UIView?
    
    private func showLoading(){
        header_handling?.setShareEnabled(false)
        if blurView != nil { return }
        let blurEffect = UIBlurEffect(style: .systemMaterial)
        let blur = UIVisualEffectView(effect: blurEffect)
        blur.translatesAutoresizingMaskIntoConstraints = false
        let spin = UIActivityIndicatorView(style: .large)
        spin.translatesAutoresizingMaskIntoConstraints = false
        spin.startAnimating()
        
        blur.contentView.addSubview(spin)
        view.addSubview(blur)
        
        NSLayoutConstraint.activate([
            blur.topAnchor.constraint(equalTo: forecast_table.topAnchor),
            blur.bottomAnchor.constraint(equalTo: forecast_table.bottomAnchor),
            blur.leadingAnchor.constraint(equalTo: forecast_table.leadingAnchor),
            blur.trailingAnchor.constraint(equalTo: forecast_table.trailingAnchor),
            
            spin.centerXAnchor.constraint(equalTo: blur.centerXAnchor),
            spin.centerYAnchor.constraint(equalTo: blur.centerYAnchor)
        ])
        
        blurView = blur
        spinner = spin
    }
    
    private func hideLoading(){
        blurView?.removeFromSuperview()
        blurView = nil
        spinner = nil
    }
    
    private func processForecastData(_ response: ForecastResponse){
        forecast_data = [:]
        for item in response.list {
            let dateKey = String(item.dt_txt.prefix(10))
            
            if forecast_data[dateKey] == nil {
                forecast_data[dateKey] = []
            }
            forecast_data[dateKey]?.append(item)
        }
        sorted_dates = forecast_data.keys.sorted()
        forecast_table.reloadData()
    }
    
    private func showApiError() {
        if errorView != nil { return }
        forecast_table.isHidden = true
        let view = errorHandler.weatherLoadingAlert(target: self, retryAction: #selector(retryPressed))
        view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(view)
        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            view.widthAnchor.constraint(equalToConstant: 300),
            view.heightAnchor.constraint(equalToConstant: 200)
        ])
        errorView = view
    }
    
    private func hideApiError(){
        errorView?.removeFromSuperview()
        errorView = nil
        forecast_table.isHidden = false
    }
    
    @objc private func retryPressed() {
        hideApiError()
        refreshForecast()
    }
    
    private func refreshForecast(){
        showLoading()
        location.getUserLocation{ [weak self] lat, lon in
            guard let self = self else { return }
            
            if lat == 0 && lon == 0 {
                DispatchQueue.main.async {
                    self.hideLoading()
                    self.showApiError()
                    let alert = self.errorHandler.locationDeniedAlert()
                    self.present(alert, animated: true)
                }
                return
            }
            self.weather.fetchForecastData(lat: lat, lon: lon) { result in
                DispatchQueue.main.async {
                    self.hideLoading()
                    switch result {
                    case .success(let response):
                        self.hideApiError()
                        self.processForecastData(response)
                    case .failure:
                        self.showApiError()
                    }
                }
            }
        }
    }
    
    private func setUpDisplay(){
        view.backgroundColor = .systemBackground
        title = "Forecast"
        
        let header = PageHeader(title: "Forecast", showShareButton: false)
        header.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(header)
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60)
        ])
        self.header_handling = header
        header.onRefreshTapped = { [weak self] in
            self?.refreshForecast()
        }
        
        forecast_table.translatesAutoresizingMaskIntoConstraints = false
        forecast_table.delegate = self
        forecast_table.dataSource = self
        forecast_table.register(SingleCell.self, forCellReuseIdentifier: "ForecastCell")
        forecast_table.rowHeight = 80
        view.addSubview(forecast_table)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            header.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.heightAnchor.constraint(equalToConstant: 60),
            
            forecast_table.topAnchor.constraint(equalTo: header.bottomAnchor),
            forecast_table.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecast_table.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecast_table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpDisplay()
        refreshForecast()
    }
    
    
    //for UITableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return sorted_dates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dateKey = sorted_dates[section]
        return forecast_data[dateKey]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateString = sorted_dates[section]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: dateString) {
            formatter.dateFormat = "EEEE"
            return formatter.string(from: date).uppercased()
        }
        return dateString
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath) as? SingleCell else {
            return UITableViewCell()
        }
        
        let dateKey = sorted_dates[indexPath.section]
        if let items = forecast_data[dateKey] {
            let item = items[indexPath.row]
            cell.configureCell(with: item)
        }
        return cell
    }
}
