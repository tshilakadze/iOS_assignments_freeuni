//
//  LoadCirclePicture.swift
//  profile-display
//
//  Created by Tsotne Shilakadze on 04.11.25.
//

import UIKit

class LoadCirclePicture: UIImageView{
    
    init(imageName: String, diameter: CGFloat){
        super.init(frame: .zero)
        
        self.image = UIImage(named: imageName)
        self.contentMode = .scaleAspectFill
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        self.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: diameter),
            self.heightAnchor.constraint(equalToConstant: diameter)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layoutIfNeeded()
        self.layer.cornerRadius = self.bounds.width / 2
    }
}
