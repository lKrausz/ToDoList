//
//  ViewController.swift
//  todolist
//
//  Created by Виктория Козырева on 17.03.2021.
//

import UIKit
import CoreData


class ViewController: UIViewController {
    
    var tableView = UITableView.init(frame: .zero, style: .plain)
    var todoItemList: [ToDoItemModel] = []
    var fetchedResultsController: NSFetchedResultsController<ToDoItemModel>!
    var offset = 0
    var limit = 25
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        //        for i in 1...1000 {
        //            let newTask = ToDoItemModel(context: DataManager.shared.context())
        //            newTask.title = "Task #\(i)"
        //            newTask.isCompletion = false
        //
        //            DataManager.shared.saveContext()
        //            self.fetchData()
        //        }
    }
    
    
    func config() {
        self.loadSavedData()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTap))
        view.backgroundColor = .systemBackground
        configTableView()
        configConstraints()
    }
    
    
    
    @IBAction func addTap(_ sender: Any) {
        let alert = UIAlertController(title: "Add new task", message: "What u need to do?", preferredStyle: .alert)
        alert.addTextField()
        
        let submitButton = UIAlertAction(title: "Add task", style: .default) { (action) in
            let textfield = alert.textFields![0]
            
            let newTask = ToDoItemModel(context: DataManager.shared.context())
            newTask.title = textfield.text
            newTask.isCompletion = false
            
            DataManager.shared.saveContext()
            self.loadSavedData()
        }
        alert.addAction(submitButton)
        self.present(alert, animated: true)
    }
    
    func loadSavedData() {
        if fetchedResultsController == nil {
            
            let request = ToDoItemModel.fetchRequest() as NSFetchRequest<ToDoItemModel>
            //let sort = NSSortDescriptor(key: "title", ascending: false)
            request.sortDescriptors = []
            request.fetchOffset = self.offset
            request.fetchLimit = self.limit
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.context(), sectionNameKeyPath: nil, cacheName: "CACHENAME")
        }
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Fetch failed")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func configTableView() {
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
    }
    
    func configConstraints() {
        
        let top = NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        view.addConstraints([top, bottom, leading,trailing])
    }
    func addItems() {
      let lastLimit = self.limit + 20
        self.limit = lastLimit

      fetchedResultsController.fetchRequest.fetchOffset = self.offset
      fetchedResultsController.fetchRequest.fetchLimit = lastLimit
        loadSavedData()
      do {
        NSFetchedResultsController<ToDoItemModel>.deleteCache(withName: fetchedResultsController.cacheName)
        try fetchedResultsController.performFetch()
      } catch {
        print("--->> Oops, perform fetch failed")
      }
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.config(todoItem: fetchedResultsController.object(at: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = self.fetchedResultsController.object(at: indexPath)
        if (task.isCompletion) {
            task.isCompletion = false
        }else {
            task.isCompletion = true
        }
        DataManager.shared.saveContext()
        self.loadSavedData()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            let sectionInfo = self.fetchedResultsController.sections![indexPath.section]
            if indexPath.row == sectionInfo.numberOfObjects-5{
                self.addItems()
           }
        }
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let edit = UIAction(title: "Edit") { edit in
                let editTask = self.fetchedResultsController.object(at: indexPath)
                let alert = UIAlertController(title: "Edit task", message: "", preferredStyle: .alert)
                alert.addTextField()
                let textfield = alert.textFields![0]
                textfield.text = editTask.title
                let submitButton = UIAlertAction(title: "Edit task", style: .default) { (action) in
                    editTask.title = textfield.text
                    DataManager.shared.saveContext()
                    self.loadSavedData()
                }
                alert.addAction(submitButton)
                self.present(alert, animated: true)
                DataManager.shared.saveContext()
                self.loadSavedData()
            }
            let delete = UIAction(title: "Delete", attributes: .destructive) { delete in
                let removeTask = self.fetchedResultsController.object(at: indexPath)
                DataManager.shared.context().delete(removeTask)
                DataManager.shared.saveContext()
                self.loadSavedData()
            }
            return UIMenu.init(children: [edit, delete])
        }
        return configuration
    }
}

