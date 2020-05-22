//
//  NewUnitViewController.swift
//  MVPSportNote
//
//  Created by Andrew Peneznyk on 21.05.2020.
//  Copyright © 2020 Andrew Penzenyk. All rights reserved.
//

import UIKit

protocol NewUnitDisplayLogic {
    func getNewExercise(title: String, index: Int)
}

class NewUnitViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    @IBOutlet weak var titileField: UITextField!
    @IBOutlet weak var unitField: UITextField!
    @IBOutlet weak var saveButton: UIButton!

    var delegate: NewUnitDisplayLogic?
    var modelView: NewUnitViewModelProtocol! {
        didSet {
            self.modelView.viewModelDidChanged = { [weak self] viewModel in
                guard let self = self else { return }
                
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titileField.text = modelView.getSelectedField()
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1
        saveButton.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        let pickerView = UIPickerView()
        pickerView.delegate = self

        unitField.inputView = pickerView
        unitField.text = modelView.getArray(index: 0)
    }
    
    
    @IBAction func saveAction(_ sender: Any) {
        self.delegate?.getNewExercise(title: modelView.getSelectedField(), index: modelView.getIndex())
        let tempviewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(tempviewControllers[tempviewControllers.count - 3], animated: true)
        

        print("kurva")
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return modelView.numberOfRowsInComponent()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return modelView.getArray(index: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        modelView.setIndex(index: row)
        unitField.text = modelView.getArray(index: row)

    }
    
}
