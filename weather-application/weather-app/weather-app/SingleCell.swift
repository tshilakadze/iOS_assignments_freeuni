//
//  SingleCell.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 08.02.26.
//

import UIKit

class SingleCell: UITableViewCell {
    
    private let weather_image = UIImageView()
    private let weather_time = UILabel()
    private let weather_description = UILabel()
    private let temperature_label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell(){
        weather_image.contentMode = .scaleAspectFit
        weather_image.translatesAutoresizingMaskIntoConstraints = false
        weather_image.tintColor = .systemGray
        
        weather_time.font = .systemFont(ofSize: 16, weight: .regular)
        weather_time.textColor = .label
        weather_description.font = .systemFont(ofSize: 16, weight: .regular)
        weather_description.textColor = .label
        
        temperature_label.font = .systemFont(ofSize: 24, weight: .bold)
        temperature_label.textColor = .systemBlue
        temperature_label.textAlignment = .right
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.spacing = 5
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(weather_time)
        stack.addArrangedSubview(weather_description)
        
        contentView.addSubview(weather_image)
        contentView.addSubview(stack)
        contentView.addSubview(temperature_label)
        
        temperature_label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            weather_image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            weather_image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            weather_image.widthAnchor.constraint(equalToConstant: 40),
            weather_image.heightAnchor.constraint(equalToConstant: 40),
            
            stack.leadingAnchor.constraint(equalTo: weather_image.trailingAnchor, constant: 12),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            temperature_label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            temperature_label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            stack.trailingAnchor.constraint(lessThanOrEqualTo: temperature_label.leadingAnchor, constant: -10)
        ])
    }
    
    func configureCell(with item: ForecastItem){
        let description = item.weather.first?.description ?? ""
        let low_desc = description.lowercased()
        if low_desc.contains("rain") {
            weather_image.image = UIImage(systemName: "cloud.rain.fill")
        } else if low_desc.contains("snow") {
            weather_image.image = UIImage(systemName: "snowflake")
        } else if low_desc.contains("cloud") {
            weather_image.image = UIImage(systemName: "cloud.fill")
        } else {
            weather_image.image = UIImage(systemName: "sun.max.fill")
        }
        
        let timeParts = item.dt_txt.components(separatedBy: " ")
        if let time = timeParts.last {
            weather_time.text = String(time.prefix(5))
        } else {
            weather_time.text = "--:--"
        }
        weather_description.text = description.capitalized
        temperature_label.text = String(format: "%.0f°C", item.main.temp)
    }
}
