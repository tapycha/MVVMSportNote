//
//  WorkoutViewModel.swift
//  MVVMSportNote
//
//  Created by Andrew Peneznyk on 22.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import Foundation

protocol WorkoutViewModelProtocol: class {
    
    var isEdit: Bool { get }
    
    var viewModelDidChanged: ((WorkoutViewModelProtocol) -> Void)? {get set}
    
    func getTitle()->String
    func getModel()->WorkoutModel
    func numberOfExercise() -> Int
    func updateUI() -> Void
    func numberOfRowsInSection(index: Int) -> Int
    func updateTableViewIfNeeded() -> Void
    func getExerciseModel(at index: Int) -> Exersice
    func removeExercise(byIndex index: Int) -> Void
    func addExercise(title: String, index: Int) -> Void
    func swapExercise(source: Int,destination: Int)
    func swapEdit()
    func setOpen(index: Int, state: Bool)
    func swapOpen(index: Int)
}

class WorkoutViewModel: NSObject, WorkoutViewModelProtocol {
    
    
    var isEdit: Bool {
        if(numberOfExercise() == 0)
        {
            edit = false
        }
        return edit
    }
    var edit = false
    var viewModelDidChanged: ((WorkoutViewModelProtocol) -> Void)?
    
    private var myModel: WorkoutModel
    
    override init() {
        myModel = WorkoutModel()
        super.init()
    }
    init(model: WorkoutModel)
    {
        myModel = model
               super.init()
    }
    func getTitle() -> String {
        return myModel.workout.name
    }
    func updateUI() {
        self.viewModelDidChanged?(self)
    }
    func swapEdit(){
        edit = !edit
    }
    func getModel() -> WorkoutModel {
        return myModel
    }
    func updateTableViewIfNeeded() {
        //coredata
        self.viewModelDidChanged?(self)
        
    }
    func setOpen(index: Int, state: Bool) {
        myModel.workout.exersice[index].isOpen = state
    }
    func swapOpen(index: Int) {
        myModel.workout.exersice[index].isOpen = !myModel.workout.exersice[index].isOpen
    }
    func numberOfRowsInSection(index: Int) -> Int {
        if myModel.workout.exersice[index].isOpen {
            return 2
        }
        else
        {
            return 1
        }
    }
    func numberOfExercise() -> Int {
        return self.myModel.workout.exersice.count
    }
    
    func getExerciseModel(at index: Int) -> Exersice {
        return myModel.workout.exersice[index]
    }
    
    func removeExercise(byIndex index: Int) -> Void {
        myModel.workout.exersice.remove(at: index)
        
        if myModel.workout.exersice.count>0 {
            for i in 0...myModel.workout.exersice.count-1
            {
                myModel.workout.exersice[i].id = i+1
            }
        }
        updateTableViewIfNeeded()
    }
    func addExercise(title: String, index: Int) {
        let unit1 =  ["km", "kg"]
        let unit2 =  ["min","times"]
        var temp = Exersice();
        temp.id = myModel.workout.exersice.count+1
        temp.title = title
        temp.unit1 = unit1[index]
        temp.unit2 = unit2[index]
        myModel.workout.exersice.append(temp)
        updateTableViewIfNeeded()
    }
    func swapExercise(source: Int,destination: Int)  {
        let workoutMove = myModel.workout.exersice[source]
        
        myModel.workout.exersice.insert(workoutMove, at:source<destination ? destination + 1 :  destination)
        myModel.workout.exersice.remove(at: source>destination ? source + 1 : source)
        
        for i in 0...myModel.workout.exersice.count-1
        {
            myModel.workout.exersice[i].id = i+1
        }
        updateTableViewIfNeeded()
    }
    
}
