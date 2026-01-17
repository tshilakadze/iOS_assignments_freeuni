//
//  ViewController.swift
//  first-assignment
//
//  Created by Tsotne Shilakadze on 29.09.25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let number = 999
        let screenWidth = Double(UIScreen.main.bounds.width)
        let singleNumPlace = screenWidth / 3 - 10
        
        let width = singleNumPlace * 0.08
        let length = singleNumPlace * 0.7
        let num3 = number % 10
        let num2 = (number / 10) % 10
        let num1 = ((number / 10) / 10) % 10
        
        let firstDigit = SingleDigitSegments(frame: CGRect(x: width, y: 100, width: width, height: length))
        firstDigit.outputNumber(index: num1)
        view.addSubview(firstDigit)
        
        let secondDigit = SingleDigitSegments(frame: CGRect(x: width + singleNumPlace + width, y: 100, width: width, height: length))
        secondDigit.outputNumber(index: num2)
        view.addSubview(secondDigit)
        
        let thirdDigit = SingleDigitSegments(frame: CGRect(x: width + singleNumPlace * 2 + width, y: 100, width: width, height: length))
        thirdDigit.outputNumber(index: num3)
        view.addSubview(thirdDigit)
    }
}

