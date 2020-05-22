//
//  NewExerciseViewController.swift
//  MVPSportNote
//
//  Created by Andrew Peneznyk on 21.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import UIKit

protocol  NewExerciseDisplayLogic: NSObjectProtocol {
    
}


class NewExerciseViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    
    

    var delegate: NewUnitDisplayLogic?
    
    
    var modelView: NewExerciseViewModel! {
        didSet {
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                guard let self = self else { return }
                self.updateTableView()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        tableView.register( UITableViewCell.self, forCellReuseIdentifier: "Cell")
        definesPresentationContext = true
        searchBar.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? NewUnitViewController{
            destination.modelView = NewUnitViewModel(field: modelView.getSelectedField())
            destination.delegate = delegate
            delegate = nil
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }
    
}
extension NewExerciseViewController: NewExerciseDisplayLogic{
    func updateTableView() -> Void {
        tableView.reloadData()
    }
}
extension NewExerciseViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! UITableViewCell
        cell.textLabel?.text = modelView.getText(index: indexPath.row)
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modelView.loadSelectedField(index: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "NewUnitSegue", sender: self)
    }
    
}
extension NewExerciseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        modelView.loadSearchText(searchText: searchText)

    }
}
