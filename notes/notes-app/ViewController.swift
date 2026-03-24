//
//  ViewController.swift
//  notes-app
//
//  Created by Tsotne Shilakadze on 17.01.26.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CustomLayoutDelegate {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var notes: [Note] = []
    
    @objc func addNotePressed(_ sender: UIButton){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let note = Note(context: context)
        note.title = ""
        note.note_text = ""
        note.date_updated = Date()
        try? context.save()
        let blank_note = SingleNoteView()
        blank_note.note = note
        blank_note.modalPresentationStyle = .fullScreen
        blank_note.modalTransitionStyle = .crossDissolve
        present(blank_note, animated: true, completion: nil)
    }
    
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
    
    private let addButton: UIButton = {
        let add_button = UIButton(type: .system)
        let plusImage = UIImage(systemName: "plus")
        add_button.setImage(plusImage, for: .normal)
        add_button.tintColor = .darkGray
        return add_button
    }()
    
    private let notesTitle: UILabel = {
        let res_label = UILabel()
        res_label.text = "Recent Notes"
        return res_label
    }()
    
    private let searchButton: UIButton = {
        let search_button = UIButton(type: .system)
        let switch_image = UIImage(systemName: "magnifyingglass")
        search_button.setImage(switch_image, for: .normal)
        search_button.tintColor = .darkGray
        return search_button
    }()
    
    private let collectionView: UICollectionView = {
        let layout = CustomLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    
    func fetchNotes() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<Note> = Note.fetchRequest()
        let sort = NSSortDescriptor(key: "date_updated", ascending: false)
        request.sortDescriptors = [sort]
        do {
            notes = try context.fetch(request)
            collectionView.reloadData()
        } catch {
            print("Failed to fetch notes:", error)
        }
    }
    
    private func setUpDisplay(){
        view.backgroundColor = .systemBackground
        title = "Notes"
        
        view.addSubview(headerView)
        view.addSubview(collectionView)
        headerView.addSubview(headerStack)
        headerStack.addArrangedSubview(addButton)
        headerStack.addArrangedSubview(notesTitle)
        headerStack.addArrangedSubview(searchButton)
        
        addButton.addTarget(self, action: #selector(addNotePressed(_:)), for: .touchUpInside)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(NoteCell.self, forCellWithReuseIdentifier: NoteCell.identifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleCollectionLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: screenHeight * 0.07),
            
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: screenWidth * 0.04),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -screenWidth * 0.04),
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.02),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.02)
        ])
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchNotes()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpDisplay()
        if let layout = collectionView.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: NoteCell.identifier,
            for: indexPath
        ) as? NoteCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: notes[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let single_note = SingleNoteView()
        single_note.note = notes[indexPath.item]
        single_note.modalPresentationStyle = .fullScreen
        single_note.modalTransitionStyle = .crossDissolve
        present(single_note, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath, with width: CGFloat) -> CGFloat {
        let height = NoteCell.height(for: notes[indexPath.item], width: width, screenWidth: screenWidth, screenHeight: screenHeight)
        return height
    }
    
    
    
    @objc private func handleCollectionLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state != .began { return }
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else { return }
        let noteToDelete = notes[indexPath.item]
        let actionSheet = UIAlertController(title: "Delete Note?", message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(noteToDelete)
            try? context.save()
            self.fetchNotes()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(deleteAction)
        present(actionSheet, animated: true)
    }
    
}
