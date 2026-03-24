//
//  SingleNoteView.swift
//  notes-app
//
//  Created by Tsotne Shilakadze on 17.01.26.
//

import UIKit

class SingleNoteView: UIViewController {
    
    let screenHeight = UIScreen.main.bounds.height
    let screenWidth = UIScreen.main.bounds.width
    
    var note: Note?
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let backButton: UIButton = {
        let back_button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "arrow.backward")
        back_button.setImage(plusImage, for: .normal)
        back_button.tintColor = .darkGray
        return back_button
    }()
    
    @objc func backToNotes() {
        saveEdition()
    }
    
    private let noteTitle: UILabel = {
        let res_label = UILabel()
        res_label.text = "Edit Note"
        return res_label
    }()
    
    private let saveButton: UIButton = {
        let save_button = UIButton(type: .system)
        let switch_image = UIImage(systemName: "checkmark")
        save_button.setImage(switch_image, for: .normal)
        save_button.tintColor = .darkGray
        return save_button
    }()
    
    @objc func saveEdition() {
        guard let note = note else { return }
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        note.title = titleField.text ?? ""
        note.note_text = textView.text ?? ""
        note.date_updated = Date()
        try? context.save()
        self.dismiss(animated: true, completion: nil)
    }
    
    private let titleField: UITextField = {
        let title = UITextField()
        title.placeholder = "Title"
        title.font = UIFont.boldSystemFont(ofSize: 22)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private let textView: UITextView = {
        let text = UITextView()
        text.font = UIFont.systemFont(ofSize: 18)
        text.isScrollEnabled = true
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private func setupLayout() {
        view.addSubview(headerView)
        headerView.addSubview(headerStack)
        headerStack.addArrangedSubview(backButton)
        backButton.addTarget(self, action: #selector(backToNotes), for: .touchUpInside)
        headerStack.addArrangedSubview(noteTitle)
        headerStack.addArrangedSubview(saveButton)
        saveButton.addTarget(self, action: #selector(saveEdition), for: .touchUpInside)
        
        view.addSubview(titleField)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: screenHeight * 0.07),
            
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: screenWidth * 0.04),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -screenWidth * 0.04),
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            titleField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: screenHeight * 0.015),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.04),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.04),
            titleField.heightAnchor.constraint(equalToConstant: screenHeight * 0.06),
            
            textView.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: screenHeight * 0.01),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.03),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.03),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    private func populateIfNeeded() {
        guard let note = note else { return }
        titleField.text = note.title
        textView.text = note.note_text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Edit Note"
        setupLayout()
        populateIfNeeded()
    }
    
}
