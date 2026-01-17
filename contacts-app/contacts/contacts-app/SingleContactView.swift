//
//  SingleContactView.swift
//  contacts-app
//
//  Created by Tsotne Shilakadze on 25.12.25.
//

import UIKit

class SingleContactView: UIViewController{
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var contact: Contact!
    
    let initialLabel = UILabel()
        let nameLabel = UILabel()
        let numberLabel = UILabel()
        let circleView = UIView()
    
    func newButton(imageName: String, buttonString: String) -> UIButton{
        var buttonSettings = UIButton.Configuration.plain()
        buttonSettings.title = buttonString
        buttonSettings.image = UIImage(systemName: imageName)
        buttonSettings.imagePlacement = .top
        buttonSettings.imagePadding = screenHeight * 0.005
        buttonSettings.baseForegroundColor = .systemBlue
        buttonSettings.titleAlignment = .center
        buttonSettings.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: self.screenWidth * 0.03)
            return outgoing
        }
        let result = UIButton(configuration: buttonSettings)
        result.titleLabel?.numberOfLines = 1
        result.titleLabel?.adjustsFontSizeToFitWidth = true
        result.titleLabel?.minimumScaleFactor = 0.8
        return result
    }
    
    @objc func backToContacts() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateDisplay() {
        nameLabel.text = contact.name
        numberLabel.text = contact.phone_number
        if let name = contact.name, let first = name.first {
            initialLabel.text = String(first).uppercased()
        } else {
            initialLabel.text = "?"
        }
    }
    
    @objc func callPressed() {
        let outgoing_call = OutgoingCallView()
        outgoing_call.name = contact.name
        outgoing_call.modalPresentationStyle = .fullScreen
        outgoing_call.modalTransitionStyle = .crossDissolve
        present(outgoing_call, animated: true, completion: nil)
    }
    
    @objc func editContact() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let actionSheet = UIAlertController(title: "Edit Contact", message: nil, preferredStyle: .alert)
        actionSheet.addTextField { (textField) in
            textField.text = self.contact.name
            textField.placeholder = "Name"
        }
        actionSheet.addTextField { (textField) in
            textField.text = self.contact.phone_number
            textField.placeholder = "Phone Number"
            textField.keyboardType = .phonePad
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Save", style: .default){ _ in
            let newName = actionSheet.textFields?[0].text ?? ""
            let newNumber = actionSheet.textFields?[1].text ?? ""
            if(!newName.isEmpty){
                self.contact.name = newName
            }
            if(!newNumber.isEmpty){
                self.contact.phone_number = newNumber
            }
            try? context.save()
            self.updateDisplay()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(addAction)
        present(actionSheet, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let circleSize = screenWidth * 0.32
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.backgroundColor = UIColor.systemGray5
        circleView.layer.cornerRadius = circleSize / 2
        circleView.layer.masksToBounds = true
        view.addSubview(circleView)
        
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        initialLabel.font = .boldSystemFont(ofSize: screenWidth * 0.14)
        initialLabel.textColor = .label
        initialLabel.textAlignment = .center
        circleView.addSubview(initialLabel)
        
        if let name = contact.name, let first = name.first {
            initialLabel.text = String(first).uppercased()
        } else {
            initialLabel.text = "?"
        }
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = .systemFont(ofSize: screenWidth * 0.07, weight: .semibold)
        nameLabel.textColor = .label
        nameLabel.textAlignment = .center
        nameLabel.text = contact.name
        view.addSubview(nameLabel)
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        numberLabel.font = .systemFont(ofSize: screenWidth * 0.05)
        numberLabel.textColor = .secondaryLabel
        numberLabel.textAlignment = .center
        numberLabel.text = contact.phone_number
        view.addSubview(numberLabel)
        
        let buttonsStack = UIStackView()
        let messageButton = newButton(imageName: "message.fill", buttonString: "message")
        let callButton = newButton(imageName: "phone.fill", buttonString: "call")
        callButton.addTarget(self, action: #selector(callPressed), for: .touchUpInside)
        let facetimeButton = newButton(imageName: "video.fill", buttonString: "facetime")
        let mailButton = newButton(imageName: "envelope.fill", buttonString: "mail")
        let payButton = newButton(imageName: "dollarsign.circle.fill", buttonString: "pay")
        
        buttonsStack.addArrangedSubview(messageButton)
        buttonsStack.addArrangedSubview(callButton)
        buttonsStack.addArrangedSubview(facetimeButton)
        buttonsStack.addArrangedSubview(mailButton)
        buttonsStack.addArrangedSubview(payButton)
        
        buttonsStack.axis = .horizontal
        buttonsStack.distribution = .equalCentering
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(buttonsStack)
        NSLayoutConstraint.activate([
            circleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.04),
            circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            circleView.widthAnchor.constraint(equalToConstant: circleSize),
            circleView.heightAnchor.constraint(equalToConstant: circleSize),
            
            initialLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            initialLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: screenHeight * 0.03),
            nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: screenWidth * 0.06),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -screenWidth * 0.06),
            
            buttonsStack.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: screenHeight * 0.03),
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStack.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: screenWidth * 0.06),
            buttonsStack.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -screenWidth * 0.06),
            
            numberLabel.topAnchor.constraint(equalTo: buttonsStack.bottomAnchor, constant: screenHeight * 0.04),
            numberLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.08),
            numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -screenWidth * 0.08),
            numberLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: screenWidth * 0.06),
            numberLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -screenWidth * 0.06),
            
            
        ])
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("Contacts", for: .normal)
        backButton.titleLabel?.font = .systemFont(ofSize: screenWidth * 0.045, weight: .medium)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backToContacts), for: .touchUpInside)
        view.addSubview(backButton)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.015),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.05)
        ])
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: screenWidth * 0.045, weight: .medium)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.addTarget(self, action: #selector(editContact), for: .touchUpInside)
        view.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: screenHeight * 0.015),
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.05)
        ])
    }
}
