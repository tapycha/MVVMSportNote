//
//  ViewController.swift
//  MVPSportNote
//
//  Created by Andrew Peneznyk on 19.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import UIKit



protocol  HomeDisplayLogic: NSObjectProtocol {
    func setEmpty() -> Void
    func removeEmpty() -> Void
    func updateTableView() -> Void
}


class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    @IBOutlet weak var addButton: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    
    var modelView: HomeViewModelProtocol! {
        didSet {
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                guard let self = self else { return }
                if viewModel.numberOfWorkout() > 0 {
                    self.removeEmpty()
                    self.updateTableView()
                } else {
                    self.setEmpty()
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modelView = HomeViewModel()
        tableView?.dataSource = self
        tableView?.delegate = self
        addButton.layer.cornerRadius = addButton.frame.height/2
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        modelView.updateUI()
    }
    @IBAction func EditTapped(_ sender: Any) {
        modelView.swapEdit()
        editButton.image =  UIImage(systemName: modelView.isEdit ?"checkmark.circle": "pencil.circle")
        addButton.isHidden = modelView.isEdit
        tableView.setEditing(modelView.isEdit, animated: true)
        modelView.updateTableViewIfNeeded()
    }
    
    @IBAction func AddTapped(_ sender: Any) {
        modelView.addWorkout()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? WorkoutViewController{
            destination.modelView  = WorkoutViewModel(model: WorkoutModel( workout:
            modelView.getWorkoutModel(at: (tableView.indexPathForSelectedRow?.row)!)))
        }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }


}
extension HomeViewController:HomeDisplayLogic{
    func removeEmpty() {
     emptyView.isHidden = true
           editButton.isEnabled = true
        
    }
    
    func setEmpty() -> Void {
      emptyView.isHidden = false
      editButton.isEnabled = false
        
    }
    
    func updateTableView() -> Void {
        tableView.reloadData()
    }
    
}
extension HomeViewController:UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.numberOfWorkout()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.setupCell(index: indexPath.row, data: modelView.getWorkoutModel(at: indexPath.row),state: modelView.isEdit)
        cell.cellDelegate = self
        return cell
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        modelView.swapWorkout(source: sourceIndexPath.row, destination: destinationIndexPath.row)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "WorkoutSegue", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension HomeViewController:HomeTableViewCellProtocol{
    func OnXClick(index: Int) {
        let DeleteAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete workout?\n You can`t udo this action", preferredStyle: UIAlertController.Style.alert)
        DeleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.modelView.removeWorkout(byIndex: index)

            self.editButton.image =  UIImage(systemName: self.modelView.isEdit ?"checkmark.circle": "pencil.circle")
            self.addButton.isHidden = self.modelView.isEdit
            self.tableView.setEditing(self.modelView.isEdit, animated: true)

               }))

               DeleteAlert.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler: { (action: UIAlertAction!) in
                   //if anything to do after cancel clicked
               }))
               present(DeleteAlert, animated: true, completion: nil)
         
    }
    func NameChanged(index: Int, newName: String){
        modelView.changeWorkoutName(index: index, newName: newName)
    }
    
}
