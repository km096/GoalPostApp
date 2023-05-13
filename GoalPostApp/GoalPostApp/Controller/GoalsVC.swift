//
//  ViewController.swift
//  GoalPostApp
//
//  Created by ME-MAC on 1/31/23.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var arrGoals: [Goal] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        self.fetchData { complete in
            if complete {
                if arrGoals.count >= 1 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }

    @IBAction func addGoalBtnTapped(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreatGoalVC") as? CreatGoalVC else {return}
        presentDetail(createGoalVC)
    }
    
}

extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else { return UITableViewCell() }
            let goal = arrGoals[indexPath.row]
            cell.configureCell(goal: goal)
            return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "DELETE") { rowAction, indexPath in
            self.removeGoal(atIndexpath: indexPath)
            self.fetchCoreDataObjects()
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "ADD 1") { rowAction, indexPath in
            self.setGoalProgress(atIndexPath: indexPath)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.9385008216, green: 0.7164282203, blue: 0.3331356049, alpha: 1)
        return [deleteAction, addAction]
    }
}

extension GoalsVC {
    
    
    func setGoalProgress(atIndexPath indexPath: IndexPath) {
        guard let mangedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = arrGoals[indexPath.row]
        if chosenGoal.goalProgress < chosenGoal.goalCompletionValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        do {
            try mangedContext.save()
            print("successfully sat progress")
        } catch {
            debugPrint("could not set progress: \(error.localizedDescription)")
        }

    }
    
    func removeGoal(atIndexpath indexPath: IndexPath) {
        guard let mangedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        mangedContext.delete(arrGoals[indexPath.row])
        
        do {
            try mangedContext.save()
            print("successfully removed goal")
        } catch {
            debugPrint("could not remove: \(error.localizedDescription)")
        }
    }
    
    func fetchData(completion: (_ complete: Bool) -> ()) {
        guard let mangedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            arrGoals = try mangedContext.fetch(fetchRequest)
            print("successfully fetched data")
            completion(true)
            
        } catch {
            debugPrint("could not fetch: \(error.localizedDescription)")
            completion(false)
        }
    }
}

