//
//  NewUnitViewModel.swift
//  MVVMSportNote
//
//  Created by Andrew Peneznyk on 22.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import Foundation


protocol NewUnitViewModelProtocol: class {
    
    
    var viewModelDidChanged: ((NewUnitViewModelProtocol) -> Void)? {get set}
    
    func updateUI() -> Void
    func updateTableViewIfNeeded() -> Void
    func getSelectedField()-> String
    func getArray(index: Int) -> String
    func numberOfRowsInComponent() -> Int
    func getIndex()-> Int
    func setIndex(index: Int)
}

class NewUnitViewModel: NSObject, NewUnitViewModelProtocol {

    
    
    let array:[String] = [ "Distance (km) / Time (min)", "Weight (kg) / Reps (times)"]
    var selectedField :String?
    var index = 0
    var edit = false
    var viewModelDidChanged: ((NewUnitViewModelProtocol) -> Void)?
    
    override init() {
        super.init()
    }
    init (field: String){
        selectedField = field
        super.init()
    }
    func getSelectedField() -> String {
        return selectedField!
    }
    func getArray(index: Int) -> String {
        return array[index]
    }
    func numberOfRowsInComponent() -> Int {
        return array.count
    }
    func updateUI() {
        self.viewModelDidChanged?(self)
    }
    func getIndex() -> Int {
        return index
    }
    func setIndex(index: Int) {
        self.index = index
    }
    
    func updateTableViewIfNeeded() {
//coredata
        self.viewModelDidChanged?(self)
        
    }
    
   
  
}
