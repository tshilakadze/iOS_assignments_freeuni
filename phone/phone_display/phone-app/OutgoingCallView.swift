//
//  OutgoingCallView.swift
//  phone-app
//
//  Created by Tsotne Shilakadze on 23.11.25.
//

import UIKit

protocol OutgoingCallViewDelegate: AnyObject {
    func callEnd()
}

class OutgoingCallView: UIViewController{
    
    weak var delegate: OutgoingCallViewDelegate?
    var phone_number: String?
    
    @objc func disconnectPressed(_ sender: NumberButton) {
        delegate?.callEnd()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = UIScreen.main.bounds.height
        let screenWidth = UIScreen.main.bounds.width
        let buttonSize = screenWidth * 0.2
        
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor(red: 0.18, green: 0.18, blue: 0.20, alpha: 1).cgColor,
            UIColor(red: 0.26, green: 0.26, blue: 0.28, alpha: 1).cgColor
        ]
        view.layer.insertSublayer(gradient, at: 0)
        gradient.frame = view.bounds
        
        let font_size = buttonSize * 0.4
        let labelsStack = UIStackView()
        let calling_label = UILabel()
        calling_label.text = "Calling..."
        calling_label.textColor = .lightGray
        calling_label.font = UIFont.systemFont(ofSize: font_size * 0.5)
        let number_label = UILabel()
        number_label.text = phone_number
        number_label.textColor = .white
        number_label.font = UIFont.systemFont(ofSize: font_size)
        labelsStack.addArrangedSubview(calling_label)
        labelsStack.addArrangedSubview(number_label)
        labelsStack.axis = .vertical
        labelsStack.spacing = font_size * 0.2
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        labelsStack.alignment = .center
        view.addSubview(labelsStack)
        NSLayoutConstraint.activate([
            labelsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelsStack.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * 0.2)
        ])
        
        let buttons = UIStackView()
        let discpnnect_call = UIButton(type: .system)
        discpnnect_call.setImage(UIImage(systemName: "phone.down.fill"), for: .normal)
        discpnnect_call.backgroundColor = .red
        discpnnect_call.tintColor = .white
        discpnnect_call.layer.cornerRadius = buttonSize / 2.0
        discpnnect_call.translatesAutoresizingMaskIntoConstraints = false
        discpnnect_call.addTarget(self, action: #selector(disconnectPressed(_:)), for: .touchUpInside)
        
        let left_button = UIButton(type: .system)
        left_button.setImage(UIImage(systemName: "person.badge.plus"), for: .normal)
        left_button.layer.cornerRadius = buttonSize / 2.0
        left_button.backgroundColor = .systemGray
        left_button.tintColor = .white
        left_button.translatesAutoresizingMaskIntoConstraints = false
        
        let right_button = UIButton(type: .system)
        right_button.setImage(UIImage(systemName: "circle.grid.3x3.fill"), for: .normal)
        right_button.layer.cornerRadius = buttonSize / 2.0
        right_button.backgroundColor = .systemGray
        right_button.tintColor = .white
        right_button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            discpnnect_call.widthAnchor.constraint(equalToConstant: buttonSize),
            discpnnect_call.heightAnchor.constraint(equalToConstant: buttonSize),
            right_button.widthAnchor.constraint(equalToConstant: buttonSize),
            right_button.heightAnchor.constraint(equalToConstant: buttonSize),
            left_button.widthAnchor.constraint(equalToConstant: buttonSize),
            left_button.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        let decline_label = UILabel()
        decline_label.text = "Decline"
        decline_label.font = UIFont.systemFont(ofSize: font_size * 0.35)
        decline_label.textColor = .white
        decline_label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(decline_label)
        
        buttons.axis = .horizontal
        buttons.spacing = buttonSize * 0.3
        buttons.alignment = .center
        buttons.addArrangedSubview(left_button)
        buttons.addArrangedSubview(discpnnect_call)
        buttons.addArrangedSubview(right_button)
        buttons.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttons)
        NSLayoutConstraint.activate([
            buttons.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttons.topAnchor.constraint(equalTo: view.topAnchor, constant: screenHeight * 0.7),
            decline_label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            decline_label.topAnchor.constraint(equalTo: buttons.bottomAnchor, constant: buttonSize * 0.2)
        ])
    }
}
