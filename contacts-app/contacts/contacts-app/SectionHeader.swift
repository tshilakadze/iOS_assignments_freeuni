//
//  SectionHeader.swift
//  contacts-app
//
//  Created by Tsotne Shilakadze on 28.12.25.
//

import UIKit

class SectionHeader: UICollectionReusableView{
    
    static let identifier = "SectionHeader"
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let headerLabel = UILabel()
    let expand_collapse_button = UIButton(type: .system)
    
    override init(frame: CGRect){
        super.init(frame: frame)
        addSubview(headerLabel)
        addSubview(expand_collapse_button)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        expand_collapse_button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: screenWidth * 0.04),
            headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            expand_collapse_button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -screenWidth * 0.04),
            expand_collapse_button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
