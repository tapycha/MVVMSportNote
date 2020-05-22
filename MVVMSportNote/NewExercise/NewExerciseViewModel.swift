//
//  NewExerciseViewModel.swift
//  MVVMSportNote
//
//  Created by Andrew Peneznyk on 22.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import Foundation


protocol NewExerciseViewModelProtocol: class {
    
    
    var viewModelDidChanged: ((NewExerciseViewModelProtocol) -> Void)? {get set}
    
    
    func updateUI() -> Void
    func updateTableViewIfNeeded() -> Void
    func numberOfRowsInSection()-> Int
    func getText(index: Int)-> String
    func loadSelectedField(index: Int)
    func loadSearchText(searchText: String)
    func getSelectedField() -> String
}

class NewExerciseViewModel: NSObject, NewExerciseViewModelProtocol {
    
    
    
    var searchText = [String]()
    var searching = false
    var selectedField: String = ""
    var viewModelDidChanged: ((NewExerciseViewModelProtocol) -> Void)?
    
    private var myModel: NewExerciseModel
    
    override init() {
        myModel = NewExerciseModel()
        super.init()
    }
    
    func updateUI() {
        self.viewModelDidChanged?(self)
    }
    func updateTableViewIfNeeded() {
        //coredata
        self.viewModelDidChanged?(self)
        
    }
    func getSelectedField() -> String {
        return selectedField
    }
    func numberOfRowsInSection() -> Int {
        
        if searching
        {
            return searchText.count
        }
        else
        {
            return myModel.choise.count
        }
    }
    func getText(index: Int) -> String {
        if searching
        {
            return searchText[index]
        }
        else
        {
            return myModel.choise[index]
        }
    }
    func loadSelectedField(index: Int) {
        selectedField  = myModel.choise[index]
    }
    func loadSearchText(searchText: String) {
        self.searchText = myModel.choise.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching =  searchText.count > 0
        updateTableViewIfNeeded()
    }
    
    
}
