//
//  NumberButton.swift
//  phone-app
//
//  Created by Tsotne Shilakadze on 17.11.25.
//

import UIKit


class NumberButton: UIButton{
    var str1: String
    var str2: String
    var sizes: Double
    init(str1: String, str2: String, sizes: Double){
        self.str1 = str1
        self.str2 = str2
        self.sizes = sizes
        super.init(frame: .zero)
        buttonSetup()
    }
    
    required init?(coder: NSCoder) {
        self.str1 = ""
        self.str2 = ""
        self.sizes = 0
        super.init(coder: coder)
    }
    
    func buttonSetup(){
        var big_font = self.sizes * 0.4
        if(str1 == "*") {
            big_font = self.sizes * 0.8
        }
        let small_font = big_font * 0.35
        let bigLabel = UILabel()
        let smallLabel = UILabel()
        
        bigLabel.text = self.str1
        bigLabel.font = UIFont.systemFont(ofSize: big_font)
        smallLabel.text = self.str2
        smallLabel.font = UIFont.systemFont(ofSize: small_font)
        
        let bothLabels = UIStackView()
        bothLabels.axis = .vertical
        bothLabels.alignment = .center
        bothLabels.spacing = self.sizes * 0.005
        bothLabels.addArrangedSubview(bigLabel)
        if(!str2.isEmpty){
            bothLabels.addArrangedSubview(smallLabel)
        }
        addSubview(bothLabels)
        bothLabels.translatesAutoresizingMaskIntoConstraints = false
        bigLabel.isUserInteractionEnabled = false
        smallLabel.isUserInteractionEnabled = false
        bothLabels.isUserInteractionEnabled = false
        NSLayoutConstraint.activate([
            bothLabels.centerXAnchor.constraint(equalTo: centerXAnchor),
            bothLabels.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        layer.cornerRadius = self.sizes / 2.0
        clipsToBounds = true
        backgroundColor = UIColor.systemGray6
        setTitleColor(.black, for: .normal)
        
        setTitle("", for: .normal)
        titleLabel?.isHidden = true
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: sizes, height: sizes)
    }
    
    override var isHighlighted: Bool {
        didSet {
            self.alpha = isHighlighted ? 0.5 : 1.0
        }
    }
}
