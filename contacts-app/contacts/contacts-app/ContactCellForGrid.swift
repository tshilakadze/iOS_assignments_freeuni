//
//  ContactCellForGrid.swift
//  contacts-app
//
//  Created by Tsotne Shilakadze on 28.12.25.
//

import UIKit

class ContactCellForGrid: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 13)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let phoneLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 10)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        clipsToBounds = true
        
        nameLabel.textAlignment = .center
        phoneLabel.textAlignment = .center
        
        contentView.addSubview(nameLabel)
        contentView.addSubview(phoneLabel)
            
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            phoneLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -8),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(name: String, phone: String) {
        nameLabel.text = name
        phoneLabel.text = phone
    }
}
