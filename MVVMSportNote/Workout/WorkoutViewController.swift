//
//  WorkoutViewController.swift
//  MVPSportNote
//
//  Created by Andrew Peneznyk on 20.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import UIKit

protocol  WorkoutDisplayLogic: NSObjectProtocol {
    func setEmpty() -> Void
    func removeEmpty() -> Void
    func updateTableView() -> Void
}


class WorkoutViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var addButton: UIView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    var modelView: WorkoutViewModelProtocol! {
        didSet {
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                guard let self = self else { return }
                if viewModel.numberOfExercise() > 0 {
                    self.removeEmpty()
                    self.updateTableView()
                } else {
                    self.setEmpty()
                }
            }
        }
    }

    var previousExpand = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = modelView.getTitle()
        tableView?.dataSource = self
        tableView?.delegate = self
        addButton.layer.cornerRadius = addButton.frame.height/2
        tableView.register(UINib(nibName: "WorkoutHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkoutHeaderTableViewCell")
        tableView.register(UINib(nibName: "WorkoutTableViewCell", bundle: nil), forCellReuseIdentifier: "WorkoutTableViewCell")
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
              performSegue(withIdentifier: "NewExerciseSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination =  segue.destination as? NewExerciseViewController{
                   destination.delegate = self
            destination.modelView  = NewExerciseViewModel()
               }
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
    }
}
extension WorkoutViewController: WorkoutDisplayLogic
{
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
extension WorkoutViewController: UITableViewDataSource,UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  modelView.numberOfRowsInSection(index: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutHeaderTableViewCell", for: indexPath) as! WorkoutHeaderTableViewCell
            cell.setupCell(index: indexPath.section, data: modelView.getExerciseModel(at: indexPath.section),state: modelView.isEdit)
            cell.cellDelegate = self
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "WorkoutTableViewCell", for: indexPath) as! WorkoutTableViewCell
            cell.setupCell(index: indexPath.section, data: modelView.getExerciseModel(at: indexPath.section),state: modelView.isEdit)
            return cell
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return modelView.numberOfExercise()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        modelView.swapExercise(source: sourceIndexPath.row, destination: destinationIndexPath.row)
 
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

           if previousExpand != -1 && previousExpand != indexPath.section
           {
            modelView.setOpen(index: previousExpand,state: false)
                let sections1 = IndexSet.init(integer: previousExpand)
                tableView.reloadSections(sections1, with: .none)
           }

        modelView.swapOpen(index: indexPath.section)
        let sections = IndexSet.init(integer: indexPath.section)
        tableView.reloadSections(sections, with: .none)
        previousExpand = indexPath.section
    }
    
}
extension WorkoutViewController:HomeTableViewCellProtocol{
    func OnXClick(index: Int) {
        let DeleteAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete workout?\n You can`t udo this action", preferredStyle: UIAlertController.Style.alert)
        DeleteAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { (action: UIAlertAction!) in
            self.modelView.removeExercise(byIndex: index)
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
        
    }
    
}
extension WorkoutViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        (viewController as? HomeViewController)?.modelView.loadWorkout(data: modelView.getModel())
    }
}
extension WorkoutViewController: NewUnitDisplayLogic {
    func getNewExercise(title: String, index: Int) {
        modelView.addExercise(title: title, index: index)
    }
    
    
}
