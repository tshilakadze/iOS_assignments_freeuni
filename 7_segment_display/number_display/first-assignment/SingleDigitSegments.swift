//
//  SingleDigitSegments.swift
//  first-assignment
//
//  Created by Tsotne Shilakadze on 03.10.25.
//

import UIKit

class SingleDigitSegments: UIView {
    
    private var segments: [UIView] = []
    
    private let segmentsYesOrNo: [[Int]] = [
        [1, 1, 1, 1, 1, 1, 0],
        [0, 0, 1, 1, 0, 0, 0],
        [0, 1, 1, 0, 1, 1, 1],
        [0, 1, 1, 1, 1, 0, 1],
        [1, 0, 1, 1, 0, 0, 1],
        [1, 1, 0, 1, 1, 0, 1],
        [1, 1, 0, 1, 1, 1, 1],
        [0, 1, 1, 1, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 1]
    ]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSegments()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        setUpSegments()
    }
    
    private func setUpSegments(){
        let length: CGFloat = bounds.height
        let thickness: CGFloat = bounds.width
        let startingPoint = CGPoint(x: bounds.width, y: bounds.width)
        
        let mySegments: [CGRect] = [
            CGRect(x: startingPoint.x*1.3, y: startingPoint.y, width: thickness, height: length),
            CGRect(x: startingPoint.x*2.5, y: startingPoint.y*0.8, width: length, height: thickness),
            CGRect(x: startingPoint.x*2.6 + length, y: startingPoint.y, width: thickness, height: length),
            CGRect(x: startingPoint.x*2.6 + length, y: (startingPoint.y + length)*1.1, width: thickness, height: length),
            CGRect(x: startingPoint.x*2.5, y: startingPoint.y + length * 2.1, width: length, height: thickness),
            CGRect(x: startingPoint.x*1.3, y: (startingPoint.y + length)*1.1, width: thickness, height: length),
            CGRect(x: startingPoint.x*2.5, y: (startingPoint.y + length), width: length, height: thickness)
        ]
        
        for frame in mySegments {
            let currSegment = UIView(frame: frame)
            currSegment.backgroundColor = .clear
            addSubview(currSegment)
            segments.append(currSegment)
        }
    }
    
    func outputNumber(index: Int){
        let segPattern = segmentsYesOrNo[index]
        for i in 0..<7{
            if(segPattern[i] == 1){
                segments[i].backgroundColor = .red
            } else{
                segments[i].backgroundColor = .clear
            }
        }
    }
}
