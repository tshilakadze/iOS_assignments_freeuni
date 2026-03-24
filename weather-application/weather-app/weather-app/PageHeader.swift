//
//  PageHeader.swift
//  weather-app
//
//  Created by Tsotne Shilakadze on 05.02.26.
//

import UIKit

class PageHeader: UIView {
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let titleLabel = UILabel()
    
    private let refreshButton: UIButton = {
        let refresh_button = UIButton(type: .system)
        let image = UIImage(systemName: "arrow.clockwise")
        refresh_button.setImage(image, for: .normal)
        refresh_button.tintColor = .blue
        return refresh_button
    }()
    
    private let shareButton: UIButton = {
        let share_button = UIButton(type: .system)
        let image = UIImage(systemName: "square.and.arrow.up")
        share_button.setImage(image, for: .normal)
        share_button.tintColor = .blue
        return share_button
    }()
    
    var onRefreshTapped: (() -> Void)?
    var onShareTapped: (() -> Void)?
    
    init(title: String, showShareButton: Bool){
        super.init(frame: .zero)
        titleLabel.text = title
        titleLabel.textColor = .black
        if !showShareButton {
            shareButton.alpha = 0
            shareButton.isUserInteractionEnabled = false
        }
        setupHeader()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader(){
        addSubview(headerView)
        headerView.addSubview(headerStack)
        headerStack.addArrangedSubview(refreshButton)
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(shareButton)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        refreshButton.addTarget(self, action: #selector(refreshPressed), for: .touchUpInside)
        shareButton.addTarget(self, action: #selector(sharePressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),
            
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
        ])
    }
    
    func setShareEnabled(_ enabled: Bool) {
        shareButton.isEnabled = enabled
        shareButton.alpha = enabled ? 1.0 : 0.3
    }
    
    @objc private func refreshPressed() {
        onRefreshTapped?()
    }
    
    @objc private func sharePressed() {
        onShareTapped?()
    }
}
