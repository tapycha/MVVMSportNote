//
//  HomeViewModel.swift
//  MVVMSportNote
//
//  Created by Andrew Peneznyk on 22.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import Foundation


protocol HomeViewModelProtocol: class {
    
    var isEdit: Bool { get }
    
    var viewModelDidChanged: ((HomeViewModelProtocol) -> Void)? {get set}
    
    func numberOfWorkout() -> Int
    func updateUI() -> Void
    func updateTableViewIfNeeded() -> Void
    func getWorkoutModel(at index: Int) -> Workout
    func removeWorkout(byIndex index: Int) -> Void
    func addWorkout() -> Void
    func swapWorkout(source: Int,destination: Int)
    func swapEdit()
    func changeWorkoutName(index: Int, newName: String)
    func loadWorkout(data: WorkoutModel)
}

class HomeViewModel: NSObject, HomeViewModelProtocol {
    
    var isEdit: Bool {
        if(numberOfWorkout() == 0)
        {
            edit = false
        }
        return edit
    }
    var edit = false
    var viewModelDidChanged: ((HomeViewModelProtocol) -> Void)?
    
    private var myModel: HomeModel
    
    override init() {
        myModel = HomeModel()
        super.init()
    }
    
    func updateUI() {
        self.viewModelDidChanged?(self)
    }
    func swapEdit(){
        edit = !edit
    }
    func loadWorkout(data: WorkoutModel) {
             myModel.workout[data.workout.id] = data.workout
    }
    func changeWorkoutName(index: Int, newName: String) {
         myModel.workout[index].name = newName
    }
    func updateTableViewIfNeeded() {
//coredata
        self.viewModelDidChanged?(self)
        
    }
    
    func numberOfWorkout() -> Int {
        return self.myModel.workout.count
    }
    
    func getWorkoutModel(at index: Int) -> Workout {
        return myModel.workout[index]
    }
    
    func removeWorkout(byIndex index: Int) -> Void {
        myModel.workout.remove(at: index)

        if myModel.workout.count>0 {
            for i in 0...myModel.workout.count-1
            {
                myModel.workout[i].id = i+1
            }
        }
        updateTableViewIfNeeded()
    }
    func addWorkout() {
        var temp = Workout();
        temp.id = myModel.workout.count+1
        temp.name = "Workout \(temp.id)"
        myModel.workout.append(temp)
        updateTableViewIfNeeded()
    }
    func swapWorkout(source: Int,destination: Int)  {
        let workoutMove = myModel.workout[source]
        
        myModel.workout.insert(workoutMove, at:source<destination ? destination + 1 :  destination)
        myModel.workout.remove(at: source>destination ? source + 1 : source)
        
        for i in 0...myModel.workout.count-1
        {
            myModel.workout[i].id = i+1
        }
        updateTableViewIfNeeded()
    }
    
}
