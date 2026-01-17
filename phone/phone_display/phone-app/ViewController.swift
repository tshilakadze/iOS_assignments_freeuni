//
//  ViewController.swift
//  phone-app
//
//  Created by Tsotne Shilakadze on 17.11.25.
//

import UIKit

class ViewController: UIViewController, OutgoingCallViewDelegate {
    
    var number: String = ""
    var number_label = UILabel()
    let digits = UIStackView()
    
    @objc func numberPressed(_ sender: NumberButton) {
        let curr_digit = sender.str1
        number += curr_digit
        number_label.text = number
    }
    
    @objc func deletePressed(_ sender: NumberButton) {
        if(!number.isEmpty){
            number.removeLast()
            number_label.text = number
        }
    }
    
    func callEnd() {
        number = ""
        number_label.text = ""
    }
    
    @objc func callPressed(_ sender: NumberButton) {
        if(number != ""){
            let outgoing_call = OutgoingCallView()
            outgoing_call.phone_number = number
            outgoing_call.modalPresentationStyle = .fullScreen
            outgoing_call.delegate = self
            outgoing_call.modalTransitionStyle = .crossDissolve
            present(outgoing_call, animated: true, completion: nil)
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenWidth = UIScreen.main.bounds.width
        let buttonSize = screenWidth * 0.2
        let numbersSpacing = buttonSize * 0.25
        
        let button_strings: [(String, String)] = [("1", ""), ("2", "ABC"), ("3", "DEF"), ("4", "GHI"), ("5", "JKL"), ("6", "MNO"), ("7", "PQRS"), ("8", "TUV"), ("9", "WXYZ"), ("*", ""), ("0", "+"), ("#", "")]
        
        
        let first_row = UIStackView()
        let second_row = UIStackView()
        let third_row = UIStackView()
        let fourth_row = UIStackView()
        let fifth_row = UIStackView()
        for curr_index in 1...12{
            let curr_pair = button_strings[curr_index - 1]
            let curr_button = NumberButton(str1: curr_pair.0, str2: curr_pair.1, sizes: buttonSize)
            curr_button.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            if(curr_index <= 3){
                first_row.addArrangedSubview(curr_button)
            } else if(curr_index <= 6){
                second_row.addArrangedSubview(curr_button)
            } else if(curr_index <= 9){
                third_row.addArrangedSubview(curr_button)
            } else{
                fourth_row.addArrangedSubview(curr_button)
            }
        }
        
        let call_button = UIButton(type: .system)
        call_button.setImage(UIImage(systemName: "phone.fill"), for: .normal)
        call_button.backgroundColor = .green
        call_button.tintColor = .white
        call_button.layer.cornerRadius = buttonSize / 2.0
        call_button.translatesAutoresizingMaskIntoConstraints = false
        call_button.addTarget(self, action: #selector(callPressed(_:)), for: .touchUpInside)
        
        let delete_button = UIButton(type: .system)
        delete_button.setImage(UIImage(systemName: "delete.left.fill"), for: .normal)
        delete_button.backgroundColor = .white
        delete_button.tintColor = .black
        delete_button.translatesAutoresizingMaskIntoConstraints = false
        delete_button.addTarget(self, action: #selector(deletePressed(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            call_button.widthAnchor.constraint(equalToConstant: buttonSize),
            call_button.heightAnchor.constraint(equalToConstant: buttonSize),
            delete_button.widthAnchor.constraint(equalToConstant: buttonSize),
            delete_button.heightAnchor.constraint(equalToConstant: buttonSize)
        ])
        
        fifth_row.addArrangedSubview(UIView())
        fifth_row.addArrangedSubview(call_button)
        fifth_row.addArrangedSubview(delete_button)
        
        
        first_row.axis = .horizontal
        first_row.alignment = .center
        first_row.spacing = numbersSpacing
        second_row.axis = .horizontal
        second_row.alignment = .center
        second_row.spacing = first_row.spacing
        third_row.axis = .horizontal
        third_row.alignment = .center
        third_row.spacing = first_row.spacing
        fourth_row.axis = .horizontal
        fourth_row.alignment = .center
        fourth_row.spacing = first_row.spacing
        fifth_row.axis = .horizontal
        fifth_row.alignment = .center
        fifth_row.distribution = .fillEqually
        fifth_row.spacing = first_row.spacing
        
        digits.addArrangedSubview(first_row)
        digits.addArrangedSubview(second_row)
        digits.addArrangedSubview(third_row)
        digits.addArrangedSubview(fourth_row)
        digits.addArrangedSubview(fifth_row)
        digits.axis = .vertical
        digits.alignment = .center
        digits.spacing = first_row.spacing
        view.addSubview(digits)
        digits.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            digits.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            digits.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        number_label.font = UIFont.systemFont(ofSize: buttonSize * 0.4, weight: .bold)
        number_label.textAlignment = .center
        number_label.numberOfLines = 0
        view.addSubview(number_label)
        number_label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            number_label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            number_label.bottomAnchor.constraint(equalTo: digits.topAnchor, constant: -buttonSize * 0.5)
        ])
    }
}
