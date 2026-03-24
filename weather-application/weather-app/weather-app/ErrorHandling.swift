//
//  ErrorHandling.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 07.02.26.
//

import UIKit

class ErrorHandling {
    
    func locationDeniedAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: "Location Permission Needed",
            message: "Weather cannot be loaded without location access. Please enable it in Settings.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        return alert
    }
    
    func weatherLoadingAlert(target: Any, retryAction: Selector) -> UIView {
        let error_container = UIView()
        error_container.backgroundColor = .systemBackground
        error_container.translatesAutoresizingMaskIntoConstraints = false
        
        let error_image = UIImageView(image: UIImage(named: "data_load_error"))
        error_image.contentMode = .scaleAspectFit
        error_image.translatesAutoresizingMaskIntoConstraints = false
        
        let error_label = UILabel()
        error_label.text = "Could not load weather data. Try again."
        error_label.textAlignment = .center
        error_label.numberOfLines = 0
        error_label.textColor = .label
        error_label.translatesAutoresizingMaskIntoConstraints = false
        
        let try_again_button = UIButton(type: .system)
        try_again_button.setTitle("Reload", for: .normal)
        try_again_button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        try_again_button.translatesAutoresizingMaskIntoConstraints = false
        try_again_button.addTarget(target, action: retryAction, for: .touchUpInside)
        
        error_container.addSubview(error_image)
        error_container.addSubview(error_label)
        error_container.addSubview(try_again_button)
        
        NSLayoutConstraint.activate([
            error_image.centerXAnchor.constraint(equalTo: error_container.centerXAnchor),
            error_image.centerYAnchor.constraint(equalTo: error_container.centerYAnchor, constant: -60),
            error_image.heightAnchor.constraint(equalToConstant: 80),
            error_image.widthAnchor.constraint(equalToConstant: 80),
            
            error_label.topAnchor.constraint(equalTo: error_image.bottomAnchor, constant: 20),
            error_label.leadingAnchor.constraint(equalTo: error_container.leadingAnchor, constant: 40),
            error_label.trailingAnchor.constraint(equalTo: error_container.trailingAnchor, constant: -40),
            
            try_again_button.topAnchor.constraint(equalTo: error_label.bottomAnchor, constant: 25),
            try_again_button.centerXAnchor.constraint(equalTo: error_container.centerXAnchor)
        ])
        return error_container
    }
    
}
