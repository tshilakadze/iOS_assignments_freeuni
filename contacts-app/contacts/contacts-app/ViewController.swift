//
//  ViewController.swift
//  contacts-app
//
//  Created by Tsotne Shilakadze on 25.12.25.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    var collectionViewActive = false
    
    var contacts: [Contact] = []
    
    struct Section{
        let letter: String
        let names_numbers: [Contact]
        var expanded: Bool = true
    }
    
    var sections = [Section]()
    
    @objc func addContactPressed(_ sender: UIButton) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let actionSheet = UIAlertController(title: "Add Contact", message: nil, preferredStyle: .alert)
        actionSheet.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .default
        }
        actionSheet.addTextField{(textField) in
            textField.placeholder = "Phone Number"
            textField.keyboardType = .default
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            let name = actionSheet.textFields?[0].text ?? ""
            let number = actionSheet.textFields?[1].text ?? ""
            if(name.isEmpty || number.isEmpty){
                return
            }
            let contact = Contact(context: context)
            contact.name = name;
            contact.phone_number = number
            try? context.save()
            self.fetchContacts()
        }
        actionSheet.addAction(cancelAction)
        actionSheet.addAction(addAction)
        present(actionSheet, animated: true)
    }
    
    @objc func switchLayoutPressed(_ sender: UIButton) {
        collectionViewActive.toggle()
        tableView.isHidden = collectionViewActive
        collectionView.isHidden = !collectionViewActive
        let imageName = collectionViewActive ? "list.bullet" : "circle.grid.3x3.fill"
        switchButton.setImage(UIImage(systemName: imageName), for: .normal)
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func contactPressed(_ contact: Contact){
        let newView = SingleContactView()
        newView.contact = contact
        newView.modalPresentationStyle = .fullScreen
        newView.modalTransitionStyle = .crossDissolve
        present(newView, animated: true, completion: nil)
    }
    
    private func showDeleteConfirmation(for contact: Contact) {
        let alert = UIAlertController(
            title: "Delete?",
            message: "Are you sure you want to delete " + contact.name! + " from contacts?",
            preferredStyle: .actionSheet
        )
        let deleteAction = UIAlertAction(
            title: "Delete",
            style: .destructive
        ) { _ in
            self.deleteContact(contact)
        }
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style: .cancel
        )
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    
    func deleteContact(_ contact: Contact){
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(contact)
        do{
            try context.save()
            fetchContacts()
        } catch{
            print("Couldn't delete contact", error)
        }
    }
    
    @objc private func toggleSection(_ sender: UIButton) {
        let section = sender.tag
        sections[section].expanded.toggle()
        if(!collectionViewActive){
            tableView.performBatchUpdates({
                tableView.reloadSections(IndexSet(integer: section), with: .automatic)
            })
        } else{
            collectionView.performBatchUpdates({
                collectionView.reloadSections(IndexSet(integer: section))
            })
        }
        
    }
    
    
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
        add_button.backgroundColor = .secondarySystemBackground
        add_button.tintColor = .blue
        return add_button
    }()
    
    private let contactsTitle: UILabel = {
        let res_label = UILabel()
        res_label.text = "Contacts"
        return res_label
    }()
    
    private let switchButton: UIButton = {
        let switch_button = UIButton(type: .system)
        let switch_image = UIImage(systemName: "circle.grid.3x3.fill")
        switch_button.setImage(switch_image, for: .normal)
        switch_button.backgroundColor = .secondarySystemBackground
        switch_button.tintColor = .blue
        return switch_button
    }()
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .secondarySystemBackground
        return view
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    func fetchContacts() {
        let request: NSFetchRequest<Contact> = Contact.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(key: "name", ascending: true)
        ]
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do {
            contacts = try context.fetch(request)
            let groupedDictionary = Dictionary(grouping: contacts) { (contact) -> String in
                return String(contact.name?.prefix(1).uppercased() ?? "#")
            }
            self.sections = groupedDictionary.map { Section(letter: $0.key, names_numbers: $0.value) }
                .sorted { $0.letter < $1.letter }
            tableView.reloadData()
            collectionView.reloadData()
        } catch {
            print("Failed to fetch contacts:", error)
        }
    }
    
    private func setUpDisplay() {
        view.backgroundColor = .systemBackground
        title = "Contacts"
        view.addSubview(headerView)
        view.addSubview(collectionView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ContactCellForGrid.self, forCellWithReuseIdentifier: "GridCell")
        collectionView.isHidden = true
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "SectionHeader"
        )
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleCollectionLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        
        
        headerView.addSubview(headerStack)
        
        addButton.addTarget(self, action: #selector(addContactPressed(_:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchLayoutPressed(_:)), for: .touchUpInside)
        
        headerStack.addArrangedSubview(addButton)
        headerStack.addArrangedSubview(contactsTitle)
        headerStack.addArrangedSubview(switchButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: screenHeight * 0.07),
            
            headerStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: screenWidth * 0.04),
            headerStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -screenWidth * 0.04),
            headerStack.topAnchor.constraint(equalTo: headerView.topAnchor),
            headerStack.bottomAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: screenWidth * 0.02),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -screenWidth * 0.02)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setUpDisplay()
        fetchContacts()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].expanded ? sections[section].names_numbers.count : 0
    }
    
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return screenHeight * 0.055
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        let header = UIView()
        header.backgroundColor = .secondarySystemBackground
        
        let letterLabel = UILabel()
        letterLabel.text = sections[section].letter
        letterLabel.font = .boldSystemFont(ofSize: screenHeight * 0.025)
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let actionButton = UIButton(type: .system)
        let title = sections[section].expanded ? "Collapse" : "Expand"
        actionButton.setTitle(title, for: .normal)
        actionButton.tag = section
        actionButton.addTarget(self, action: #selector(toggleSection(_:)), for: .touchUpInside)
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        
        header.addSubview(letterLabel)
        header.addSubview(actionButton)
        
        NSLayoutConstraint.activate([
            letterLabel.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: screenWidth * 0.04),
            letterLabel.centerYAnchor.constraint(equalTo: header.centerYAnchor),
            
            actionButton.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -screenWidth * 0.04),
            actionButton.centerYAnchor.constraint(equalTo: header.centerYAnchor)
        ])
        return header
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath)
        let contact = sections[indexPath.section].names_numbers[indexPath.row]
        cell.textLabel?.text = contact.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contact = sections[indexPath.section].names_numbers[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        contactPressed(contact)
    }
    
    //Delete
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Delete"
        ) { [weak self] _, _, completion in
            guard let self = self else { return }
            let contact = self.sections[indexPath.section].names_numbers[indexPath.row]
            self.showDeleteConfirmation(for: contact)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    
    //Collection view methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].expanded ? sections[section].names_numbers.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as! ContactCellForGrid
        let contact = sections[indexPath.section].names_numbers[indexPath.item]
        cell.configure(name: contact.name ?? "", phone: contact.phone_number ?? "")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let contact = sections[indexPath.section].names_numbers[indexPath.item]
        contactPressed(contact)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing = (screenWidth * 0.02) * 3
        let availableWidth = screenWidth - totalSpacing
        let cellWidth = availableWidth / 4
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: screenHeight / 26)
    }
    
    
    //Delete
    @objc private func handleCollectionLongPress(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        let point = gesture.location(in: collectionView)
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        let contact = sections[indexPath.section].names_numbers[indexPath.item]
        showDeleteConfirmation(for: contact)
    }
    
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeader.identifier,
            for: indexPath
        ) as! SectionHeader
        
        let section = sections[indexPath.section]
        
        header.headerLabel.text = section.letter
        header.expand_collapse_button.setTitle(
            section.expanded ? "Collapse" : "Expand",
            for: .normal
        )
        
        header.expand_collapse_button.tag = indexPath.section
        header.expand_collapse_button.addTarget(
            self,
            action: #selector(toggleSection(_:)),
            for: .touchUpInside
        )
        
        return header
    }
    
}
