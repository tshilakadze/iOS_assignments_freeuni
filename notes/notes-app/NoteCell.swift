//
//  NoteCell.swift
//  notes-app
//
//  Created by Tsotne Shilakadze on 18.01.26.
//

import UIKit

class NoteCell: UICollectionViewCell {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    static let identifier = "NoteCell"
    
    static let maxLines = 15
    
    private static let colours: [UIColor] = [
        UIColor(red: 0.85, green: 0.95, blue: 1.0, alpha: 1.0),
        UIColor(red: 1.0, green: 1.0, blue: 0.85, alpha: 1.0),
        UIColor(red: 1.0, green: 0.85, blue: 0.85, alpha: 1.0),
        UIColor(red: 0.85, green: 1.0, blue: 0.85, alpha: 1.0)
    ]
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 13)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let textLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 10)
        l.textColor = .secondaryLabel
        l.numberOfLines = NoteCell.maxLines
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //contentView.backgroundColor = Self.colours.randomElement()
        contentView.layer.cornerRadius = screenWidth * 0.03
        contentView.layer.masksToBounds = true
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(textLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: screenHeight * 0.01),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: screenWidth * 0.03),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -screenWidth * 0.03),
            
            textLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: screenHeight * 0.005),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: screenWidth * 0.03),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -screenWidth * 0.03),
            textLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -screenHeight * 0.01)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with note: Note) {
        titleLabel.text = note.title?.isEmpty == false ? note.title : "No Title"
        textLabel.text = note.note_text?.isEmpty == false ? note.note_text : "No text"
        let idString = note.objectID.uriRepresentation().absoluteString
        let index = abs(idString.hashValue) % Self.colours.count
        contentView.backgroundColor = Self.colours[index]
    }
    
    static func height(for note: Note, width: CGFloat, screenWidth: CGFloat, screenHeight: CGFloat) -> CGFloat {
        let horizontalPadding = screenWidth * 0.06
        let verticalPadding = screenHeight * 0.01 + screenHeight * 0.005 + screenHeight * 0.01
        let titleText = note.title?.isEmpty == false ? note.title! : "No Title"
        let titleHeight = titleText.heightWithConstrainedWidth(width - horizontalPadding, font: .boldSystemFont(ofSize: 13))
        
        let textText = note.note_text?.isEmpty == false ? note.note_text! : "No text"
        let textFont = UIFont.systemFont(ofSize: 10)
        
        let maxTextHeight = textFont.lineHeight * CGFloat(maxLines)
        let textHeight = min(textText.heightWithConstrainedWidth(width - horizontalPadding, font: textFont), maxTextHeight)
        return titleHeight + textHeight + verticalPadding
    }
    
}


extension String {
    func heightWithConstrainedWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(
            with: constraintRect,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: [NSAttributedString.Key.font: font],
            context: nil
        )
        return ceil(boundingBox.height)
    }
}
