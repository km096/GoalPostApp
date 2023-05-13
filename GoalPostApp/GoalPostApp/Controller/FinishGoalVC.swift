//
//  FinishGoalVC.swift
//  GoalPostApp
//
//  Created by ME-MAC on 2/6/23.
//

import UIKit
import CoreData

class FinishGoalVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var pointsTextField: UITextField!
    @IBOutlet weak var createGoalBtn: UIButton!
    
    var goalDescription: String!
    var goalType: GoalType!
    
    func initData(description: String, type: GoalType) {
        self.goalDescription = description
        self.goalType = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pointsTextField.delegate = self
        createGoalBtn.bindToKeyboard()
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        dismissDetail()
    }
    
    @IBAction func createGoalBtnTapped(_ sender: Any) {
        // Pass data into core data goal model
        if pointsTextField.text != "" {
            self.saveData { complete in
                if complete {
                    dismiss(animated: true)
                }
            }
        }
        
    }
    
    func saveData(completion: (_ finished: Bool) -> ()) {
        guard let mangedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: mangedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalCompletionValue = Int32(pointsTextField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try mangedContext.save()
            print("successfully saved data")
            completion(true)
        } catch {
            debugPrint("could not save : \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
    
}
